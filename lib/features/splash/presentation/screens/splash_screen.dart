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
    ),
    _BubbleSpec(
      label: 'Traumas',
      size: 140,
      color: Color(0xFF073C71),
    ),
    _BubbleSpec(
      label: 'Familia',
      size: 120,
      color: Color(0xFF073C71),
    ),
    _BubbleSpec(
      label: 'Crecimiento',
      size: 110,
      color: Color(0xFF073C71),
    ),
    _BubbleSpec(
      label: 'Ansiedad',
      size: 110,
      color: Color(0xFF073C71),
    ),
    _BubbleSpec(
      label: 'Autoestima',
      size: 140,
      color: Color(0xFF073C71),
    ),
    _BubbleSpec(
      label: 'Mindfulness',
      size: 110,
      color: Color(0xFF073C71),
    ),
    _BubbleSpec(
      label: 'Estrés',
      size: 150,
      color: Color(0xFF073C71),
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
                final margin = _calculateBubbleMargin(width, height);
                final placements =
                    _calculateBubblePlacements(width, height, margin);

                return Stack(
                  children: [
                    for (int index = 0; index < _bubbles.length; index++)
                      Positioned(
                        left: placements[index].topLeft.dx,
                        top: placements[index].topLeft.dy,
                        child: _AnimatedBubble(
                          animation: _scaleAnimation,
                          drift: _driftAnimations[index],
                          size: _bubbles[index].size,
                          label: _bubbles[index].label,
                          color: _bubbles[index].color,
                          maxDrift: placements[index].maxDrift,
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

  double _calculateBubbleMargin(double width, double height) {
    final minDimension = min(width, height);
    return (minDimension * 0.03).clamp(8.0, 24.0);
  }

  List<_BubblePlacement> _calculateBubblePlacements(
    double width,
    double height,
    double margin,
  ) {
    final candidates = _buildCandidateCenters(width, height);
    final placements =
        List<_BubblePlacement?>.filled(_bubbles.length, null);
    final placedCenters = <int, Offset>{};

    final orderedIndexes = List<int>.generate(_bubbles.length, (index) => index)
      ..sort((a, b) => _bubbles[b].size.compareTo(_bubbles[a].size));

    final adjustments = <Offset>[
      Offset.zero,
      Offset(margin, 0),
      Offset(-margin, 0),
      Offset(0, margin),
      Offset(0, -margin),
      Offset(margin, margin),
      Offset(-margin, margin),
      Offset(margin, -margin),
      Offset(-margin, -margin),
      Offset(margin * 2, 0),
      Offset(-margin * 2, 0),
      Offset(0, margin * 2),
      Offset(0, -margin * 2),
    ];

    for (final index in orderedIndexes) {
      final radius = _bubbles[index].size / 2;
      Offset? selectedCenter;

      for (final candidate in candidates) {
        for (final adjustment in adjustments) {
          final adjustedCenter = Offset(
            (candidate.dx + adjustment.dx)
                .clamp(radius + margin, width - radius - margin),
            (candidate.dy + adjustment.dy)
                .clamp(radius + margin, height - radius - margin),
          );

          if (_isCenterAvailable(
            adjustedCenter,
            radius,
            margin,
            placedCenters,
          )) {
            selectedCenter = adjustedCenter;
            break;
          }
        }
        if (selectedCenter != null) {
          break;
        }
      }

      selectedCenter ??= Offset(
        width / 2,
        height / 2,
      );

      placements[index] = _BubblePlacement(
        topLeft: Offset(selectedCenter.dx - radius, selectedCenter.dy - radius),
        maxDrift: min(margin * 0.6, radius * 0.25),
      );
      placedCenters[index] = selectedCenter;
    }

    return placements
        .map(
          (placement) =>
              placement ??
              const _BubblePlacement(
                topLeft: Offset.zero,
                maxDrift: 0,
              ),
        )
        .toList();
  }

  bool _isCenterAvailable(
    Offset center,
    double radius,
    double margin,
    Map<int, Offset> placedCenters,
  ) {
    for (final entry in placedCenters.entries) {
      final otherCenter = entry.value;
      final otherRadius = _bubbles[entry.key].size / 2;
      final minDistance = radius + otherRadius + margin;
      final distanceSquared = (center.dx - otherCenter.dx) *
              (center.dx - otherCenter.dx) +
          (center.dy - otherCenter.dy) * (center.dy - otherCenter.dy);
      if (distanceSquared < minDistance * minDistance) {
        return false;
      }
    }
    return true;
  }

  List<Offset> _buildCandidateCenters(double width, double height) {
    const columns = 3;
    final rows = (_bubbles.length / columns).ceil().clamp(1, 4);
    final xStep = width / (columns + 1);
    final yStep = height / (rows + 1);
    final candidates = <Offset>[];

    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final baseX = xStep * (column + 1);
        final stagger = row.isOdd ? xStep * 0.25 : 0.0;
        candidates.add(
          Offset(
            (baseX + stagger).clamp(xStep * 0.5, width - xStep * 0.5),
            yStep * (row + 1),
          ),
        );
      }
    }

    if (candidates.length < _bubbles.length) {
      candidates.add(
        Offset(width * 0.5, height * 0.25),
      );
      candidates.add(
        Offset(width * 0.5, height * 0.75),
      );
    }

    return candidates;
  }
}

class _BubbleSpec {
  const _BubbleSpec({
    required this.label,
    required this.size,
    required this.color,
  });

  final String label;
  final double size;
  final Color color;
}

class _BubblePlacement {
  const _BubblePlacement({
    required this.topLeft,
    required this.maxDrift,
  });

  final Offset topLeft;
  final double maxDrift;
}

class _AnimatedBubble extends StatelessWidget {
  const _AnimatedBubble({
    required this.animation,
    required this.drift,
    required this.size,
    required this.label,
    required this.color,
    required this.maxDrift,
  });

  final Animation<double> animation;
  final Animation<Offset> drift;
  final double size;
  final String label;
  final Color color;
  final double maxDrift;

  @override
  Widget build(BuildContext context) {
    final double fontSize = (size * 0.16).clamp(12, 26);

    return AnimatedBuilder(
      animation: drift,
      builder: (context, child) {
        final driftOffset = Offset(
          drift.value.dx.clamp(-maxDrift, maxDrift),
          drift.value.dy.clamp(-maxDrift, maxDrift),
        );
        return Transform.translate(
          offset: driftOffset,
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
