import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { parseYAML } from 'confbox/yaml';
import { certificateAuthorities, stripQuotes } from './npmConfig.js';
import { findUp } from './projectPin.js';
import { DEFAULT_REGISTRY, isUrlSecureForCredentials, normalizeRegistry } from './registry.js';
/**
 * The registry to download pnpm from, with the credentials and CA certificates
 * for it, read the way pnpm reads them for an `@pnpm` package.
 *
 * - Sources, highest first: the project `.npmrc` (the workspace root's, or else
 *   the one in `cwd`), then the user `.npmrc`. Only top-level settings count.
 * - The registry is `@pnpm:registry`, then `registry` from the environment,
 *   then `registry`.
 * - `${VAR}` placeholders are expanded in the user `.npmrc` only. A project
 *   `.npmrc` entry that has one is dropped, as pnpm drops it: a repository
 *   must not route the user's environment to a registry.
 * - Credentials are those of the `@pnpm` scope, then the registry-wide ones,
 *   for the longest `//host[:port]/path/` prefix of the registry, then the
 *   same without the port.
 */
export function pnpmRegistryConfig(opts) {
    const env = opts.env ?? process.env;
    const cwd = opts.cwd ?? process.cwd();
    const sources = [
        ...(opts.readProjectNpmrc ? [readNpmrc(path.join(projectDir(cwd), '.npmrc'), projectEntry)] : []),
        readNpmrc(userNpmrcPath(env, opts.homeDir), (key, value) => [expandEnv(key, env), expandEnv(value, env)]),
    ];
    const settings = new Map([...sources].reverse().flatMap(({ entries }) => entries));
    const registry = normalizeRegistry(settings.get('@pnpm:registry') || settingFromEnv(env, 'registry') || settings.get('registry') || DEFAULT_REGISTRY);
    const headers = npmrcHeaders(settings, registry);
    const ca = certificateAuthorities(registry, sources);
    return {
        registry,
        ...(headers == null ? {} : { headers }),
        ...(ca.length === 0 ? {} : { ca }),
    };
}
/**
 * The proxy to download pnpm through, resolved the way pnpm resolves it for
 * `pnpm self-update` and the download of the version a project pins.
 *
 * - Each of `httpsProxy`, `httpProxy`, `noProxy`, `proxy`, and `noproxy`
 *   comes from the first source that names it, highest first: the
 *   `PNPM_CONFIG_*` variables, then the global `config.yaml`, then the user
 *   `.npmrc`. The project's `.npmrc` and `pnpm-workspace.yaml` do not count.
 * - An empty, `false`, or `null` value reads as unset. `proxy` then stands in
 *   for `httpsProxy`, and `noproxy` for `noProxy`, and after them
 *   `HTTPS_PROXY`, `HTTP_PROXY`, `PROXY`, and `NO_PROXY` apply.
 * - The HTTP proxy defaults to the HTTPS one. `proxy` set to `false` turns
 *   both off, the environment included.
 *
 * @throws if the global `config.yaml` cannot be read or parsed, as pnpm does.
 */
export function pnpmProxyConfig(opts = {}) {
    const env = opts.env ?? process.env;
    const npmrc = new Map(readNpmrc(userNpmrcPath(env, opts.homeDir), (key, value) => [expandEnv(key, env), expandEnv(value, env)]).entries);
    const overlays = [
        {
            httpsProxy: pnpmSettingFromEnv(env, 'https_proxy'),
            httpProxy: pnpmSettingFromEnv(env, 'http_proxy'),
            noProxy: pnpmSettingFromEnv(env, 'no_proxy'),
            noproxy: pnpmSettingFromEnv(env, 'noproxy'),
            proxy: pnpmSettingFromEnv(env, 'proxy'),
        },
        readGlobalConfigProxySettings(opts, env),
        {
            httpsProxy: npmrc.get('https-proxy'),
            httpProxy: npmrc.get('http-proxy'),
            noProxy: npmrc.get('no-proxy'),
            noproxy: npmrc.get('noproxy'),
            proxy: npmrc.get('proxy'),
        },
    ];
    const legacyProxy = overlaid(overlays, 'proxy');
    const httpsProxySetting = proxyUrl(overlaid(overlays, 'httpsProxy')) ??
        (legacyProxy === false || legacyProxy === 'false' ? false : proxyUrl(legacyProxy));
    const httpsProxy = httpsProxySetting === false ? undefined : httpsProxySetting ?? envValue(env, 'https_proxy');
    const httpProxy = proxyUrl(overlaid(overlays, 'httpProxy')) ??
        (httpsProxySetting === false ? undefined : httpsProxy ?? envValue(env, 'http_proxy') ?? envValue(env, 'proxy'));
    const noProxy = noProxyValue(overlaid(overlays, 'noProxy')) ?? noProxyValue(overlaid(overlays, 'noproxy')) ?? envValue(env, 'no_proxy');
    return {
        ...(httpsProxy == null ? {} : { HTTPS_PROXY: httpsProxy }),
        ...(httpProxy == null ? {} : { HTTP_PROXY: httpProxy }),
        ...(noProxy == null ? {} : { NO_PROXY: noProxy }),
    };
}
function overlaid(overlays, key) {
    return overlays.find((overlay) => overlay[key] !== undefined)?.[key];
}
function proxyUrl(value) {
    return typeof value === 'string' && !UNSET_VALUES.has(value) ? value : undefined;
}
/** `true` bypasses the proxy for every host, which Node.js spells `*`. */
function noProxyValue(value) {
    return value === true ? '*' : proxyUrl(value);
}
const UNSET_VALUES = new Set(['', 'false', 'null']);
function pnpmSettingFromEnv(env, key) {
    return env[`pnpm_config_${key}`] ?? env[`PNPM_CONFIG_${key.toUpperCase()}`];
}
function envValue(env, key) {
    return env[key] ?? env[key.toUpperCase()];
}
function readGlobalConfigProxySettings(opts, env) {
    const file = path.join(pnpmConfigDir(opts, env), 'config.yaml');
    let settings;
    try {
        settings = parseYAML(fs.readFileSync(file, 'utf8'));
    }
    catch (err) {
        if (err.code === 'ENOENT')
            return {};
        throw new Error(`Could not read ${file}: ${err.message}`, { cause: err });
    }
    if (settings == null)
        return {};
    if (typeof settings !== 'object' || Array.isArray(settings)) {
        throw new Error(`${file} does not hold a map of settings.`);
    }
    const { httpsProxy, httpProxy, noProxy, noproxy, proxy } = settings;
    return {
        httpsProxy: expandEnvIn(httpsProxy, env),
        httpProxy: expandEnvIn(httpProxy, env),
        noProxy: expandEnvIn(noProxy, env),
        noproxy: expandEnvIn(noproxy, env),
        proxy: expandEnvIn(proxy, env),
    };
}
/** A null value leaves the setting to a lower source, as pnpm reads the file. */
function expandEnvIn(value, env) {
    if (value === null)
        return undefined;
    return typeof value === 'string' ? expandEnv(value, env) : value;
}
/** The directory pnpm keeps the global `config.yaml` in. */
function pnpmConfigDir(opts, env) {
    const platform = opts.platform ?? process.platform;
    const dirFromEnv = (name) => {
        const value = env[name];
        return value && platform === 'win32' ? expandWindowsEnv(name, value, env) : value || undefined;
    };
    const xdgConfigHome = dirFromEnv('XDG_CONFIG_HOME');
    if (xdgConfigHome)
        return path.join(xdgConfigHome, 'pnpm');
    const homeDir = opts.homeDir ?? os.homedir();
    if (platform === 'darwin')
        return path.join(homeDir, 'Library/Preferences/pnpm');
    const localAppData = platform === 'win32' ? dirFromEnv('LOCALAPPDATA') : undefined;
    if (localAppData)
        return path.join(localAppData, 'pnpm/config');
    return path.join(homeDir, '.config/pnpm');
}
/** The longest value Windows allows in an environment variable. */
const MAX_WINDOWS_ENV_LENGTH = 32_767;
/**
 * Expands the `%NAME%` references Windows leaves in a value it did not expand
 * itself, as pnpm does before using the value as a directory.
 *
 * @throws if a reference names no variable, as pnpm does.
 */
function expandWindowsEnv(name, value, env) {
    const lookup = (varName) => {
        const key = Object.keys(env).find((candidate) => candidate.toUpperCase() === varName.toUpperCase());
        return key == null ? undefined : env[key];
    };
    let current = value;
    // Bounded, because a variable can reference itself, even twice over.
    for (let round = 0; round < 32 && current.includes('%'); round++) {
        const next = current.replace(/%([^%]+)%/g, (reference, varName) => lookup(varName) ?? reference);
        if (next === current || next.length > MAX_WINDOWS_ENV_LENGTH)
            break;
        current = next;
    }
    const unexpanded = /%[^%]+%/.exec(current);
    if (unexpanded != null) {
        throw new Error(`${name} contains an unexpanded environment variable: ${unexpanded[0]}`);
    }
    return current;
}
function settingFromEnv(env, key) {
    const upper = key.toUpperCase();
    return env[`pnpm_config_${key}`] || env[`PNPM_CONFIG_${upper}`] ||
        env[`npm_config_${key}`] || env[`NPM_CONFIG_${upper}`] || undefined;
}
function userNpmrcPath(env, homeDir) {
    return settingFromEnv(env, 'userconfig') ?? path.join(homeDir ?? os.homedir(), '.npmrc');
}
function projectEntry(key, value, file) {
    if (!key.includes('${') && !value.includes('${'))
        return [key, value];
    if (key.startsWith('//') || key === 'registry' || key.endsWith(':registry')) {
        console.warn(`Ignored ${key} from ${file}: a project .npmrc cannot use environment variables in registry settings or credentials.`);
    }
    return undefined;
}
function projectDir(cwd) {
    const start = path.resolve(cwd);
    return findUp(start, undefined, (dir) => fs.existsSync(path.join(dir, 'pnpm-workspace.yaml'))) ?? start;
}
function readNpmrc(file, parseEntry) {
    const source = { dir: path.dirname(file), entries: [] };
    for (const [key, value] of topLevelSettings(readNpmrcText(file))) {
        const entry = parseEntry(key, value, file);
        if (entry != null)
            source.entries.push(entry);
    }
    return source;
}
function readNpmrcText(file) {
    try {
        return fs.readFileSync(file, 'utf8');
    }
    catch (err) {
        const { code } = err;
        if (code !== 'ENOENT' && code !== 'EISDIR') {
            console.warn(`Could not read ${file}, so its settings are not used: ${err.message}`);
        }
        return '';
    }
}
function topLevelSettings(text) {
    const settings = [];
    for (const rawLine of text.split(/\r?\n/)) {
        const line = rawLine.trim();
        // Settings under a `[section]` are not top-level ones.
        if (line.startsWith('['))
            break;
        const separator = line.indexOf('=');
        if (separator === -1 || line.startsWith(';') || line.startsWith('#'))
            continue;
        settings.push([line.slice(0, separator).trim(), stripQuotes(line.slice(separator + 1).trim())]);
    }
    return settings;
}
/**
 * Replaces `${NAME}` with the variable, or with nothing when it is unset.
 * `${NAME-fallback}` falls back when the variable is unset, and
 * `${NAME:-fallback}` also when it is empty, as in pnpm.
 */
function expandEnv(value, env) {
    return value.replace(/\$\{([^${}]+)\}/g, (_match, expression) => {
        const dash = expression.indexOf('-');
        if (dash === -1)
            return env[expression] ?? '';
        const fallbackOnEmpty = expression[dash - 1] === ':';
        const variable = env[expression.slice(0, fallbackOnEmpty ? dash - 1 : dash)];
        const fallback = expression.slice(dash + 1);
        return (fallbackOnEmpty ? variable || undefined : variable) ?? fallback;
    });
}
function npmrcHeaders(settings, registry) {
    const url = new URL(registry);
    if (!isUrlSecureForCredentials(url))
        return undefined;
    const prefixes = registryPrefixes(url);
    for (const scope of [':@pnpm', '']) {
        for (const prefix of prefixes) {
            const authorization = npmrcAuthorization(settings, `${prefix}${scope}`);
            if (authorization != null)
                return { authorization };
        }
    }
    return undefined;
}
/** Each `//host[:port]/path/` prefix of `url`, longest first, then the same without the port. */
function registryPrefixes(url) {
    const prefixes = [];
    for (const host of new Set([url.host, url.hostname])) {
        let pathname = url.pathname;
        while (true) {
            prefixes.push(`//${host}${pathname}`);
            if (pathname === '/')
                break;
            pathname = pathname.slice(0, pathname.lastIndexOf('/', pathname.length - 2) + 1);
        }
    }
    return prefixes;
}
function npmrcAuthorization(settings, prefix) {
    const token = settings.get(`${prefix}:_authToken`);
    if (token)
        return `Bearer ${token}`;
    const auth = settings.get(`${prefix}:_auth`);
    if (auth)
        return `Basic ${auth}`;
    const username = settings.get(`${prefix}:username`);
    const password = settings.get(`${prefix}:_password`);
    if (username && password) {
        return `Basic ${base64(`${username}:${Buffer.from(password, 'base64').toString('utf8')}`)}`;
    }
    return undefined;
}
function base64(text) {
    return Buffer.from(text, 'utf8').toString('base64');
}
