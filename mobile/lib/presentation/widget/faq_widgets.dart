import 'package:flutter/material.dart';
// AppColors, SurfaceCard, fade()
import 'package:portfolioapp/presentation/widget/widgets.dart';

/// ---------------------------------------------------------------------------
/// Reusable widgets for the FAQ page. Presentation only.
/// ---------------------------------------------------------------------------

/// Search box shown at the top of the FAQ list.
class FaqSearchField extends StatelessWidget {
  const FaqSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search questions',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: cs.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.outlineVariant.withAlpha(90)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.outlineVariant.withAlpha(90)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.brandStart, width: 1.4),
        ),
      ),
    );
  }
}

/// One expandable question/answer card.
class FaqTile extends StatelessWidget {
  const FaqTile({
    super.key,
    required this.index,
    required this.question,
    required this.answer,
  });

  final int index; // shown as 1, 2, 3 ...
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      padding: EdgeInsets.zero,
      radius: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        // Removes the default lines ExpansionTile draws when open.
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(70, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            iconColor: AppColors.brandStart,
            collapsedIconColor: cs.onSurface.withAlpha(140),
            leading: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            title: Text(
              question,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            children: [
              Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: cs.onSurface.withAlpha(190),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Centered message used for loading, error and empty states.
class FaqStateMessage extends StatelessWidget {
  const FaqStateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.color = AppColors.brandStart,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: fade(color, .12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withAlpha(150),
                ),
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandStart,
                ),
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
