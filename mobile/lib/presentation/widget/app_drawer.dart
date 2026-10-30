import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

/// Presentation-only navigation drawer. All navigation and the sign-out
/// logic stay in your screen and are passed in as callbacks, so the existing
/// behaviour is unchanged.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.name,
    required this.email,
    required this.onProfile,
    required this.onSettings,
    required this.onHistory,
    required this.onFaq,
    required this.onVersion,
    required this.onLogoutConfirmed,
  });

  final String? name;
  final String? email;
  final VoidCallback onProfile;
  final VoidCallback onSettings;
  final VoidCallback onVersion;
  final VoidCallback onHistory;
  final VoidCallback onFaq;
  final VoidCallback onLogoutConfirmed;

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: fade(AppColors.loss, .12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.logout_rounded, color: AppColors.loss),
        ),
        title: const Text('Are you sure?'),
        content: const Text(
          'You will be signed out of your account.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.loss),
            onPressed: onLogoutConfirmed,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenW = MediaQuery.of(context).size.width;
    final displayName = (name == null || name!.isEmpty)
        ? 'Your profile'
        : name!;
    final initial = displayName.characters.first.toUpperCase();

    return Drawer(
      width: math.min(screenW * .9, 380),
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // ---------------- Header ----------------
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              8,
              MediaQuery.of(context).padding.top + 8,
              8,
              20,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _confirmLogout(context),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onProfile,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(45),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white54, width: 2),
                          ),
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (email != null)
                                Text(
                                  email!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Menu ----------------
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                12,
                8,
                12,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              children: [
                const _SectionLabel('Settings'),
                _DrawerTile(
                  icon: Icons.settings_rounded,
                  title: 'Setting',
                  onTap: onSettings,
                ),
                const _SectionLabel('My Portfolio'),
                _DrawerTile(
                  icon: Icons.monetization_on_rounded,
                  title: 'My Shares',
                  selected: true,
                  // You are already on this screen, so just close the drawer.
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerTile(
                  icon: Icons.history_rounded,
                  title: 'History',
                  onTap: onHistory,
                ),
                const _SectionLabel('About'),
                _DrawerTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Faqs',
                  onTap: onFaq,
                ),
                const _DrawerTile(
                  icon: Icons.phone_android_rounded,
                  title: 'About',
                ),
                _DrawerTile(
                  icon: Icons.android_rounded,
                  title: 'Version',
                  onTap: onVersion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = selected ? AppColors.brandStart : cs.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: selected ? fade(AppColors.brandStart, .10) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: selected
                ? fade(AppColors.brandStart, .15)
                : cs.onSurface.withAlpha(14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: accent.withAlpha(selected ? 255 : 190),
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: accent,
          ),
        ),
        trailing: onTap == null || selected
            ? null
            : Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withAlpha(100),
              ),
      ),
    );
  }
}
