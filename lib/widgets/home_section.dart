import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../constants/images.dart';
import '../constants/text_styles.dart';
import '../constants/portfolio_data.dart';
import 'particle_background.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with SingleTickerProviderStateMixin {
  bool _isNameAnimationComplete = false;
  late final AnimationController _titleController;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: Curves.elasticOut,
      ),
    );
    _titleOpacity = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _downloadCV() async {
    final Uri url = Uri.parse(PortfolioData.cvUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 910;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height),
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: ParticleBackground(
        particleCount: isMobile ? 30 : 50,
        connectionDistance: isMobile ? 100 : 120,
        showCursorHalo: true,
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 60,
                  vertical: isMobile ? 40 : 80,
                ),
                child: isMobile
                    ? Center(child: _buildMobileLayout(context))
                    : _buildDesktopLayout(context),
              ),
              // Download CV Button - bottom right on mobile, bottom left on desktop
              Positioned(
                left: isMobile ? null : 60,
                right: isMobile ? 20 : null,
                bottom: isMobile ? 20 : 40,
                child: _DownloadCVButton(onTap: _downloadCV),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate available width for the bird to drag
              // This is the width of the content area
              final availableWidth = constraints.maxWidth;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello, I\'m',
                    style: AppTextStyles.bodyLarge(
                      context,
                    ).copyWith(color: AppColors.primaryLight, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  _AnimatedNameText(
                    text: PortfolioData.name,
                    style: AppTextStyles.heading1(context),
                    onCompleted: () {
                      setState(() => _isNameAnimationComplete = true);
                      _titleController.forward();
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Text(
                            PortfolioData.title,
                            style: AppTextStyles.heading3(
                              context,
                            ).copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                       SizedBox(width: 32),
                      AnimatedOpacity(
                        opacity: _isNameAnimationComplete ? 1 : 0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: _FlutterBird(availableWidth: availableWidth),
                      ),
                    ],
                  ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: AppColors.primaryLight,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InteractiveQuote(
                        text: PortfolioData.quote,
                        style: AppTextStyles.quote(context),
                        hoverScale: 1.32,
                      ),
                    ),
                  ],
                ),
              ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
                child: ClipOval(
                  child: Image.asset(
                    PortfolioData.profileImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 150,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final screenWidth = MediaQuery.of(context).size.width;
        final imageSize = screenWidth < 440 ? 220.0 : 250.0;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
                child: ClipOval(
                  child: Image.asset(
                    PortfolioData.profileImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Hello, I\'m',
              style: AppTextStyles.bodyLarge(
                context,
              ).copyWith(color: AppColors.primaryLight),
            ),
            const SizedBox(height: 12),
            _AnimatedNameText(
              text: PortfolioData.name,
              style: AppTextStyles.heading1(context),
              textAlign: TextAlign.center,
              onCompleted: () {
                setState(() => _isNameAnimationComplete = true);
                _titleController.forward();
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _titleOpacity,
                  child: SlideTransition(
                    position: _titleSlide,
                    child: Text(
                      PortfolioData.title,
                      style: AppTextStyles.heading3(
                        context,
                      ).copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                AnimatedOpacity(
                  opacity: _isNameAnimationComplete ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: _FlutterBird(availableWidth: availableWidth, scale: 3),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.format_quote, color: AppColors.primaryLight, size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: _InteractiveQuote(
                      text: PortfolioData.quote,
                      style: AppTextStyles.quote(context),
                      hoverScale: 1.2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedNameText extends StatefulWidget {
  const _AnimatedNameText({
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.onCompleted,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final VoidCallback? onCompleted;

  @override
  State<_AnimatedNameText> createState() => _AnimatedNameTextState();
}

class _AnimatedNameTextState extends State<_AnimatedNameText> {
  late int _visibleChars;
  late bool _cursorOn;
  Timer? _charTimer;
  Timer? _cursorTimer;
  final _rand = Random();
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _visibleChars = 0;
    _cursorOn = true;
    _startAnimation();
  }

  void _startAnimation() {
    const startDelay = Duration(milliseconds: 300);
    Future.delayed(startDelay, () {
      if (!mounted) return;
      _startCursorBlink();
      _scheduleNextChar();
    });
  }

  void _startCursorBlink() {
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        _cursorOn = !_cursorOn;
      });
    });
  }

  void _scheduleNextChar() {
    if (_visibleChars >= widget.text.length) {
      _cursorTimer?.cancel();
      if (!_hasCompleted) {
        _hasCompleted = true;
        widget.onCompleted?.call();
      }
      return;
    }

    final minDelay = 130;
    final maxDelay = 280;
    final delayMs = minDelay + _rand.nextInt(maxDelay - minDelay + 1);

    _charTimer?.cancel();
    _charTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      setState(() {
        _visibleChars = (_visibleChars + 1)
            .clamp(0, widget.text.length)
            .toInt();
      });
      _scheduleNextChar();
    });
  }

  @override
  void dispose() {
    _charTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.substring(0, _visibleChars);
    final showCursor = _cursorOn && _visibleChars < widget.text.length;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: displayText),
          if (showCursor) const TextSpan(text: '_'),
        ],
      ),
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

class _FlutterBird extends StatefulWidget {
  final double? availableWidth;
  final double scale;
  
  const _FlutterBird({this.availableWidth, this.scale = 4});
  
  @override
  State<_FlutterBird> createState() => _FlutterBirdState();
}

class _InteractiveQuote extends StatefulWidget {
  const _InteractiveQuote({
    required this.text,
    required this.style,
    this.hoverScale = 1.2,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle style;
  final double hoverScale;
  final TextAlign textAlign;

  @override
  State<_InteractiveQuote> createState() => _InteractiveQuoteState();
}

class _InteractiveQuoteState extends State<_InteractiveQuote> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final characters = widget.text.characters.toList();
    final letterSpacing = widget.style.letterSpacing ?? 0;
    final spaceWidth = (widget.style.fontSize ?? 16) * 0.35 + letterSpacing;

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        children: [
          for (int i = 0; i < characters.length; i++)
            characters[i] == ' '
                ? WidgetSpan(
                    child: SizedBox(width: spaceWidth),
                  )
                : WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hoveredIndex = i),
                      onExit: (_) => setState(() => _hoveredIndex = null),
                      child: AnimatedScale(
                        scale: _hoveredIndex == i ? widget.hoverScale : 1.0,
                        duration: const Duration(milliseconds: 140),
                        curve: Curves.easeOut,
                        child: Text(
                          characters[i],
                          style: _hoveredIndex == i
                              ? widget.style.copyWith(
                                  color: AppColors.primaryLight,
                                )
                              : widget.style,
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}

class _FlutterBirdState extends State<_FlutterBird>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _spinController;
  Animation<double>? _returnDx;
  late final Animation<double> _rotation;
  double _dx = 0;

  double _maxDx = 400;
  VoidCallback? _controllerListener;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    final listener = _controllerListener;
    if (listener != null) {
      _controller.removeListener(listener);
    }
    _controller.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, _maxDx);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dx == 0) return;

    _returnDx = Tween<double>(begin: _dx, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    final prevListener = _controllerListener;
    if (prevListener != null) {
      _controller.removeListener(prevListener);
    }

    _controllerListener = () {
      final value = _returnDx?.value;
      if (!mounted || value == null) return;
      setState(() => _dx = value);
    };

    _controller
      ..reset()
      ..addListener(_controllerListener!)
      ..forward().whenComplete(() {
        if (!mounted) return;
        setState(() => _dx = 0);
      });
  }

  Future<void> _handleTap() async {
    if (_spinController.isAnimating) return;
    await _spinController.forward(from: 0);
    if (mounted) {
      await _spinController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate max drag distance based on screen width and available width
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (widget.availableWidth != null) {
      // Adjust percentage based on screen width breakpoints
      // Reduces as screen gets smaller to keep bird within content area
      double percentage;
      if (screenWidth > 1300) {
        percentage = 0.40; // 40% for large screens
      } else if (screenWidth > 1150) {
        percentage = 0.30; // 30% for screens around 1300px
      } else if (screenWidth >= 1020) {
        percentage = 0.20; // 20% for screens around 1150px
      } else if (screenWidth >= 910) {
        percentage = 0.0; // No dragging for screens 910-1020px (tablet)
      } else {
        percentage = 0.10; // 10% for mobile view (< 910px)
      }
      _maxDx = widget.availableWidth! * percentage;
    } else {
      // Fallback: use screen width percentage
      _maxDx = screenWidth * 0.25;
    }
    
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onTap: _handleTap,
      child: Transform.translate(
        offset: Offset(_dx, 0),
        child: AnimatedBuilder(
          animation: _rotation,
          builder: (context, child) {
            final angle = _rotation.value;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(angle);
            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: child,
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Transform.scale(
              scale: widget.scale,
              child: Image.asset(AppImages.flutterBird, width: 48, height: 48),
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadCVButton extends StatefulWidget {
  final VoidCallback onTap;

  const _DownloadCVButton({required this.onTap});

  @override
  State<_DownloadCVButton> createState() => _DownloadCVButtonState();
}

class _DownloadCVButtonState extends State<_DownloadCVButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _borderController,
          builder: (context, child) {
            return CustomPaint(
              painter: _CirclingBorderPainter(
                progress: _borderController.value,
                isHovered: _isHovered,
              ),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            decoration: BoxDecoration(
              color: _isHovered 
                  ? AppColors.primary.withValues(alpha: 0.15) 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download_rounded,
                  color: _isHovered 
                      ? Colors.white 
                      : AppColors.primaryLight,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Text(
                  'Download CV',
                  style: TextStyle(
                    color: _isHovered 
                        ? Colors.white 
                        : AppColors.primaryLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
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

class _CirclingBorderPainter extends CustomPainter {
  final double progress;
  final bool isHovered;

  _CirclingBorderPainter({
    required this.progress,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(35));
    
    // Draw base border (subtle)
    final basePaint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, basePaint);

    // Create path from rounded rect
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;

    // Calculate the segment to draw (rotating around)
    final segmentLength = totalLength * 0.35; // 35% of the border
    final startDistance = (progress * totalLength) % totalLength;
    
    // Create gradient for the circling effect
    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 3.5 : 2.5
      ..strokeCap = StrokeCap.round;

    // Draw the circling segment with gradient
    final extractedPath = _extractPathSegment(
      pathMetrics, 
      startDistance, 
      segmentLength, 
      totalLength,
    );
    
    // Apply sweep gradient for glow effect
    final sweepGradient = SweepGradient(
      startAngle: 0,
      endAngle: pi * 2,
      colors: [
        Colors.transparent,
        AppColors.primaryLight.withValues(alpha: 0.3),
        isHovered ? AppColors.primary : AppColors.primaryLight,
        isHovered ? AppColors.primary : AppColors.primaryLight,
        AppColors.primaryLight.withValues(alpha: 0.3),
        Colors.transparent,
      ],
      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      transform: GradientRotation(progress * pi * 2),
    );
    
    gradientPaint.shader = sweepGradient.createShader(rect);
    canvas.drawPath(extractedPath, gradientPaint);

    // Add glow effect when hovered
    if (isHovered) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..color = AppColors.primary.withValues(alpha: 0.4);
      canvas.drawPath(extractedPath, glowPaint);
    }
  }

  Path _extractPathSegment(
    ui.PathMetric metric, 
    double start, 
    double length, 
    double total,
  ) {
    final path = Path();
    final end = start + length;
    
    if (end <= total) {
      // Simple case: segment doesn't wrap around
      final extracted = metric.extractPath(start, end);
      path.addPath(extracted, Offset.zero);
    } else {
      // Segment wraps around: draw two parts
      final firstPart = metric.extractPath(start, total);
      final secondPart = metric.extractPath(0, end - total);
      path.addPath(firstPart, Offset.zero);
      path.addPath(secondPart, Offset.zero);
    }
    
    return path;
  }

  @override
  bool shouldRepaint(_CirclingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isHovered != isHovered;
  }
}
