import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/text_styles.dart';

class SkillBullet extends StatefulWidget {
  const SkillBullet({super.key, required this.name});

  final String name;

  @override
  State<SkillBullet> createState() => _SkillBulletState();
}

class _SkillBulletState extends State<SkillBullet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shake;
  final math.Random _rng = math.Random();

  double _restingAngle = 0;
  double _initialAngle = 0;
  double _direction = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shake = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerShake() {
    if (_controller.isAnimating) return;

    _direction = _rng.nextBool() ? 1 : -1;
    _initialAngle = _restingAngle;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _triggerShake,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _shake,
          builder: (context, child) {
            final double progress = _shake.value;
            final double decay = math.exp(-progress * 1.2);
            final double swing =
                _direction * math.sin(progress * 2.5 * math.pi) * decay;
            final double angle = _initialAngle + swing;
            if (!_controller.isAnimating) {
              _restingAngle = angle;
            }
            final double offsetX = angle * 12;
            final double rotationAngle = angle * 0.15;
            return Transform.translate(
              offset: Offset(offsetX, 0),
              child: Transform.rotate(angle: rotationAngle, child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.name,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
