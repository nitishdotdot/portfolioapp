import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/models/about_model.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/widget/about_widgets.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart'; // AppColors, pagePadding
import 'package:portfolioapp/presentation/widget/faq_widgets.dart'; // FaqStateMessage

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  AboutModel? _about; // null until the API answers
  bool _loading = true;
  String? _error;

  // Feature icons and colors are chosen by the app (not the server).
  static const _icons = [
    Icons.bolt_rounded,
    Icons.pie_chart_outline_rounded,
    Icons.receipt_long_outlined,
    Icons.notifications_active_outlined,
    Icons.lock_outline_rounded,
    Icons.sync_rounded,
  ];
  static const _colors = [
    AppColors.brandStart,
    AppColors.profit,
    AppColors.buy,
    AppColors.brandEnd,
    AppColors.loss,
  ];

  @override
  void initState() {
    super.initState();
    _loadAbout();
  }

  Future<void> _loadAbout() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userRepository = s1<UserRepository>();
      final AboutModel data = await userRepository.aboutApp();
      if (!mounted) return;
      setState(() {
        _about = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Portfolioapp()),
          );
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text('About', style: TextStyle(fontWeight: FontWeight.w700)),
      centerTitle: true,
    );

    if (_loading) {
      return Scaffold(
        appBar: appBar,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.brandStart),
        ),
      );
    }

    if (_error != null || _about == null) {
      return Scaffold(
        appBar: appBar,
        body: FaqStateMessage(
          icon: Icons.wifi_off_rounded,
          color: AppColors.loss,
          title: 'Could not load About',
          subtitle: 'Check your connection and try again.',
          actionLabel: 'Retry',
          onAction: _loadAbout,
        ),
      );
    }

    final a = _about!;
    final pad = pagePadding(MediaQuery.of(context).size.width);

    final contacts = <Widget>[
      if (a.developerName.isNotEmpty)
        AboutContactTile(
          icon: Icons.code_rounded,
          label: 'Developer',
          value: a.developerName,
        ),
      if (a.supportEmail.isNotEmpty)
        AboutContactTile(
          icon: Icons.mail_outline_rounded,
          label: 'Support email',
          value: a.supportEmail,
        ),
      if (a.website.isNotEmpty)
        AboutContactTile(
          icon: Icons.language_rounded,
          label: 'Website',
          value: a.website,
        ),
    ];

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brandStart,
          onRefresh: _loadAbout,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(pad, 16, pad, 32),
            children: [
              AboutHeader(
                appName: a.appName,
                version: a.version,
                tagline: a.tagline,
              ),
              const SizedBox(height: 24),

              if (a.description.isNotEmpty) ...[
                AboutTextCard(title: 'About the app', text: a.description),
                const SizedBox(height: 16),
              ],

              if (a.features.isNotEmpty) ...[
                AboutFeaturesCard(
                  title: 'What you can do',
                  children: [
                    for (var i = 0; i < a.features.length; i++)
                      AboutFeatureTile(
                        icon: _icons[i % _icons.length],
                        color: _colors[i % _colors.length],
                        title: a.features[i].title,
                        description: a.features[i].description,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (contacts.isNotEmpty) ...[
                AboutFeaturesCard(title: 'Contact', children: contacts),
                const SizedBox(height: 16),
              ],

              if (a.disclaimer.isNotEmpty) AboutDisclaimer(text: a.disclaimer),
            ],
          ),
        ),
      ),
    );
  }
}
