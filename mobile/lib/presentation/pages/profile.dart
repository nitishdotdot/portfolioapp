import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/models/about_user_model.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart'; // AppColors, pagePadding
import 'package:portfolioapp/presentation/widget/faq_widgets.dart'; // FaqStateMessage
import 'package:portfolioapp/presentation/widget/profile_widgets.dart';

/// Values shown on this page.
class ProfileData {
  const ProfileData({
    required this.name,
    this.email = '',
    this.phone = '',
    this.address = '',
    this.boid = '',
    this.memberSince = '',
    this.imagePath,
  });

  final String name;
  final String email;
  final String phone;
  final String address;
  final String boid; // demat / BOID number
  final String memberSince; // read-only
  final String? imagePath;

  ProfileData copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? boid,
    String? imagePath,
    bool clearImage = false,
  }) {
    return ProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      boid: boid ?? this.boid,
      memberSince: memberSince,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.themeMode = ThemeMode.system,
    this.onThemeChanged,
    this.onSave,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;

  /// Called when the user taps Save. Throw to show a failure message.
  final Future<void> Function(ProfileData data)? onSave;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // null until the data has been fetched -> this is what prevents the crash.
  ProfileData? _saved;
  bool _loading = true;
  String? _error;

  late ThemeMode _themeMode;
  File? _image;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _boid = TextEditingController();
  final _memberSince = TextEditingController();

  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
    _loadProfile();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _boid.dispose();
    _memberSince.dispose();
    super.dispose();
  }

  // ---- data ---------------------------------------------------------------

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userRepository = s1<UserRepository>();
      final AboutUserModel m = await userRepository.aboutuser();
      if (!mounted) return;

      // Only `name` is known from your model. When AboutUserModel has more
      // fields, add them here, e.g.  email: m.email, phone: m.phone ...
      _saved = ProfileData(
        name: m.name,
        // email: m.email,
        // phone: m.phone,
        // address: m.address,
        // boid: m.boid,
        // memberSince: m.createdAt,
      );
      _fillControllers();
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _fillControllers() {
    final d = _saved!;
    _name.text = d.name;
    _email.text = d.email;
    _phone.text = d.phone;
    _address.text = d.address;
    _boid.text = d.boid;
    _memberSince.text = d.memberSince.isEmpty ? '—' : d.memberSince;
    _image = d.imagePath != null ? File(d.imagePath!) : null;
  }

  // ---- actions ------------------------------------------------------------

  Future<void> _pickPhoto() async {
    final choice = await showPhotoSourceSheet(
      context,
      hasPhoto: _image != null,
    );
    if (choice == null) return;
    if (choice == 'remove') {
      setState(() => _image = null);
      return;
    }
    try {
      final picked = await _picker.pickImage(
        source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 80,
      );
      if (picked != null) setState(() => _image = File(picked.path));
    } catch (_) {
      _snack('Could not open the picker. Check app permissions.', error: true);
    }
  }

  void _cancel() {
    FocusScope.of(context).unfocus();
    setState(() {
      _fillControllers();
      _editing = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final data = _saved!.copyWith(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      boid: _boid.text.trim(),
      imagePath: _image?.path,
      clearImage: _image == null,
    );

    setState(() => _saving = true);
    try {
      // TODO: call your repository update method here once it exists.
      await widget.onSave?.call(data);
      if (!mounted) return;
      setState(() {
        _saved = data;
        _editing = false;
        _saving = false;
      });
      _snack('Profile updated');
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack('Could not save. Please try again.', error: true);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppColors.loss : AppColors.profit,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---- ui -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 1) still loading
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile'), centerTitle: true),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.brandStart),
        ),
      );
    }

    // 2) failed to load
    if (_error != null || _saved == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile'), centerTitle: true),
        body: FaqStateMessage(
          icon: Icons.wifi_off_rounded,
          color: AppColors.loss,
          title: 'Could not load profile',
          subtitle: 'Check your connection and try again.',
          actionLabel: 'Retry',
          onAction: _loadProfile,
        ),
      );
    }

    // 3) data is ready: _saved is safe to use from here on
    final saved = _saved!;
    final cs = Theme.of(context).colorScheme;
    final pad = pagePadding(MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        // Default back arrow is used: it pops back to the previous page.
        actions: [
          if (!_editing)
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _editing = true),
            )
          else
            TextButton(
              onPressed: _saving ? null : _cancel,
              child: const Text('Cancel'),
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brandStart,
          onRefresh: _loadProfile,
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(pad, 12, pad, 32),
              children: [
                Center(
                  child: ProfileAvatar(
                    name: saved.name,
                    imageFile: _image,
                    showEditBadge: _editing,
                    onEditTap: _pickPhoto,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  saved.name.isEmpty ? 'Your name' : saved.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  saved.email.isEmpty ? 'Add your email' : saved.email,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurface.withAlpha(150),
                  ),
                ),
                const SizedBox(height: 24),

                ProfileSectionCard(
                  title: 'Personal information',
                  children: [
                    ProfileField(
                      controller: _name,
                      label: 'Full name',
                      icon: Icons.person_outline_rounded,
                      editing: _editing,
                      validator: (v) => (v == null || v.trim().length < 2)
                          ? 'Enter your name'
                          : null,
                    ),
                    ProfileField(
                      controller: _email,
                      label: 'Email',
                      icon: Icons.mail_outline_rounded,
                      editing: _editing,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return null; // optional
                        return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s)
                            ? null
                            : 'Enter a valid email';
                      },
                    ),
                    ProfileField(
                      controller: _phone,
                      label: 'Phone number',
                      icon: Icons.phone_outlined,
                      editing: _editing,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return null; // optional
                        return RegExp(r'^[0-9+\-\s]{7,15}$').hasMatch(s)
                            ? null
                            : 'Enter a valid phone number';
                      },
                    ),
                    ProfileField(
                      controller: _address,
                      label: 'Address',
                      icon: Icons.location_on_outlined,
                      editing: _editing,
                      maxLines: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ProfileSectionCard(
                  title: 'Investment details',
                  children: [
                    ProfileField(
                      controller: _boid,
                      label: 'Demat (BOID) number',
                      icon: Icons.account_balance_outlined,
                      editing: _editing,
                      keyboardType: TextInputType.number,
                      helperText: '16 digits',
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return null; // optional
                        return RegExp(r'^\d{16}$').hasMatch(s)
                            ? null
                            : 'BOID must be 16 digits';
                      },
                    ),
                    ProfileField(
                      controller: _memberSince,
                      label: 'Member since',
                      icon: Icons.event_available_outlined,
                      editing: _editing,
                      locked: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ProfileSectionCard(
                  title: 'Appearance',
                  children: [
                    ThemeModeSelector(
                      value: _themeMode,
                      onChanged: (m) {
                        setState(() => _themeMode = m);
                        widget.onThemeChanged?.call(m);
                      },
                    ),
                  ],
                ),

                if (_editing) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.brandStart,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
