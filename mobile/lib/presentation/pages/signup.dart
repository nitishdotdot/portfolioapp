import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/repository/auth_repository_impl.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isobsured = true;
  String? name1;
  String? email1;
  String? password1;

  // ---------------------------------------------------------------------
  // Existing sign-up flow: logic UNCHANGED
  // ---------------------------------------------------------------------
  Future<void> _signUp(BuildContext context) async {
    final authRepository = s1<AuthRepository>();
    final response = await authRepository.signUp(
      name.text,
      email.text,
      password.text,
    );
    if (context.mounted) {
      if (response == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Loginpage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error in signup')),
        );
      }
    }
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Loginpage()),
    );
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
    final cs = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final topInset = media.padding.top;
    final heroHeight = topInset + 230;
    const overlap = 56.0;
    final side = pagePadding(media.size.width);

    return Scaffold(
      body: SingleChildScrollView(
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
                  Positioned(
                    left: 4,
                    top: 4,
                    child: IconButton(
                      onPressed: () => _goToLogin(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
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
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Create account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Start tracking your shares today',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
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
                      side,
                      0,
                      side,
                      media.padding.bottom + 24,
                    ),
                    child: SurfaceCard(
                      radius: 28,
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'SIGNUP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: name,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            decoration: _fieldDecoration(
                              context,
                              'Name',
                              Icons.person_rounded,
                            ),
                          ),
                          const SizedBox(height: 14),
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
                            obscureText: isobsured,
                            controller: password,
                            decoration: _fieldDecoration(
                              context,
                              'Password',
                              Icons.lock_rounded,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isobsured = !isobsured;
                                  });
                                },
                                icon: isobsured
                                    ? Icon(Icons.visibility_off_rounded)
                                    : Icon(Icons.visibility_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          _GradientButton(
                            label: 'SIGN UP',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: () => _signUp(context),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _goToLogin(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: cs.onSurface.withAlpha(170),
                                    ),
                                  ),
                                  const Text(
                                    'Login',
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
