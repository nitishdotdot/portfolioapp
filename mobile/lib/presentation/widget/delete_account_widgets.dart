import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart'; // AppColors, SurfaceCard, SectionHeader, fade()

/// ---------------------------------------------------------------------------
/// Reusable widgets for the Delete Account page. Presentation only.
/// ---------------------------------------------------------------------------

/// Red warning card at the top of the page.
class DeleteWarningCard extends StatelessWidget {
  const DeleteWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.loss, Color(0xFFB91C1C)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: fade(AppColors.loss, .35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This cannot be undone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Deleting your account removes your data permanently.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card listing what will be lost.
class DeleteConsequencesCard extends StatelessWidget {
  const DeleteConsequencesCard({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'What will be deleted'),
          const SizedBox(height: 12),
          for (final text in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.remove_circle_outline_rounded,
                    size: 18,
                    color: AppColors.loss,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: cs.onSurface.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Chips for choosing a quick reason, plus a free-text box for details.
class DeleteFeedbackCard extends StatelessWidget {
  const DeleteFeedbackCard({
    super.key,
    required this.reasons,
    required this.selectedReason,
    required this.onReasonChanged,
    required this.controller,
    this.enabled = true,
  });

  final List<String> reasons;
  final String? selectedReason;
  final ValueChanged<String?> onReasonChanged;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Help us improve'),
          const SizedBox(height: 4),
          Text(
            'Why are you leaving? (optional)',
            style: TextStyle(fontSize: 13, color: cs.onSurface.withAlpha(150)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final r in reasons)
                ChoiceChip(
                  label: Text(r),
                  selected: selectedReason == r,
                  selectedColor: fade(AppColors.brandStart, .15),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedReason == r
                        ? AppColors.brandStart
                        : cs.onSurface,
                  ),
                  onSelected: enabled
                      ? (on) => onReasonChanged(on ? r : null)
                      : null,
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            enabled: enabled,
            maxLines: 4,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: 'Tell us more or share a suggestion',
              filled: true,
              fillColor: cs.surfaceContainerHighest.withAlpha(90),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.brandStart,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card where the user types a word to confirm.
class DeleteConfirmCard extends StatelessWidget {
  const DeleteConfirmCard({
    super.key,
    required this.word,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  final String word; // e.g. DELETE
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Confirm'),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withAlpha(150),
              ),
              children: [
                const TextSpan(text: 'Type '),
                TextSpan(
                  text: word,
                  style: const TextStyle(
                    color: AppColors.loss,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' to enable the delete button.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            enabled: enabled,
            onChanged: onChanged,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: word,
              prefixIcon: const Icon(Icons.shield_outlined, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.loss, width: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
