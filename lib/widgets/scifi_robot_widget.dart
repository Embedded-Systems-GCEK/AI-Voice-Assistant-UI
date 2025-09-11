import 'package:flutter/material.dart';
import 'dart:math' as math;

enum RobotState {
  idle,
  listening,
  thinking,
  speaking,
  processing,
}

class SciFiRobotWidget extends StatefulWidget {
  final RobotState state;
  final double size;
  final VoidCallback? onTap;

  const SciFiRobotWidget({
    super.key,
    this.state = RobotState.idle,
    this.size = 200,
    this.onTap,
  });

  @override
  State<SciFiRobotWidget> createState() => _SciFiRobotWidgetState();
}

class _SciFiRobotWidgetState extends State<SciFiRobotWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _scanController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _scanAnimation;

  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _particleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _startAnimations();
    _initializeParticles();
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _glowController.repeat(reverse: true);
    _particleController.repeat();

    if (widget.state == RobotState.listening || widget.state == RobotState.processing) {
      _scanController.repeat(reverse: true);
    }
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(Particle(
        position: Offset(
          random.nextDouble() * widget.size,
          random.nextDouble() * widget.size,
        ),
        velocity: Offset(
          (random.nextDouble() - 0.5) * 2,
          (random.nextDouble() - 0.5) * 2,
        ),
        life: random.nextDouble(),
        maxLife: 1.0 + random.nextDouble() * 2,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  Color _getStateColor() {
    switch (widget.state) {
      case RobotState.idle:
        return const Color(0xFF00BFFF); // Deep Sky Blue
      case RobotState.listening:
        return const Color(0xFF00FF41); // Bright Green
      case RobotState.thinking:
        return const Color(0xFFFFD700); // Gold
      case RobotState.speaking:
        return const Color(0xFF9370DB); // Medium Purple
      case RobotState.processing:
        return const Color(0xFFFF4500); // Orange Red
    }
  }

  String _getStateText() {
    switch (widget.state) {
      case RobotState.idle:
        return 'STANDBY';
      case RobotState.listening:
        return 'LISTENING...';
      case RobotState.thinking:
        return 'ANALYZING...';
      case RobotState.speaking:
        return 'RESPONDING...';
      case RobotState.processing:
        return 'PROCESSING...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              _getStateColor().withOpacity(0.1),
              _getStateColor().withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(widget.size / 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background glow effect
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: widget.size * 0.9,
                  height: widget.size * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getStateColor().withOpacity(_glowAnimation.value * 0.5),
                        blurRadius: 30 * _glowAnimation.value,
                        spreadRadius: 5 * _glowAnimation.value,
                      ),
                    ],
                  ),
                );
              },
            ),
            
            // Particle system
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: ParticlePainter(
                    particles: _particles,
                    color: _getStateColor(),
                    animation: _particleAnimation.value,
                  ),
                );
              },
            ),

            // Main robot structure
            AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 0.1, // Slow rotation
                    child: CustomPaint(
                      size: Size(widget.size * 0.8, widget.size * 0.8),
                      painter: SciFiRobotPainter(
                        state: widget.state,
                        color: _getStateColor(),
                        glowIntensity: _glowAnimation.value,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Scanning beam effect
            if (widget.state == RobotState.listening || widget.state == RobotState.processing)
              AnimatedBuilder(
                animation: _scanAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: ScanBeamPainter(
                      color: _getStateColor(),
                      progress: _scanAnimation.value,
                    ),
                  );
                },
              ),

            // Central core
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 20 * _pulseAnimation.value,
                  height: 20 * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStateColor(),
                    boxShadow: [
                      BoxShadow(
                        color: _getStateColor(),
                        blurRadius: 10 * _pulseAnimation.value,
                        spreadRadius: 2 * _pulseAnimation.value,
                      ),
                    ],
                  ),
                );
              },
            ),

            // Status text
            Positioned(
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStateColor().withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStateText(),
                  style: TextStyle(
                    color: _getStateColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  double life;
  double maxLife;

  Particle({
    required this.position,
    required this.velocity,
    required this.life,
    required this.maxLife,
  });

  void update() {
    position += velocity;
    life += 0.01;
    if (life > maxLife) {
      life = 0;
      final random = math.Random();
      position = Offset(
        random.nextDouble() * 200,
        random.nextDouble() * 200,
      );
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double animation;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      particle.update();
      final alpha = (1 - (particle.life / particle.maxLife)).clamp(0.0, 1.0);
      paint.color = color.withOpacity(alpha * 0.8);
      canvas.drawCircle(particle.position, 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SciFiRobotPainter extends CustomPainter {
  final RobotState state;
  final Color color;
  final double glowIntensity;

  SciFiRobotPainter({
    required this.state,
    required this.color,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Main body - hexagonal
    final bodyPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final glowPaint = Paint()
      ..color = color.withOpacity(glowIntensity * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

    // Draw hexagonal body
    final hexPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        hexPath.moveTo(point.dx, point.dy);
      } else {
        hexPath.lineTo(point.dx, point.dy);
      }
    }
    hexPath.close();

    canvas.drawPath(hexPath, glowPaint);
    canvas.drawPath(hexPath, bodyPaint);

    // Inner circles
    for (int i = 0; i < 3; i++) {
      final innerRadius = radius * (0.7 - i * 0.15);
      canvas.drawCircle(
        center,
        innerRadius,
        Paint()
          ..color = color.withOpacity(0.4 - i * 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Connection nodes
    final nodes = [
      Offset(center.dx, center.dy - radius * 0.6),
      Offset(center.dx + radius * 0.5, center.dy + radius * 0.3),
      Offset(center.dx - radius * 0.5, center.dy + radius * 0.3),
    ];

    for (final node in nodes) {
      canvas.drawCircle(
        node,
        3,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
      
      // Draw connections to center
      canvas.drawLine(
        center,
        node,
        Paint()
          ..color = color.withOpacity(0.5)
          ..strokeWidth = 1,
      );
    }

    // Energy rings
    for (int i = 0; i < 2; i++) {
      final ringRadius = radius * (1.2 + i * 0.3);
      final ringPaint = Paint()
        ..color = color.withOpacity((0.3 - i * 0.1) * glowIntensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, ringRadius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ScanBeamPainter extends CustomPainter {
  final Color color;
  final double progress;

  ScanBeamPainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Scanning beam
    final angle = progress * 2 * math.pi;
    final beamEnd = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawLine(center, beamEnd, paint);

    // Beam glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawLine(center, beamEnd, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
