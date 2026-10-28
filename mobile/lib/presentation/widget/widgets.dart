import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// Shared presentation-only styles, helpers and small reusable widgets.
/// Nothing in here calculates financial values; values are passed in from the
/// existing screen state / ScripModel and only formatted for display.
/// ---------------------------------------------------------------------------

class AppColors {
  AppColors._();

  static const Color profit = Color(0xFF16A34A);
  static const Color profitLight = Color(0xFF4ADE80);
  static const Color loss = Color(0xFFDC2626);
  static const Color lossLight = Color(0xFFF87171);
  static const Color buy = Color(0xFF1D4ED8);
  static const Color buyLight = Color(0xFF60A5FA);
  static const Color brandStart = Color(0xFF4F46E5);
  static const Color brandEnd = Color(0xFF0EA5E9);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandStart, brandEnd],
  );
}

/// Returns [c] with the given opacity (0..1).
Color fade(Color c, double opacity) =>
    c.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());

/// Responsive horizontal page padding.
double pagePadding(double width) => (width * 0.04).clamp(12.0, 24.0);

/// UI-only numeric read of an existing value (used just to pick colours).
/// It never changes or replaces the value that is displayed.
double? uiNum(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString().replaceAll(',', '').trim());
}

enum PnlState { profit, loss, neutral }

PnlState pnlStateOf(Object? value) {
  final n = uiNum(value);
  if (n == null || n == 0) return PnlState.neutral;
  return n > 0 ? PnlState.profit : PnlState.loss;
}

Color pnlColor(PnlState s) {
  switch (s) {
    case PnlState.profit:
      return AppColors.profit;
    case PnlState.loss:
      return AppColors.loss;
    case PnlState.neutral:
      return Colors.blueGrey;
  }
}

/// DISPLAY-ONLY mapping to a 0.0 - 1.0 bar length.
/// The existing model has no profit-percentage field, so the bar length is
/// derived purely for visuals from the existing profit and total values
/// (a +/-25% move fills the bar). It is never shown as a financial number.
double indicatorStrength(String percentageProfit) {
  final p = double.parse(percentageProfit).abs();
  if (p == 0) return 0;
  return (p / 100).clamp(0, 1);
}

/// Slim animated profit / loss bar.
class ProfitLossIndicatorBar extends StatelessWidget {
  const ProfitLossIndicatorBar({
    super.key,
    required this.state,
    required this.strength,
    this.height = 6,
  });

  final PnlState state;
  final double strength;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = pnlColor(state);
    final light = state == PnlState.profit
        ? AppColors.profitLight
        : state == PnlState.loss
        ? AppColors.lossLight
        : Colors.blueGrey.shade200;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: strength.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: Container(
            height: height,
            color: fade(color, 0.14),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, light]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Small label + value pair that never overflows.
class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: .3,
            color: cs.onSurface.withAlpha(140),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

/// Section title with optional trailing widget.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Rounded surface card with a subtle shadow.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: cs.outlineVariant.withAlpha(90)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Gradient summary card at the top of the portfolio screen.
/// All values are optional, already-formatted text provided by the screen.
/// A null value renders as an em dash.
class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({
    super.key,
    this.userName,
    required this.holdingsCount,
    this.currentValueText,
    this.investedText,
    this.profitText,
    this.profitValue,
    required this.profitpercent,
  });
  final String? userName;
  final int holdingsCount;
  final String? currentValueText;
  final String? investedText;
  final String? profitText;
  final Object? profitValue;
  final String? profitpercent;

  @override
  Widget build(BuildContext context) {
    final state = pnlStateOf(profitValue);
    final plColor = state == PnlState.profit
        ? const Color(0xFFBBF7D0)
        : state == PnlState.loss
        ? const Color(0xFFFECACA)
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: fade(AppColors.brandStart, .35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  userName ?? 'Welcome',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$holdingsCount holdings',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Current value',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  currentValueText ?? '—',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: fade(plColor, .12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$profitpercent%',
                  style: TextStyle(
                    color: plColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    label: 'Invested',
                    value: investedText ?? '—',
                    color: Colors.white,
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.white24),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryStat(
                    label: state == PnlState.loss ? 'loss' : 'profit',
                    value: profitText ?? '—',
                    color: plColor,
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

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Visual content of one scrip row. Every value is passed in as-is from the
/// existing ScripModel; nothing is recalculated here.
class ScripInfoCard extends StatelessWidget {
  const ScripInfoCard({
    super.key,
    required this.name,
    required this.companyName,
    required this.kitta,
    required this.wacc,
    required this.total,
    required this.ltp,
    required this.currentProfit,
    required this.percentprofit,
  });

  final String name;
  final String companyName;
  final Object? kitta;
  final Object? wacc;
  final Object? total;
  final Object? ltp;
  final Object? currentProfit;
  final String percentprofit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = pnlStateOf(currentProfit);
    final color = pnlColor(state);
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';

    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      radius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      companyName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (state != PnlState.neutral)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: fade(color, .12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$percentprofit%',
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$currentProfit',
                        maxLines: 1,
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InfoTile(label: 'Units', value: '$kitta'),
              ),
              Expanded(
                child: InfoTile(label: 'WACC', value: '$wacc'),
              ),
              Expanded(
                child: InfoTile(label: 'LTP', value: '$ltp'),
              ),
              Expanded(
                child: InfoTile(label: 'Total', value: '$total'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProfitLossIndicatorBar(
            state: state,
            strength: indicatorStrength(percentprofit),
          ),
        ],
      ),
    );
  }
}
