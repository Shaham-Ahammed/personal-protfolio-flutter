import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/portfolio_data.dart';
import '../models/project_model.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: size.height,
      ),
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROJECTS',
            style: AppTextStyles.sectionTitle(context),
          ),
          const SizedBox(height: 16),
          Text(
            'My Recent Work',
            style: AppTextStyles.heading2(context),
          ),
          const SizedBox(height: 60),
          _buildProjectsList(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context, bool isMobile) {
    final projects = PortfolioData.projects
        .map((project) => Project.fromMap(project))
        .toList();

    if (isMobile) {
      return Column(
        children: projects
            .map((project) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _ProjectCard(project: project, isMobile: true),
                ))
            .toList(),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 32,
          mainAxisSpacing: 32,
          childAspectRatio: 1.1,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return _ProjectCard(project: projects[index], isMobile: false);
        },
      );
    }
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final bool isMobile;

  const _ProjectCard({
    required this.project,
    required this.isMobile,
  });

  Future<void> _launchUrl(String? url) async {
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: isMobile ? 180 : 200,
              width: double.infinity,
              color: AppColors.surfaceLight,
              child: Image.network(
                project.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surfaceLight,
                    child: const Icon(
                      Icons.image,
                      size: 60,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: AppTextStyles.heading4(context),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      project.description,
                      style: AppTextStyles.bodySmall(context),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies
                        .map((tech) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tech,
                                style: AppTextStyles.bodySmall(context).copyWith(
                                  fontSize: 12,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (project.githubUrl != null)
                        _ActionButton(
                          icon: Icons.code,
                          label: 'Code',
                          onTap: () => _launchUrl(project.githubUrl),
                        ),
                      if (project.githubUrl != null &&
                          project.liveUrl != null)
                        const SizedBox(width: 12),
                      if (project.liveUrl != null)
                        _ActionButton(
                          icon: Icons.open_in_new,
                          label: 'Live',
                          onTap: () => _launchUrl(project.liveUrl),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.primaryLight),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

