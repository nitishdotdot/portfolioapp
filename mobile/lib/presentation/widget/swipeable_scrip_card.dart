import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

/// Wraps any card with swipe gestures.
///  - Swipe right  -> [onBuy]  (blue background, BUY)
///  - Swipe left   -> [onSell] (red background, SELL)
///
/// The card always springs back to its original position. The callbacks only
/// open your existing buy / sell flows; no order is placed by the swipe.
class SwipeableScripCard extends StatefulWidget {
  const SwipeableScripCard({
    super.key,
    required this.child,
    required this.onBuy,
    required this.onSell,
    this.onLongPress,
    this.borderRadius = 20,
  });

  final Widget child;
  final VoidCallback onBuy;
  final VoidCallback onSell;
  final VoidCallback? onLongPress;
  final double borderRadius;

  @override
  State<SwipeableScripCard> createState() => _SwipeableScripCardState();
}

class _SwipeableScripCardState extends State<SwipeableScripCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double>? _animation;

  double _dx = 0;
  double _width = 1;
  bool _armed = false;

  // Fraction of the card width that must be dragged to trigger an action.
  static const double _triggerFraction = 0.30;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(() {
        final v = _animation?.value;
        if (v != null) setState(() => _dx = v);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onUpdate(DragUpdateDetails d) {
    _controller.stop();
    final max = _width * 0.42;
    final next = (_dx + d.delta.dx).clamp(-max, max);
    final nowArmed = next.abs() >= _width * _triggerFraction;
    if (nowArmed && !_armed) HapticFeedback.selectionClick();
    _armed = nowArmed;
    setState(() => _dx = next);
  }

  void _onEnd(DragEndDetails d) {
    final threshold = _width * _triggerFraction;
    final fling = d.primaryVelocity ?? 0;
    final flingBuy = fling > 1200 && _dx > _width * 0.15;
    final flingSell = fling < -1200 && _dx < -_width * 0.15;

    final triggerBuy = _dx >= threshold || flingBuy;
    final triggerSell = _dx <= -threshold || flingSell;

    _springBack();
    if (triggerBuy) {
      widget.onBuy();
    } else if (triggerSell) {
      widget.onSell();
    }
  }

  void _springBack() {
    _armed = false;
    _animation = Tween<double>(begin: _dx, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        final progress =
            (_dx.abs() / (_width * _triggerFraction)).clamp(0.0, 1.0);
        final isBuy = _dx > 0;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: _onUpdate,
          onHorizontalDragEnd: _onEnd,
          onHorizontalDragCancel: _springBack,
          onLongPress: widget.onLongPress,
          child: Stack(
            children: [
              if (_dx != 0)
                Positioned.fill(
                  child: _SwipeBackground(
                    isBuy: isBuy,
                    progress: progress,
                    radius: widget.borderRadius,
                  ),
                ),
              Transform.translate(
                offset: Offset(_dx, 0),
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.isBuy,
    required this.progress,
    required this.radius,
  });

  final bool isBuy;
  final double progress;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = isBuy
        ? const [AppColors.buy, AppColors.buyLight]
        : const [AppColors.loss, AppColors.lossLight];

    return Opacity(
      opacity: (0.25 + progress * 0.75).clamp(0.0, 1.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: isBuy ? Alignment.centerLeft : Alignment.centerRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: isBuy ? Alignment.centerLeft : Alignment.centerRight,
            end: isBuy ? Alignment.centerRight : Alignment.centerLeft,
            colors: colors,
          ),
        ),
        child: Transform.scale(
          scale: 0.8 + progress * 0.2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBuy) ...[
                const Icon(Icons.add_shopping_cart_rounded,
                    color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                isBuy ? 'BUY' : 'SELL',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              if (!isBuy) ...[
                const SizedBox(width: 8),
                const Icon(Icons.sell_rounded, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
