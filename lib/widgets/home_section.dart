import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/portfolio_data.dart';
import 'particle_background.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: size.height,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: ParticleBackground(
        particleCount: isMobile ? 30 : 50,
        connectionDistance: isMobile ? 100 : 120,
        showCursorHalo: true,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 60,
              vertical: isMobile ? 40 : 80,
            ),
            child: isMobile
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello, I\'m',
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: AppColors.primaryLight,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                PortfolioData.name,
                style: AppTextStyles.heading1(context),
              ),
              const SizedBox(height: 16),
              Text(
                PortfolioData.title,
                style: AppTextStyles.heading3(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
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
                      child: Text(
                        PortfolioData.quote,
                        style: AppTextStyles.quote(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                    color: AppColors.primary.withOpacity(0.5),
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
                  child: Image.network(
                    PortfolioData.profileImageUrl,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
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
              child: Image.network(
                PortfolioData.profileImageUrl,
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
          style: AppTextStyles.bodyLarge(context).copyWith(
            color: AppColors.primaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          PortfolioData.name,
          style: AppTextStyles.heading1(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          PortfolioData.title,
          style: AppTextStyles.heading3(context).copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.format_quote,
                color: AppColors.primaryLight,
                size: 28,
              ),
              const SizedBox(height: 12),
              Text(
                PortfolioData.quote,
                style: AppTextStyles.quote(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

