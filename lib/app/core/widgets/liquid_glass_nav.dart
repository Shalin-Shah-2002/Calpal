import 'dart:ui';
import 'package:flutter/material.dart';

/// Liquid Glass Navigation Bar with smooth morphing animations
class LiquidGlassNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavBarItem> items;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const LiquidGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _previousIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(LiquidGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Reduce item width to bring items closer together
    const itemWidth = 150.0; // Fixed width instead of screen-divided
    final totalWidth = itemWidth * widget.items.length;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? 16 : 24),
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (widget.selectedColor ?? Colors.green).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: (widget.backgroundColor ?? Colors.white).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Animated liquid indicator
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final begin = _previousIndex * itemWidth;
                    final end = widget.currentIndex * itemWidth;
                    final currentPosition =
                        begin + (end - begin) * _animation.value;
                    final horizontalOffset =
                        (screenWidth - 32 - totalWidth) / 2;

                    return Positioned(
                      left:
                          horizontalOffset + currentPosition + itemWidth * 0.15,
                      top: 10,
                      child: Container(
                        width: itemWidth * 0.7,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              (widget.selectedColor ?? Colors.green)
                                  .withOpacity(0.3),
                              (widget.selectedColor ?? Colors.green)
                                  .withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Navigation items - centered
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.items.length,
                      (index) => _buildNavItem(index, itemWidth),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, double itemWidth) {
    final isSelected = widget.currentIndex == index;
    final item = widget.items[index];

    return SizedBox(
      width: itemWidth,
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // Calculate animation progress for this specific item
            double scale = 1.0;
            double iconScale = 1.0;
            Color iconColor = widget.unselectedColor ?? Colors.grey.shade600;

            if (isSelected) {
              scale = 1.0 + (_animation.value * 0.1);
              iconScale = 1.0 + (_animation.value * 0.2);
              iconColor = widget.selectedColor ?? Colors.green.shade700;
            } else if (index == _previousIndex) {
              scale = 1.1 - (_animation.value * 0.1);
              iconScale = 1.2 - (_animation.value * 0.2);
              iconColor = Color.lerp(
                widget.selectedColor ?? Colors.green.shade700,
                widget.unselectedColor ?? Colors.grey.shade600,
                _animation.value,
              )!;
            }

            return Transform.scale(
              scale: scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: iconScale,
                    child: Icon(item.icon, color: iconColor, size: 26),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: isSelected ? 12 : 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: iconColor,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Navigation bar item model
class NavBarItem {
  final IconData icon;
  final String label;

  const NavBarItem({required this.icon, required this.label});
}
