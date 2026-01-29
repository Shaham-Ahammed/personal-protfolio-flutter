import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/portfolio_data.dart';
import '../../../models/skill_model.dart';
import 'skill_card.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
            'SKILLS',
            style: AppTextStyles.sectionTitle(context),
          ),
          const SizedBox(height: 16),
          Text(
            'What I Can Do',
            style: AppTextStyles.heading2(context),
          ),
          const SizedBox(height: 60),
          _buildSkillsGrid(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildSkillsGrid(BuildContext context, bool isMobile) {
    final skills = PortfolioData.skills
        .map((skill) => Skill.fromMap(skill))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.1,
      ),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        return SkillCard(skill: skills[index]);
      },
    );
  }
}
