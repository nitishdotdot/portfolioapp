import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart'; // AppColors, pagePadding
import 'package:portfolioapp/presentation/widget/delete_account_widgets.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key, this.onDeleted});

  /// Called after the server confirms the deletion.
  /// Use it to clear the saved login and open your login page.
  final VoidCallback? onDeleted;

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  static const _confirmWord = 'DELETE';
  static const _reasons = [
    'Not useful',
    'Found a better app',
    'Privacy concerns',
    'Too many notifications',
    'Other',
  ];

  final _suggestion = TextEditingController();
  final _confirm = TextEditingController();

  String? _reason;
  bool _confirmed = false;
  bool _submitting = false;

  @override
  void dispose() {
    _suggestion.dispose();
    _confirm.dispose();
    super.dispose();
  }

  /// The single text sent to the server as `suggestion`.
  String _buildSuggestion() {
    final details = _suggestion.text.trim();
    final parts = <String>[
      if (_reason != null) _reason!,
      if (details.isNotEmpty) details,
    ];
    return parts.isEmpty ? 'No suggestion provided' : parts.join(' - ');
  }

  Future<void> _onDeletePressed() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'Your portfolio and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep my account'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.loss),
            ),
          ),
        ],
      ),
    );
    if (ok == true) await _submit();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    final suggestion = _buildSuggestion();
    final datetime = DateTime.now().toUtc().toIso8601String();

    final userRepository = s1<UserRepository>();
    // POST request: stores suggestion + datetime as feedback, then deletes.
    final deleted = await userRepository.deleteuser(suggestion, datetime);
    if (!mounted)
      return;
    else {
      if (deleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Loginpage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not delete the account. Please try again.'),
            backgroundColor: AppColors.loss,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = pagePadding(MediaQuery.of(context).size.width);
    final canDelete = _confirmed && !_submitting;

    return PopScope(
      canPop: !_submitting, // block back while the request is running
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Delete account',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(pad, 12, pad, 32),
            children: [
              const DeleteWarningCard(),
              const SizedBox(height: 16),
              const DeleteConsequencesCard(
                items: [
                  'Your holdings, buy and sell records',
                  'Your profit and loss history',
                  'Your profile and saved settings',
                  'Access to this account. You cannot get it back.',
                ],
              ),
              const SizedBox(height: 16),
              DeleteFeedbackCard(
                reasons: _reasons,
                selectedReason: _reason,
                onReasonChanged: (r) => setState(() => _reason = r),
                controller: _suggestion,
                enabled: !_submitting,
              ),
              const SizedBox(height: 16),
              DeleteConfirmCard(
                word: _confirmWord,
                controller: _confirm,
                enabled: !_submitting,
                onChanged: (v) => setState(
                  () => _confirmed = v.trim().toUpperCase() == _confirmWord,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.loss,
                    disabledBackgroundColor: fade(AppColors.loss, .3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: canDelete ? _onDeletePressed : null,
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Delete my account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _submitting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
