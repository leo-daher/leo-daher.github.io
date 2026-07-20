import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../world_experience_map.dart';
import '../shared/portfolio_section_heading.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PortfolioSectionHeading(
                eyebrow: context.l10n.globalExperience,
                title: context.l10n.experienceTitle,
                copy: context.l10n.experienceCopy,
              ),
            ),
          ),
        ),
        const SizedBox(height: 34),
        const WorldExperienceMap(),
      ],
    );
  }
}
