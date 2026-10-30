import 'dart:io';

import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart'; // AppColors, SurfaceCard, SectionHeader, fade()

/// ---------------------------------------------------------------------------
/// Reusable widgets for the Profile page. Presentation only.
/// ---------------------------------------------------------------------------

/// Circular profile picture with a gradient ring and an optional camera badge.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    this.imageFile,
    this.size = 120,
    this.showEditBadge = false,
    this.onEditTap,
  });

  final String name;
  final File? imageFile;
  final double size;
  final bool showEditBadge;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initial = name.trim().isNotEmpty
        ? name.trim().characters.first.toUpperCase()
        : '?';

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Gradient ring
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(4),
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
            child: Container(
              // Thin gap between the ring and the picture.
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.surface,
              ),
              child: ClipOval(
                child: imageFile != null
                    ? Image.file(imageFile!, fit: BoxFit.cover)
                    : Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          gradient: AppColors.brandGradient,
                        ),
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size * .38,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          if (showEditBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: AppColors.brandStart,
                shape: CircleBorder(
                  side: BorderSide(color: cs.surface, width: 3),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onEditTap,
                  child: const Padding(
                    padding: EdgeInsets.all(9),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A text field that looks like plain info in view mode and like an input
/// in edit mode.
class ProfileField extends StatelessWidget {
  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.editing,
    this.locked = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.helperText,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool editing;
  final bool locked; // never editable (e.g. member since)
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canEdit = editing && !locked;

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );

    return TextFormField(
      controller: controller,
      readOnly: !canEdit,
      keyboardType: keyboardType,
      validator: canEdit ? validator : null,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        helperText: canEdit ? helperText : null,
        prefixIcon: Icon(
          icon,
          size: 20,
          color: canEdit ? AppColors.brandStart : cs.onSurface.withAlpha(140),
        ),
        suffixIcon: locked
            ? Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: cs.onSurface.withAlpha(110),
              )
            : null,
        filled: canEdit,
        fillColor: cs.surfaceContainerHighest.withAlpha(90),
        border: border(Colors.transparent),
        enabledBorder: border(canEdit ? cs.outlineVariant : Colors.transparent),
        focusedBorder: border(AppColors.brandStart, 1.4),
        errorBorder: border(AppColors.loss),
        focusedErrorBorder: border(AppColors.loss, 1.4),
      ),
    );
  }
}

/// A card with a title and a list of children.
class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
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
      if (i != children.length - 1) spaced.add(const SizedBox(height: 14));
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

/// System / Light / Dark chooser.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ThemeMode>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: fade(AppColors.brandStart, .15),
          selectedForegroundColor: AppColors.brandStart,
        ),
        segments: const [
          ButtonSegment(
            value: ThemeMode.system,
            icon: Icon(Icons.brightness_auto_rounded, size: 18),
            label: Text('System'),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(Icons.light_mode_rounded, size: 18),
            label: Text('Light'),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(Icons.dark_mode_rounded, size: 18),
            label: Text('Dark'),
          ),
        ],
        selected: {value},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

/// Bottom sheet with Camera / Gallery / Remove choices.
/// Returns 'camera', 'gallery', 'remove' or null.
Future<String?> showPhotoSourceSheet(
  BuildContext context, {
  required bool hasPhoto,
}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(ctx, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(ctx, 'gallery'),
          ),
          if (hasPhoto)
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.loss,
              ),
              title: const Text(
                'Remove photo',
                style: TextStyle(color: AppColors.loss),
              ),
              onTap: () => Navigator.pop(ctx, 'remove'),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
