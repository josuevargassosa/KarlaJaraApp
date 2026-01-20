import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final bool _isUserLoggedIn = true; // Cambiar manualmente a false
  final String _mockUserName = 'Josue';

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

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

    _controller.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
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
      body: Stack(
        children: [
          // Burbujas de fondo
          Positioned(
            top: -60,
            left: -40,
            child: _AnimatedBubble(
              animation: _scaleAnimation,
              size: 220,
              colors: const [
                Color(0xFF4F46E5),
                Color(0xFF7C3AED),
              ],
            ),
          ),
          Positioned(
            bottom: -80,
            right: -20,
            child: _AnimatedBubble(
              animation: _scaleAnimation,
              size: 260,
              colors: const [
                Color(0xFF3B82F6),
                Color(0xFF9333EA),
              ],
            ),
          ),
          Positioned(
            top: 140,
            right: -60,
            child: _AnimatedBubble(
              animation: _scaleAnimation,
              size: 180,
              colors: const [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
              ],
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
    );
  }
}

class _AnimatedBubble extends StatelessWidget {
  const _AnimatedBubble({
    required this.animation,
    required this.size,
    required this.colors,
  });

  final Animation<double> animation;
  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              colors[0].withOpacity(0.45),
              colors[1].withOpacity(0.05),
            ],
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
