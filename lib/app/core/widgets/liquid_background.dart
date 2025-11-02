import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated liquid glass background with floating orbs
class LiquidGlassBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final int orbCount;
  final double blur;

  const LiquidGlassBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF114B5F),
      Color(0xFF1A936F),
      Color(0xFF88D498),
      Color(0xFFC6DABF),
    ],
    this.orbCount = 5,
    this.blur = 120.0,
  });

  @override
  State<LiquidGlassBackground> createState() => _LiquidGlassBackgroundState();
}

class _LiquidGlassBackgroundState extends State<LiquidGlassBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<LiquidOrb> _orbs;

  @override
  void initState() {
    super.initState();
    _initializeOrbs();
  }

  void _initializeOrbs() {
    final random = Random();
    _controllers = [];
    _animations = [];
    _orbs = [];

    for (int i = 0; i < widget.orbCount; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 3000 + random.nextInt(4000)),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

      _controllers.add(controller);
      _animations.add(animation);

      _orbs.add(
        LiquidOrb(
          startX: random.nextDouble(),
          startY: random.nextDouble(),
          endX: random.nextDouble(),
          endY: random.nextDouble(),
          size: 100.0 + random.nextDouble() * 200.0,
          color: widget.colors[random.nextInt(widget.colors.length)],
        ),
      );

      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.parchment,
                AppColors.teaGreen.withOpacity(0.3),
                AppColors.glassMint.withOpacity(0.2),
                AppColors.parchment,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),
        // Animated liquid orbs
        ...List.generate(
          widget.orbCount,
          (index) => AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return CustomPaint(
                painter: LiquidOrbPainter(
                  orb: _orbs[index],
                  progress: _animations[index].value,
                  blur: widget.blur,
                ),
                child: Container(),
              );
            },
          ),
        ),
        // Content on top
        widget.child,
      ],
    );
  }
}

/// Liquid orb data model
class LiquidOrb {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double size;
  final Color color;

  LiquidOrb({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.size,
    required this.color,
  });
}

/// Painter for liquid orbs with blur
class LiquidOrbPainter extends CustomPainter {
  final LiquidOrb orb;
  final double progress;
  final double blur;

  LiquidOrbPainter({
    required this.orb,
    required this.progress,
    required this.blur,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final x = lerpDouble(orb.startX, orb.endX, progress)! * size.width;
    final y = lerpDouble(orb.startY, orb.endY, progress)! * size.height;

    // Create gradient radial brush
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          orb.color.withOpacity(0.4),
          orb.color.withOpacity(0.2),
          orb.color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: orb.size))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    canvas.drawCircle(Offset(x, y), orb.size, paint);
  }

  @override
  bool shouldRepaint(LiquidOrbPainter oldDelegate) => true;
}

/// Enhanced glass card with morphing animation
class MorphingGlassCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const MorphingGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 32,
    this.padding,
    this.margin,
  });

  @override
  State<MorphingGlassCard> createState() => _MorphingGlassCardState();
}

class _MorphingGlassCardState extends State<MorphingGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _morphAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _morphAnimation,
      builder: (context, child) {
        return Container(
          margin: widget.margin,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              widget.borderRadius + (sin(_morphAnimation.value * pi * 2) * 4),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 16.0 + (sin(_morphAnimation.value * pi) * 4),
                sigmaY: 16.0 + (sin(_morphAnimation.value * pi) * 4),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(
                        0.25 + (_morphAnimation.value * 0.05),
                      ),
                      Colors.white.withOpacity(
                        0.10 + (_morphAnimation.value * 0.05),
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius +
                        (sin(_morphAnimation.value * pi * 2) * 4),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(
                      0.3 + (_morphAnimation.value * 0.2),
                    ),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.midnightGreen.withOpacity(0.1),
                      blurRadius: 24 + (_morphAnimation.value * 8),
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: widget.padding ?? const EdgeInsets.all(24),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Ripple effect overlay for interactive feedback
class RippleOverlay extends StatefulWidget {
  final Widget child;

  const RippleOverlay({super.key, required this.child});

  @override
  State<RippleOverlay> createState() => _RippleOverlayState();
}

class _RippleOverlayState extends State<RippleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _tapPosition;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
          _tapPosition = null;
        });
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
      _isAnimating = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        children: [
          widget.child,
          if (_isAnimating && _tapPosition != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(
                    position: _tapPosition!,
                    progress: _animation.value,
                  ),
                  child: Container(),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Painter for ripple effect
class RipplePainter extends CustomPainter {
  final Offset position;
  final double progress;

  RipplePainter({required this.position, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = sqrt(size.width * size.width + size.height * size.height);
    final radius = maxRadius * progress;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.seaGreen.withOpacity(0.3 * (1 - progress)),
          AppColors.celadon.withOpacity(0.2 * (1 - progress)),
          AppColors.celadon.withOpacity(0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: position, radius: radius));

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => true;
}

/// Floating particles effect
class FloatingParticles extends StatefulWidget {
  final int particleCount;

  const FloatingParticles({super.key, this.particleCount = 20});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    final random = Random();
    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2.0 + random.nextDouble() * 4.0,
        speed: 0.1 + random.nextDouble() * 0.3,
        opacity: 0.1 + random.nextDouble() * 0.3,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

/// Particle data model
class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

/// Painter for floating particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final x = particle.x * size.width;
      final y =
          ((particle.y + (progress * particle.speed)) % 1.0) * size.height;

      final paint = Paint()
        ..color = AppColors.glassWhite.withOpacity(particle.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
