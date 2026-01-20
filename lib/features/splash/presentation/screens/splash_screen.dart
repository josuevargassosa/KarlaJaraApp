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

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _driftAnimations = List.generate(8, (_) {
      final dx = (_random.nextDouble() * 2 - 1) * 10;
      final dy = (_random.nextDouble() * 2 - 1) * 10;
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
            Positioned(
              top: 20,
              left: 10,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[0],
                size: 180,
                label: 'Relaciones',
                color: const Color(0xFF073C71),
              ),
            ),
            Positioned(
              top: 240,
              left: 30,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[1],
                size: 130,
                label: 'Familia',
                color: const Color(0xFF073C71),
              ),
            ),
            Positioned(
              top: 60,
              right: 20,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[2],
                size: 150,
                label: 'Traumas',
                color: const Color(0xFF073C71),
              ),
            ),
            Positioned(
              top: 280,
              right: 40,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[3],
                size: 120,
                label: 'Ansiedad',
                color: const Color(0xFF073C71),
              ),
            ),
            Positioned(
              bottom: 220,
              left: 40,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[4],
                size: 160,
                label: 'Autoestima',
                color: const Color(0xFF073C71),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 30,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[5],
                size: 190,
                label: 'Estrés',
                color: const Color(0xFF073C71),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 200,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[6],
                size: 110,
                label: 'Mindfulness',
                color: const Color(0xFF073C71),
              ),
            ),
            Positioned(
              top: 140,
              left: 190,
              child: _AnimatedBubble(
                animation: _scaleAnimation,
                drift: _driftAnimations[7],
                size: 140,
                label: 'Crecimiento',
                color: const Color(0xFF073C71),
              ),
            ),

            // Contenido central
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isUserLoggedIn ? 'Hola, $_mockUserName' : 'Bienvenido',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
    final double fontSize = (size * 0.12).clamp(12, 20);

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
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    letterSpacing: 0.2,
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
        child: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
