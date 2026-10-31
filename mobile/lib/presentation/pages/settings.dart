import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/pages/brokerage.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/pages/version.dart';
import 'faq.dart'; // must contain the `Faq` class
import 'package:portfolioapp/presentation/widget/widgets.dart';
import 'package:portfolioapp/presentation/widget/settings_widgets.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/presentation/pages/profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.userName, required this.email});

  final String? userName;
  final String? email;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Local UI state. Later, load/save these (e.g. SharedPreferences).
  bool _darkMode = false;
  bool _hideBalances = false;
  bool _biometricLock = false;
  bool _priceAlerts = true;
  bool _dailySummary = false;

  /// Every row routes here for now. Replace per row later.
  void _openFaq() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Faq()));
  }

  void _openBrokerage() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Brokerage()));
  }

  void _opeProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
  }

  void _opeVersion() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Version()));
  }

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will need to sign in again to see your portfolio.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Log out',
              style: TextStyle(color: AppColors.loss),
            ),
          ),
        ],
      ),
    );
    if (ok == true) {
      // TODO: call your logout logic here.
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final pad = pagePadding(width);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Portfolioapp()),
            );
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(pad, 8, pad, 32),
          children: [
            SettingsProfileHeader(
              name: widget.userName ?? 'Investor',
              email: widget.email ?? 'Tap to edit your profile',
            ),
            const SizedBox(height: 24),

            SettingsSection(
              title: 'Account',
              children: [
                SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit profile',
                  subtitle: 'Name, email and phone number',
                  onTap: _opeProfile,
                ),
                SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change password',
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.account_balance_outlined,
                  title: 'Linked accounts',
                  subtitle: 'Demat and broker accounts',
                  onTap: _openFaq,
                ),
              ],
            ),
            const SizedBox(height: 20),

            SettingsSection(
              title: 'Portfolio',
              children: [
                SettingsTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Transaction history',
                  subtitle: 'All your buy and sell records',
                  iconColor: AppColors.buy,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.payments_outlined,
                  title: 'Brokerage & fees',
                  subtitle: 'Commission, SEBON and DP charges',
                  iconColor: AppColors.buy,
                  onTap: _openBrokerage,
                ),
                SettingsTile(
                  icon: Icons.upload_file_rounded,
                  title: 'Import data',
                  subtitle: 'Add holdings from a file',
                  iconColor: AppColors.buy,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.download_rounded,
                  title: 'Export data',
                  subtitle: 'Download your portfolio as a CSV file',
                  iconColor: AppColors.buy,
                  onTap: _openFaq,
                ),
              ],
            ),
            const SizedBox(height: 20),

            SettingsSection(
              title: 'Notifications',
              children: [
                SettingsSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Price alerts',
                  subtitle: 'Get notified when a scrip hits your target',
                  iconColor: AppColors.profit,
                  value: _priceAlerts,
                  onChanged: (v) => setState(() => _priceAlerts = v),
                ),
                SettingsSwitchTile(
                  icon: Icons.today_outlined,
                  title: 'Daily summary',
                  subtitle: 'Profit and loss recap after market close',
                  iconColor: AppColors.profit,
                  value: _dailySummary,
                  onChanged: (v) => setState(() => _dailySummary = v),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SettingsSection(
              title: 'Preferences',
              children: [
                SettingsSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark mode',
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
                SettingsSwitchTile(
                  icon: Icons.visibility_off_outlined,
                  title: 'Hide balances',
                  subtitle: 'Mask your values on the portfolio screen',
                  value: _hideBalances,
                  onChanged: (v) => setState(() => _hideBalances = v),
                ),
                SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailingText: 'English',
                  onTap: _openFaq,
                ),
              ],
            ),
            const SizedBox(height: 20),

            SettingsSection(
              title: 'Security',
              children: [
                SettingsSwitchTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric lock',
                  subtitle: 'Ask for fingerprint or face to open the app',
                  iconColor: AppColors.loss,
                  value: _biometricLock,
                  onChanged: (v) => setState(() => _biometricLock = v),
                ),
                SettingsTile(
                  icon: Icons.devices_outlined,
                  title: 'Active sessions',
                  subtitle: 'Devices where you are logged in',
                  iconColor: AppColors.loss,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.person_remove,
                  title: 'Delete Account',
                  subtitle: 'Delete your account permanently',
                  iconColor: AppColors.loss,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Do you want to delete your account'),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final userrepo = s1<UserRepository>();
                                      final isDeleted = await userrepo
                                          .deleteuser();
                                      if (isDeleted) {
                                        if (context.mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Loginpage(),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('some error occured'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('yes'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('no'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            SettingsSection(
              title: 'Help & support',
              children: [
                SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'FAQ',
                  subtitle: 'Answers to common questions',
                  iconColor: AppColors.brandEnd,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.support_agent_rounded,
                  title: 'Contact support',
                  iconColor: AppColors.brandEnd,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Report a problem',
                  iconColor: AppColors.brandEnd,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate the app',
                  iconColor: AppColors.brandEnd,
                  onTap: _openFaq,
                ),
              ],
            ),
            const SizedBox(height: 20),

            SettingsSection(
              title: 'About',
              children: [
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of service',
                  iconColor: Colors.blueGrey,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy policy',
                  iconColor: Colors.blueGrey,
                  onTap: _openFaq,
                ),
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'App version',
                  iconColor: Colors.blueGrey,
                  onTap: _opeVersion,
                ),
              ],
            ),
            const SizedBox(height: 20),

            SettingsSection(
              title: 'Danger zone',
              children: [
                SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Log out',
                  iconColor: AppColors.loss,
                  onTap: _confirmLogout,
                ),
                // TODO: put YOUR existing delete-account widget here, e.g.
                // const DeleteAccountTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
