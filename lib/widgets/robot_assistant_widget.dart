import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../themes/catppuccin_theme.dart';

class RobotAssistantWidget extends StatefulWidget {
  final bool isListening;
  final bool isProcessing;
  final bool isOnline;
  final String status;

  const RobotAssistantWidget({
    super.key,
    this.isListening = false,
    this.isProcessing = false,
    this.isOnline = true,
    this.status = 'Ready to assist',
  });

  @override
  State<RobotAssistantWidget> createState() => _RobotAssistantWidgetState();
}

class _RobotAssistantWidgetState extends State<RobotAssistantWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _eyeBlinkController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  late Animation<double> _breathingAnimation;
  late Animation<double> _eyeBlinkAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    // Breathing animation - gentle scaling
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    // Eye blink animation
    _eyeBlinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _eyeBlinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _eyeBlinkController,
      curve: Curves.easeInOut,
    ));
    
    // Pulse animation for listening state
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Rotation animation for processing state
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);
    
    _startAnimations();
  }

  void _startAnimations() {
    // Start breathing animation
    _breathingController.repeat(reverse: true);
    
    // Start random eye blinking
    _scheduleNextBlink();
    
    // Control animations based on state
    _updateAnimationsForState();
  }

  void _scheduleNextBlink() {
    Future.delayed(Duration(seconds: 2 + math.Random().nextInt(3)), () {
      if (mounted) {
        _eyeBlinkController.forward().then((_) {
          _eyeBlinkController.reverse();
          _scheduleNextBlink();
        });
      }
    });
  }

  void _updateAnimationsForState() {
    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }
    
    if (widget.isProcessing) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }
  }

  @override
  void didUpdateWidget(RobotAssistantWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isListening != widget.isListening ||
        oldWidget.isProcessing != widget.isProcessing) {
      _updateAnimationsForState();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _eyeBlinkController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Robot Visual
        AnimatedBuilder(
          animation: Listenable.merge([
            _breathingAnimation,
            _pulseAnimation,
            _rotationAnimation,
          ]),
          builder: (context, child) {
            double scale = _breathingAnimation.value;
            if (widget.isListening) {
              scale *= _pulseAnimation.value;
            }
            
            return Transform.scale(
              scale: scale,
              child: Transform.rotate(
                angle: widget.isProcessing ? _rotationAnimation.value * 2 * math.pi : 0,
                child: Container(
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isOnline
                          ? [
                              CatppuccinColors.blue.withOpacity(0.1),
                              CatppuccinColors.mauve.withOpacity(0.05),
                            ]
                          : [
                              Colors.grey.withOpacity(0.1),
                              Colors.grey.withOpacity(0.05),
                            ],
                    ),
                    border: Border.all(
                      color: widget.isOnline 
                          ? CatppuccinColors.blue.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CustomPaint(
                    painter: RobotPainter(
                      eyeScale: _eyeBlinkAnimation.value,
                      isOnline: widget.isOnline,
                      isListening: widget.isListening,
                      isProcessing: widget.isProcessing,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        
        // Status Text
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isOnline 
                ? CatppuccinColors.blue.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isOnline 
                  ? CatppuccinColors.blue.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Text(
            widget.status,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.isOnline 
                  ? CatppuccinColors.blue
                  : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // State indicators
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStateIndicator(
              icon: Icons.power_settings_new,
              isActive: widget.isOnline,
              label: 'Online',
              color: CatppuccinColors.green,
            ),
            const SizedBox(width: 16),
            _buildStateIndicator(
              icon: Icons.mic,
              isActive: widget.isListening,
              label: 'Listening',
              color: CatppuccinColors.yellow,
            ),
            const SizedBox(width: 16),
            _buildStateIndicator(
              icon: Icons.psychology,
              isActive: widget.isProcessing,
              label: 'Processing',
              color: CatppuccinColors.mauve,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStateIndicator({
    required IconData icon,
    required bool isActive,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? color : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? color : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isActive ? color : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class RobotPainter extends CustomPainter {
  final double eyeScale;
  final bool isOnline;
  final bool isListening;
  final bool isProcessing;

  RobotPainter({
    required this.eyeScale,
    required this.isOnline,
    required this.isListening,
    required this.isProcessing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Robot body colors
    final primaryColor = isOnline ? CatppuccinColors.blue : Colors.grey;
    final accentColor = isOnline ? CatppuccinColors.mauve : Colors.grey.shade600;
    final eyeColor = isListening 
        ? CatppuccinColors.yellow 
        : (isProcessing ? CatppuccinColors.mauve : primaryColor);

    // Head (circle)
    paint.color = primaryColor;
    canvas.drawCircle(
      Offset(centerX, size.height * 0.25),
      size.width * 0.25,
      paint,
    );

    // Eyes
    final leftEye = Offset(centerX - 20, size.height * 0.22);
    final rightEye = Offset(centerX + 20, size.height * 0.22);
    
    fillPaint.color = eyeColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: leftEye,
        width: 12,
        height: 12 * eyeScale,
      ),
      fillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: rightEye,
        width: 12,
        height: 12 * eyeScale,
      ),
      fillPaint,
    );

    // Mouth/Speaker grille
    paint.color = accentColor;
    final mouthRect = Rect.fromCenter(
      center: Offset(centerX, size.height * 0.28),
      width: 30,
      height: 8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(mouthRect, const Radius.circular(4)),
      paint,
    );

    // Draw grille lines
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(mouthRect.left + 6 + i * 4.5, mouthRect.top + 2),
        Offset(mouthRect.left + 6 + i * 4.5, mouthRect.bottom - 2),
        paint,
      );
    }

    // Neck
    canvas.drawLine(
      Offset(centerX, size.height * 0.38),
      Offset(centerX, size.height * 0.45),
      paint,
    );

    // Body (rounded rectangle)
    final bodyRect = Rect.fromCenter(
      center: Offset(centerX, size.height * 0.65),
      width: size.width * 0.6,
      height: size.height * 0.35,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(20)),
      paint,
    );

    // Chest panel
    final panelRect = Rect.fromCenter(
      center: Offset(centerX, size.height * 0.6),
      width: size.width * 0.4,
      height: size.height * 0.2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect, const Radius.circular(10)),
      paint,
    );

    // Chest lights/buttons
    fillPaint.color = isOnline ? CatppuccinColors.green : Colors.grey;
    canvas.drawCircle(
      Offset(centerX - 15, size.height * 0.58),
      4,
      fillPaint,
    );
    fillPaint.color = isListening ? CatppuccinColors.yellow : Colors.grey;
    canvas.drawCircle(
      Offset(centerX, size.height * 0.58),
      4,
      fillPaint,
    );
    fillPaint.color = isProcessing ? CatppuccinColors.mauve : Colors.grey;
    canvas.drawCircle(
      Offset(centerX + 15, size.height * 0.58),
      4,
      fillPaint,
    );

    // Arms
    paint.color = primaryColor;
    // Left arm
    canvas.drawLine(
      Offset(bodyRect.left + 10, size.height * 0.55),
      Offset(size.width * 0.15, size.height * 0.7),
      paint,
    );
    // Right arm
    canvas.drawLine(
      Offset(bodyRect.right - 10, size.height * 0.55),
      Offset(size.width * 0.85, size.height * 0.7),
      paint,
    );

    // Hands (circles)
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.7), 8, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.7), 8, paint);

    // Legs
    // Left leg
    canvas.drawLine(
      Offset(centerX - 15, bodyRect.bottom),
      Offset(centerX - 15, size.height * 0.9),
      paint,
    );
    // Right leg
    canvas.drawLine(
      Offset(centerX + 15, bodyRect.bottom),
      Offset(centerX + 15, size.height * 0.9),
      paint,
    );

    // Feet
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 15, size.height * 0.93),
        width: 20,
        height: 8,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 15, size.height * 0.93),
        width: 20,
        height: 8,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(RobotPainter oldDelegate) {
    return oldDelegate.eyeScale != eyeScale ||
        oldDelegate.isOnline != isOnline ||
        oldDelegate.isListening != isListening ||
        oldDelegate.isProcessing != isProcessing;
  }
}
