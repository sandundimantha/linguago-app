import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/home_data.dart';

/// Gamification encouragement banner featuring Lingo the Owl mascot.
class MascotCheerBanner extends StatelessWidget {
  final MascotCheer mascotCheer;

  const MascotCheerBanner({
    super.key,
    required this.mascotCheer,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(16.0),
      backgroundColor: colors.card,
      child: Row(
        children: [
          // Cheer & League Copy
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mascotCheer.title,
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3.0),
                Text(
                  mascotCheer.message,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.mutedText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          AppSpacing.hGapMd,

          // 3D Mascot Character Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: AppSpacing.brButton, // 16px
              color: colors.primaryTint,
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: AppSpacing.brButton,
              child: Image.network(
                mascotCheer.mascotImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colors.primaryTint,
                  alignment: Alignment.center,
                  child: const Text(
                    '🦉',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

