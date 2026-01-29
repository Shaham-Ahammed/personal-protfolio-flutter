import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../constants/portfolio_data.dart';
import 'widgets/particle_background.dart';
import 'widgets/animated_name_text.dart';
import 'widgets/download_cv_button.dart';
import 'widgets/flutter_bird.dart';
import 'widgets/interactive_quote.dart';

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
              Positioned(
                left: isMobile ? null : 60,
                right: isMobile ? 20 : null,
                bottom: isMobile ? 20 : 40,
                child: DownloadCVButton(onTap: _downloadCV),
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
                  AnimatedNameText(
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
                      const SizedBox(width: 32),
                      AnimatedOpacity(
                        opacity: _isNameAnimationComplete ? 1 : 0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: FlutterBird(availableWidth: availableWidth),
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
                          child: InteractiveQuote(
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
            AnimatedNameText(
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
                  child: FlutterBird(
                    availableWidth: availableWidth,
                    scale: 3,
                  ),
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
                  Icon(
                    Icons.format_quote,
                    color: AppColors.primaryLight,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: InteractiveQuote(
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
