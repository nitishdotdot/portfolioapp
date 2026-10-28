import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/datasource/local/localstorage.dart';
import 'package:portfolioapp/data/datasource/remote/auth_api_impl.dart';
import 'package:portfolioapp/data/repository/auth_repository_impl.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';
import 'package:portfolioapp/presentation/bloc/login_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';
import 'package:portfolioapp/presentation/pages/adminpage.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/pages/signup.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isobscured = true;

  // ---------------------------------------------------------------------
  // Existing email / password sign-in flow: logic UNCHANGED
  // ---------------------------------------------------------------------
  Future<void> _signIn(BuildContext context) async {
    AuthRepository authRepository = s1<AuthRepository>();
    final isValidated = await authRepository.signIn(
      email.text,
      password.text,
    );

    if (!isValidated) {
      // Wrong credentials: no valid token exists, so do NOT decode it.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('wrong credentials')),
        );
      }
      return;
    }

    final localstorage = s1<Localstorage>();
    final token = await localstorage.getToken();
    String role = JwtDecoder.decode(token.toString())['role'];

    if (context.mounted) {
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Portfolioapp()),
        );
      }
    }
  }

  // ---------------------------------------------------------------------
  // Existing Google sign-in flow: logic UNCHANGED
  // ---------------------------------------------------------------------
  Future<void> _googleSignIn(BuildContext context) async {
    // context.read<LoginBloc>().add(DoLogin());
    final authRepository = s1<AuthRepository>();
    final response = await authRepository.googleSignin();

    if (response != true) {
      // Sign-in failed or was cancelled: no valid token, so do NOT decode it.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error in google sign in')),
        );
      }
      return;
    }

    final localstorage = s1<Localstorage>();
    final token = await localstorage.getToken();
    String role = JwtDecoder.decode(token.toString())['role'];
    if (context.mounted) {
      if (role == 'user') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Portfolioapp()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AdminPage()),
        );
      }
    }
  }

  InputDecoration _fieldDecoration(
    BuildContext context,
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: cs.onSurface.withAlpha(12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.brandStart, width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is Loggedin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Portfolioapp()),
            );
          } else if (state is Logging) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.red,
                  rightDotColor: Colors.blueGrey,
                  size: 40,
                );
              },
            );
          }
        },
        builder: (context, state) {
          final cs = Theme.of(context).colorScheme;
          final topInset = MediaQuery.of(context).padding.top;
          final heroHeight = topInset + 230;
          const overlap = 56.0;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                // ---------------- Gradient hero ----------------
                Container(
                  height: heroHeight,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.only(top: topInset, bottom: overlap),
                  decoration: const BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -40,
                        top: -30,
                        child: _Circle(size: 170, opacity: .10),
                      ),
                      Positioned(
                        left: -50,
                        bottom: -40,
                        child: _Circle(size: 150, opacity: .08),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(45),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.show_chart_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Portfolio',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Track your shares with ease',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- Form card ----------------
                Padding(
                  padding: EdgeInsets.only(top: heroHeight - overlap),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          pagePadding(MediaQuery.of(context).size.width),
                          0,
                          pagePadding(MediaQuery.of(context).size.width),
                          MediaQuery.of(context).padding.bottom + 24,
                        ),
                        child: SurfaceCard(
                          radius: 28,
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'LOGIN',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: _fieldDecoration(
                                  context,
                                  'Email',
                                  Icons.mail_rounded,
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: password,
                                obscureText: isobscured,
                                decoration: _fieldDecoration(
                                  context,
                                  'Password',
                                  Icons.lock_rounded,
                                  suffix: IconButton(
                                    onPressed: () => {
                                      setState(() {
                                        isobscured = !isobscured;
                                      }),
                                    },
                                    icon: (isobscured)
                                        ? Icon(Icons.visibility_off_rounded)
                                        : Icon(Icons.visibility_rounded),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              _GradientButton(
                                label: 'LOGIN',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: () => _signIn(context),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: cs.onSurface.withAlpha(40),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'or',
                                      style: TextStyle(
                                        color: cs.onSurface.withAlpha(130),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: cs.onSurface.withAlpha(40),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: cs.outlineVariant,
                                  ),
                                ),
                                onPressed: () => _googleSignIn(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/google.png', height: 22),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        'Continue with Google',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: cs.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => Signup()),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          color: cs.onSurface.withAlpha(170),
                                        ),
                                      ),
                                      const Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: AppColors.brandStart,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha((opacity * 255).round()),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: fade(AppColors.brandStart, .35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
