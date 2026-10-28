import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

enum GraphRange {
  d1('1D', 24),
  w1('1W', 14),
  m1('1M', 30),
  m3('3M', 26),
  m6('6M', 30),
  y1('1Y', 36);

  const GraphRange(this.label, this.points);
  final String label;
  final int points;
}

/// Illustrative graph only. The data is dummy and is never used for, or
/// compared with, any real portfolio value.
class PortfolioGraph extends StatefulWidget {
  const PortfolioGraph({super.key});

  @override
  State<PortfolioGraph> createState() => _PortfolioGraphState();
}

class _PortfolioGraphState extends State<PortfolioGraph>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Map<GraphRange, List<double>> _data;
  GraphRange _range = GraphRange.m1;

  @override
  void initState() {
    super.initState();
    _data = {
      for (final r in GraphRange.values) r: _dummySeries(r.points, r.index + 7),
    };
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  static List<double> _dummySeries(int n, int seed) {
    final rnd = math.Random(seed);
    double v = 100;
    final out = <double>[];
    for (var i = 0; i < n; i++) {
      v += (rnd.nextDouble() - 0.42) * 4;
      out.add(v);
    }
    return out;
  }

  void _select(GraphRange r) {
    if (r == _range) return;
    setState(() => _range = r);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final data = _data[_range]!;
    final rising = data.last >= data.first;
    final lineColor = rising ? AppColors.profit : AppColors.loss;

    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      radius: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: SectionHeader(title: 'Performance')),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.onSurface.withAlpha(18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Demo data',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withAlpha(150),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              final height = (c.maxWidth * 0.42).clamp(130.0, 240.0);
              return SizedBox(
                height: height,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    painter: _LinePainter(
                      data: data,
                      progress: Curves.easeOutCubic.transform(
                        _controller.value,
                      ),
                      color: lineColor,
                      gridColor: cs.onSurface.withAlpha(22),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final r in GraphRange.values)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _select(r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: r == _range
                            ? fade(AppColors.brandStart, .14)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          r.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: r == _range
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: r == _range
                                ? AppColors.brandStart
                                : cs.onSurface.withAlpha(150),
                          ),
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
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.data,
    required this.progress,
    required this.color,
    required this.gridColor,
  });

  final List<double> data;
  final double progress;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2 || size.isEmpty) return;

    final minV = data.reduce(math.min);
    final maxV = data.reduce(math.max);
    final span = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    const padV = 12.0;

    Offset pt(int i) => Offset(
          i / (data.length - 1) * size.width,
          padV + (1 - (data[i] - minV) / span) * (size.height - 2 * padV),
        );

    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final line = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (var i = 1; i < data.length; i++) {
      final p = pt(i - 1);
      final q = pt(i);
      final cx = (p.dx + q.dx) / 2;
      line.cubicTo(cx, p.dy, cx, q.dy, q.dx, q.dy);
    }

    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withAlpha(90), color.withAlpha(0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.progress != progress ||
      old.data != data ||
      old.color != color ||
      old.gridColor != gridColor;
}
