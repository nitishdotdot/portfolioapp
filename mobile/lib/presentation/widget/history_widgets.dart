import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

/// Animated ALL / BUY / SELL switch. The indices match the existing `i`
/// state of the History page: 0 = ALL, 1 = BUY, 2 = SELL.
class HistoryFilterBar extends StatelessWidget {
  const HistoryFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.buyCount,
    required this.sellCount,
  });

  final int selected;
  final ValueChanged<int> onChanged;
  final int buyCount;
  final int sellCount;

  static const _labels = ['ALL', 'BUY', 'SELL'];

  List<Color> _gradientFor(int index) {
    switch (index) {
      case 1:
        return const [AppColors.buy, AppColors.buyLight];
      case 2:
        return const [AppColors.loss, AppColors.lossLight];
      default:
        return const [AppColors.brandStart, AppColors.brandEnd];
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final counts = [buyCount + sellCount, buyCount, sellCount];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withAlpha(90)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final segment = c.maxWidth / 3;
          return SizedBox(
            height: 46,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  left: selected * segment,
                  width: segment,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _gradientFor(selected)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var index = 0; index < 3; index++)
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onChanged(index),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _labels[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                      fontSize: 13,
                                      color: index == selected
                                          ? Colors.white
                                          : cs.onSurface.withAlpha(150),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${counts[index]}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: index == selected
                                          ? Colors.white70
                                          : cs.onSurface.withAlpha(110),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: fade(color, .12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: .6,
        ),
      ),
    );
  }
}

class _TxIcon extends StatelessWidget {
  const _TxIcon({required this.isBuy});
  final bool isBuy;

  @override
  Widget build(BuildContext context) {
    final colors = isBuy
        ? const [AppColors.buy, AppColors.buyLight]
        : const [AppColors.loss, AppColors.lossLight];
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        isBuy ? Icons.add_shopping_cart_rounded : Icons.sell_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

/// One buy-history entry. Values are shown exactly as the model provides them.
class BuyHistoryCard extends StatelessWidget {
  const BuyHistoryCard({
    super.key,
    required this.name,
    required this.kitta,
    required this.price,
    required this.date,
  });

  final String name;
  final Object? kitta;
  final Object? price;
  final String date;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const _TxIcon(isBuy: true),
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
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: cs.onSurface.withAlpha(130),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withAlpha(140),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const _TypeBadge(label: 'BUY', color: AppColors.buy),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: InfoTile(label: 'Units', value: '$kitta'),
              ),
              Expanded(
                child: InfoTile(label: 'Buy price', value: '$price'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One sell-history entry, with the existing profit shown prominently.
class SellHistoryCard extends StatelessWidget {
  const SellHistoryCard({
    super.key,
    required this.name,
    required this.kitta,
    required this.price,
    required this.date,
    required this.profit,
    required this.total,
    required this.profitPercent,
  });

  final String name;
  final Object? kitta;
  final Object? price;
  final String date;
  final String? profit;
  final String? total;
  final double profitPercent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = pnlStateOf(profit);
    final color = pnlColor(state);
    final pp = profitPercent.toStringAsFixed(3);
    final z = "";

    return SurfaceCard(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TxIcon(isBuy: false),
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
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: cs.onSurface.withAlpha(130),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withAlpha(140),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .34,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      alignment: WrapAlignment.end,
                      children: [
                        const _TypeBadge(label: 'SELL', color: AppColors.loss),
                        if (state == PnlState.loss)
                          const _TypeBadge(
                            label: 'Loss',
                            color: AppColors.loss,
                          ),
                        if (state == PnlState.profit)
                          const _TypeBadge(
                            label: 'Profit',
                            color: AppColors.profit,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _TypeBadge(
                          label: '${profitPercent.toStringAsFixed(3)}%',
                          color: color,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$profit',
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: InfoTile(label: 'Units', value: '$kitta'),
              ),
              Expanded(
                child: InfoTile(label: 'Sell price', value: '$price'),
              ),
              Expanded(
                child: InfoTile(label: 'Total', value: '$total'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProfitLossIndicatorBar(
            state: state,
            strength: indicatorStrength(profitPercent.toString()),
          ),
        ],
      ),
    );
  }
}

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key, required this.message});
  final String message;

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
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: fade(AppColors.brandStart, .10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 34,
                color: AppColors.brandStart,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurface.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }
}
