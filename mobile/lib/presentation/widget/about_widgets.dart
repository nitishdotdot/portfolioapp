import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart'; // AppColors, SurfaceCard, SectionHeader, fade()

/// ---------------------------------------------------------------------------
/// Reusable widgets for the About page. Presentation only.
/// ---------------------------------------------------------------------------

/// Circular app logo + name + version + tagline.
class AboutHeader extends StatelessWidget {
  const AboutHeader({
    super.key,
    required this.appName,
    required this.version,
    required this.tagline,
  });

  final String appName;
  final String version;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.brandGradient,
            boxShadow: [
              BoxShadow(
                color: fade(AppColors.brandStart, .35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.show_chart_rounded,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          appName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        if (version.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: fade(AppColors.brandStart, .12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Version $version',
              style: const TextStyle(
                color: AppColors.brandStart,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        if (tagline.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            tagline,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: cs.onSurface.withAlpha(150)),
          ),
        ],
      ],
    );
  }
}

/// Card with a title and a paragraph of text.
class AboutTextCard extends StatelessWidget {
  const AboutTextCard({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: cs.onSurface.withAlpha(190),
            ),
          ),
        ],
      ),
    );
  }
}

/// One feature row: numbered icon badge, title and description.
class AboutFeatureTile extends StatelessWidget {
  const AboutFeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.color = AppColors.brandStart,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: fade(color, .12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: cs.onSurface.withAlpha(150),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Card with a title and several feature tiles.
class AboutFeaturesCard extends StatelessWidget {
  const AboutFeaturesCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) spaced.add(const SizedBox(height: 16));
    }
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          const SizedBox(height: 14),
          ...spaced,
        ],
      ),
    );
  }
}

/// A contact row. Tapping it copies the value to the clipboard.
class AboutContactTile extends StatelessWidget {
  const AboutContactTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: value));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label copied'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.brandStart),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: .3,
                      color: cs.onSurface.withAlpha(140),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.copy_rounded,
              size: 16,
              color: cs.onSurface.withAlpha(110),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small grey disclaimer line with an info icon.
class AboutDisclaimer extends StatelessWidget {
  const AboutDisclaimer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: cs.onSurface.withAlpha(130),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: cs.onSurface.withAlpha(140),
            ),
          ),
        ),
      ],
    );
  }
}
