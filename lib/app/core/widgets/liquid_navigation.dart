import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Gooey liquid navigation bar with morphing animations
class LiquidGooeyNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<LiquidNavItem> items;

  const LiquidGooeyNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<LiquidGooeyNavBar> createState() => _LiquidGooeyNavBarState();
}

class _LiquidGooeyNavBarState extends State<LiquidGooeyNavBar>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _glowController;
  late Animation<double> _morphAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _morphController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _morphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _morphController, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(LiquidGooeyNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _morphController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 85,
      child: Stack(
        children: [
          // Glow effect layer
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.seaGreen.withOpacity(
                        0.3 * _glowAnimation.value,
                      ),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: AppColors.celadon.withOpacity(
                        0.2 * _glowAnimation.value,
                      ),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),
          // Main glass container
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Liquid indicator
                    AnimatedBuilder(
                      animation: _morphAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: LiquidIndicatorPainter(
                            currentIndex: widget.currentIndex,
                            itemCount: widget.items.length,
                            progress: _morphAnimation.value,
                          ),
                          child: Container(),
                        );
                      },
                    ),
                    // Navigation items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        widget.items.length,
                        (index) => _buildNavItem(widget.items[index], index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(LiquidNavItem item, int index) {
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onTap(index);
          _morphController.forward(from: 0.0);
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + (value * 0.3),
                    child: Transform.translate(
                      offset: Offset(0, -value * 8),
                      child: Container(
                        padding: EdgeInsets.all(12 + (value * 4)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isSelected
                              ? RadialGradient(
                                  colors: [
                                    AppColors.seaGreen.withOpacity(
                                      0.6 + (value * 0.2),
                                    ),
                                    AppColors.seaGreen.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.seaGreen.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: value * 5,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          item.icon,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary.withOpacity(0.6),
                          size: 24 + (value * 4),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: isSelected ? 12 : 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary.withOpacity(0.6),
                  shadows: isSelected
                      ? [
                          Shadow(
                            color: AppColors.seaGreen.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation item model
class LiquidNavItem {
  final IconData icon;
  final String label;

  const LiquidNavItem({required this.icon, required this.label});
}

/// Painter for liquid morphing indicator
class LiquidIndicatorPainter extends CustomPainter {
  final int currentIndex;
  final int itemCount;
  final double progress;

  LiquidIndicatorPainter({
    required this.currentIndex,
    required this.itemCount,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final itemWidth = size.width / itemCount;
    final centerX = (currentIndex + 0.5) * itemWidth;

    // Animated blob parameters
    final blobWidth = itemWidth * 0.8;
    final blobHeight = 50.0 + (sin(progress * pi) * 10);
    final morphFactor = sin(progress * pi * 2) * 5;

    final paint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.seaGreen.withOpacity(0.5),
              AppColors.celadon.withOpacity(0.3),
            ],
          ).createShader(
            Rect.fromCenter(
              center: Offset(centerX, size.height * 0.5),
              width: blobWidth,
              height: blobHeight,
            ),
          )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // Draw liquid blob with morphing effect
    final path = Path();
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.5),
        width: blobWidth + morphFactor,
        height: blobHeight - morphFactor,
      ),
      Radius.circular(blobHeight / 2),
    );

    path.addRRect(rect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LiquidIndicatorPainter oldDelegate) => true;
}

/// Advanced glass card with liquid edges
class LiquidEdgeGlassCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool enableLiquidEdge;

  const LiquidEdgeGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 32,
    this.padding,
    this.margin,
    this.enableLiquidEdge = true,
  });

  @override
  State<LiquidEdgeGlassCard> createState() => _LiquidEdgeGlassCardState();
}

class _LiquidEdgeGlassCardState extends State<LiquidEdgeGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.enableLiquidEdge) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: widget.margin,
          child: CustomPaint(
            painter: LiquidEdgePainter(
              progress: _animation.value,
              borderRadius: widget.borderRadius,
              enableLiquidEdge: widget.enableLiquidEdge,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  padding: widget.padding ?? const EdgeInsets.all(24),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Painter for liquid edge effect
class LiquidEdgePainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final bool enableLiquidEdge;

  LiquidEdgePainter({
    required this.progress,
    required this.borderRadius,
    required this.enableLiquidEdge,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!enableLiquidEdge) return;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.seaGreen.withOpacity(0.3),
          AppColors.celadon.withOpacity(0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    final path = Path();

    // Create wavy liquid edge
    for (double i = 0; i < size.width; i += 2) {
      final wave = sin((i / size.width + progress) * pi * 4) * 3;
      if (i == 0) {
        path.moveTo(i, wave);
      } else {
        path.lineTo(i, wave);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LiquidEdgePainter oldDelegate) => true;
}
