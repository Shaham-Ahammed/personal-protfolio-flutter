import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/portfolio_data.dart';
import '../models/experience_model.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: size.height,
      ),
      color: AppColors.backgroundLight,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPERIENCE',
            style: AppTextStyles.sectionTitle(context),
          ),
          const SizedBox(height: 16),
          Text(
            'My Career Journey',
            style: AppTextStyles.heading2(context),
          ),
          const SizedBox(height: 60),
          _buildExperiencesList(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildExperiencesList(BuildContext context, bool isMobile) {
    final experiences = PortfolioData.experiences
        .map((exp) => Experience.fromMap(exp))
        .toList();

    return isMobile
        ? Column(
            children: experiences
                .asMap()
                .entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: _ExperienceCard(
                        experience: entry.value,
                        isLast: entry.key == experiences.length - 1,
                        isMobile: true,
                        index: entry.key,
                      ),
                    ))
                .toList(),
          )
        : Column(
            children: experiences
                .asMap()
                .entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: _ExperienceCard(
                        experience: entry.value,
                        isLast: entry.key == experiences.length - 1,
                        isMobile: false,
                        index: entry.key,
                      ),
                    ))
                .toList(),
          );
  }
}

class _ExperienceCard extends StatefulWidget {
  final Experience experience;
  final bool isLast;
  final bool isMobile;
  final int index;

  const _ExperienceCard({
    required this.experience,
    required this.isLast,
    required this.isMobile,
    required this.index,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  final GlobalKey _cardKey = GlobalKey();
  bool _cardAnimated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Slow animation
    );

    // Animation sequence: fall from 90° to 0°, then bounce
    _rotationAnimation = TweenSequence<double>([
      // Main fall: from 90° to 0° (80% of animation time)
      TweenSequenceItem(
        tween: Tween<double>(begin: 90.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 80.0,
      ),
      // Bounce up: slight overshoot to -8° (10% of animation time)
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -8.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 10.0,
      ),
      // Bounce back: settle to 0° (10% of animation time)
      TweenSequenceItem(
        tween: Tween<double>(begin: -8.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10.0,
      ),
    ]).animate(_animationController);

    // Always start with controller at 0 (rotated 90 degrees)
    _animationController.value = 0.0;

    // Start checking visibility after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkCardVisibility();
        _startPeriodicVisibilityCheck();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _checkCardVisibility();
    }
  }

  void _startPeriodicVisibilityCheck() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _checkCardVisibility();
        _startPeriodicVisibilityCheck();
      }
    });
  }

  void _checkCardVisibility() {
    if (!mounted) return;

    final context = _cardKey.currentContext;
    if (context == null || !context.mounted) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final widgetSize = renderBox.size;
      final screenSize = MediaQuery.of(context).size;
      final screenHeight = screenSize.height;

      final viewportTop = 0.0;
      final viewportBottom = screenHeight;

      final widgetTop = position.dy;
      final widgetBottom = widgetTop + widgetSize.height;

      final visibleTop = widgetTop.clamp(viewportTop, viewportBottom);
      final visibleBottom = widgetBottom.clamp(viewportTop, viewportBottom);
      final visibleHeight = (visibleBottom - visibleTop).clamp(0.0, widgetSize.height);

      if (widgetSize.height > 0) {
        final visibilityPercentage = visibleHeight / widgetSize.height;
        final isInViewport = widgetBottom > viewportTop && widgetTop < viewportBottom;
        final shouldBeAnimated = isInViewport && visibilityPercentage >= 0.70; // 70% threshold

        final isCompletelyOutOfView = widgetBottom <= viewportTop || widgetTop >= viewportBottom;

        if (shouldBeAnimated && !_cardAnimated && mounted) {
          setState(() {
            _cardAnimated = true;
          });
          // Start animation with staggered delay based on index
          Future.delayed(Duration(milliseconds: widget.index * 150), () {
            if (mounted) {
              _animationController.forward();
            }
          });
        } else if (isCompletelyOutOfView && _cardAnimated && mounted) {
          setState(() {
            _cardAnimated = false;
          });
          // Reset to initial state
          _animationController.reset();
        }
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification ||
            notification is ScrollStartNotification) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _checkCardVisibility();
            }
          });
        }
        return false;
      },
      child: Container(
        key: _cardKey,
        child: widget.isMobile
            ? _buildMobileCard(context)
            : _buildDesktopCard(context),
      ),
    );
  }

  Widget _buildDesktopCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.58;
    final isLeftAligned = widget.index % 2 == 0; // Even index = left, odd index = right
    
    // Bullet widget with horizontal line (hinge effect)
    // For left: bullet → line, For right: line → bullet
    final bulletWidget = AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        final rotationX = _rotationAnimation.value * (3.14159 / 180);
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateX(rotationX),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: isLeftAligned
                ? [
                    // Left aligned: bullet first, then line
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                          color: AppColors.backgroundLight,
                          width: 4,
                        ),
                      ),
                    ),
                    // Horizontal line connecting to card (hinge effect)
                    Container(
                      width: 24, // Distance to card
                      height: 2,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ]
                : [
                    // Right aligned: line first, then bullet
                    Container(
                      width: 24, // Distance to card
                      height: 2,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                          color: AppColors.backgroundLight,
                          width: 4,
                        ),
                      ),
                    ),
                  ],
          ),
        );
      },
    );
    
    final cardWidget = Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.experience.title,
                      style: AppTextStyles.heading4(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.experience.company,
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.experience.period,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                widget.experience.location,
                style: AppTextStyles.bodySmall(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.experience.description,
            style: AppTextStyles.bodyMedium(context),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.experience.technologies
                .map((tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tech,
                        style: AppTextStyles.bodySmall(context),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
    
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        // Convert degrees to radians for rotation
        final rotationX = _rotationAnimation.value * (3.14159 / 180);
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: isLeftAligned ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: isLeftAligned
              ? [
                  bulletWidget,
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateX(rotationX),
                    child: cardWidget,
                  ),
                  const Spacer(), // Push to left side
                ]
              : [
                  const Spacer(), // Push to right side
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateX(rotationX),
                    child: cardWidget,
                  ),
                  bulletWidget,
                ],
        );
      },
    );
  }

  Widget _buildMobileCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        // Convert degrees to radians for rotation
        final rotationX = _rotationAnimation.value * (3.14159 / 180);
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateX(rotationX),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.experience.title,
            style: AppTextStyles.heading4(context),
          ),
          const SizedBox(height: 4),
          Text(
            widget.experience.company,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.experience.location,
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.experience.period,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.experience.description,
            style: AppTextStyles.bodyMedium(context),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.experience.technologies
                .map((tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tech,
                        style: AppTextStyles.bodySmall(context).copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
            ),
          ),
        );
      },
    );
  }
}

