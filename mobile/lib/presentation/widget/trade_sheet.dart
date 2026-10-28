import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

/// Presentation-only content for the buy / sell bottom sheets.
/// It owns no logic: controllers, date text and submit action all come
/// from the screen's existing code.
class TradeSheet extends StatelessWidget {
  const TradeSheet({
    super.key,
    required this.isBuy,
    required this.nameController,
    required this.quantityController,
    required this.priceController,
    required this.dateText,
    required this.onPickDate,
    required this.onSubmit,
  });

  final bool isBuy;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final String dateText;
  final VoidCallback onPickDate;
  final VoidCallback onSubmit;

  InputDecoration _decoration(BuildContext context, String label, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: cs.onSurface.withAlpha(12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isBuy ? AppColors.buy : AppColors.loss,
          width: 1.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = isBuy
        ? const [AppColors.buy, AppColors.buyLight]
        : const [AppColors.loss, AppColors.lossLight];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isBuy ? Icons.add_shopping_cart_rounded : Icons.sell_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBuy ? 'Buy Share' : 'Sell Share',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Enter the details below',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withAlpha(140),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: _decoration(context, 'Name', Icons.business_rounded),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration:
                      _decoration(context, 'Quantity', Icons.layers_rounded),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      _decoration(context, 'Price', Icons.payments_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: cs.onSurface.withAlpha(12),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onPickDate,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_rounded,
                        size: 20, color: cs.onSurface.withAlpha(170)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: cs.onSurface.withAlpha(120)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: fade(colors.first, .35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onSubmit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      isBuy ? 'BUY' : 'SELL',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        fontSize: 15,
                      ),
                    ),
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
