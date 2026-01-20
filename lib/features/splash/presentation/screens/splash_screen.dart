import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final bool _isUserLoggedIn = true; // Cambiar manualmente a false
  final String _mockUserName = 'Josue';
  final Random _random = Random(42);
  final List<_BubbleSpec> _bubbles = const [
    _BubbleSpec(
      label: 'Relaciones',
      size: 160,
      color: Color(0xFF073C71),
      position: Offset(0.08, 0.08),
    ),
    _BubbleSpec(
      label: 'Traumas',
      size: 140,
      color: Color(0xFF073C71),
      position: Offset(0.62, 0.10),
    ),
    _BubbleSpec(
      label: 'Familia',
      size: 120,
      color: Color(0xFF073C71),
      position: Offset(0.15, 0.28),
    ),
    _BubbleSpec(
      label: 'Crecimiento',
      size: 110,
      color: Color(0xFF073C71),
      position: Offset(0.62, 0.30),
    ),
    _BubbleSpec(
      label: 'Ansiedad',
      size: 110,
      color: Color(0xFF073C71),
      position: Offset(0.62, 0.44),
    ),
    _BubbleSpec(
      label: 'Autoestima',
      size: 140,
      color: Color(0xFF073C71),
      position: Offset(0.15, 0.56),
    ),
    _BubbleSpec(
      label: 'Mindfulness',
      size: 110,
      color: Color(0xFF073C71),
      position: Offset(0.48, 0.75),
    ),
    _BubbleSpec(
      label: 'Estrés',
      size: 150,
      color: Color(0xFF073C71),
      position: Offset(0.62, 0.80),
    ),
  ];

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final List<Animation<Offset>> _driftAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _driftAnimations = List.generate(_bubbles.length, (index) {
      final driftFactor = _bubbles[index].size * 0.015;
      final dx = (_random.nextDouble() * 2 - 1) * driftFactor;
      final dy = (_random.nextDouble() * 2 - 1) * driftFactor;
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(dx, dy),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );
    });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: GestureDetector(
        onTap: () => context.go(RoutePaths.login),
        child: Stack(
          children: [
            // Burbujas de fondo
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;

                return Stack(
                  children: [
                    for (int index = 0; index < _bubbles.length; index++)
                      Positioned(
                        left: (width - _bubbles[index].size) *
                            _bubbles[index].position.dx,
                        top: (height - _bubbles[index].size) *
                            _bubbles[index].position.dy,
                        child: _AnimatedBubble(
                          animation: _scaleAnimation,
                          drift: _driftAnimations[index],
                          size: _bubbles[index].size,
                          label: _bubbles[index].label,
                          color: _bubbles[index].color,
                        ),
                      ),
                  ],
                );
              },
            ),

            // Contenido central
            LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: constraints.maxWidth * 0.7,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isUserLoggedIn
                                ? 'Hola, $_mockUserName'
                                : 'Bienvenido',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'The Bridge',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleSpec {
  const _BubbleSpec({
    required this.label,
    required this.size,
    required this.color,
    required this.position,
  });

  final String label;
  final double size;
  final Color color;
  final Offset position;
}

class _AnimatedBubble extends StatelessWidget {
  const _AnimatedBubble({
    required this.animation,
    required this.drift,
    required this.size,
    required this.label,
    required this.color,
  });

  final Animation<double> animation;
  final Animation<Offset> drift;
  final double size;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double fontSize = (size * 0.16).clamp(12, 26);

    return AnimatedBuilder(
      animation: drift,
      builder: (context, child) {
        return Transform.translate(
          offset: drift.value,
          child: child,
        );
      },
      child: ScaleTransition(
        scale: animation,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 0.2,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Text('Home', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
