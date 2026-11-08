import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

class VocabHubScreen extends ConsumerWidget {
  const VocabHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final vocabAsync = ref.watch(vocabListProvider);
    final dueWordsAsync = ref.watch(dueWordsProvider);
    final srs = ref.watch(srsSchedulerProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        title: Text(
          'Vocabulary Hub',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vGapMd,

              // Spaced Repetition Due Banner
              dueWordsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (due) {
                  final dueCount = due.length;
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: AppSpacing.brCard,
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: AppSpacing.brFull,
                              ),
                              child: Text(
                                'SPACED REPETITION',
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB8),
                                borderRadius: AppSpacing.brFull,
                              ),
                              child: Text(
                                '$dueCount Due',
                                style: textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFF684000),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          dueCount > 0
                              ? 'Words Ready For Review'
                              : 'All Caught Up! 🎉',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dueCount > 0
                              ? 'Master vocabulary long-term with Leitner interval recall.'
                              : 'Great job maintaining your memory streak today.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 18),
                        PrimaryButton(
                          label: dueCount > 0
                              ? 'Start Review Session ($dueCount)'
                              : 'Practice Anyway',
                          backgroundColor: Colors.white,
                          bottomEdgeColor: const Color(0xFFE2E8F0),
                          textColor: colors.primary,
                          onPressed: () => context.push('/vocab/review'),
                        ),
                      ],
                    ),
                  );
                },
              ),

              AppSpacing.vGapLg,

              // Action Cards: Flashcards & Word Bank
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: '🗂️',
                      title: 'Flashcards',
                      subtitle: 'Flip & swipe review',
                      colors: colors,
                      textTheme: textTheme,
                      onTap: () => context.push('/vocab/flashcards'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      icon: '📖',
                      title: 'Word Bank',
                      subtitle: 'Browse 20 core words',
                      colors: colors,
                      textTheme: textTheme,
                      onTap: () => context.push('/vocab/list'),
                    ),
                  ),
                ],
              ),

              AppSpacing.vGapLg,

              // Leitner Interval Guide Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leitner Box Intervals',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Words advance through 4 memory boxes as you review accurately.',
                      style: textTheme.bodySmall?.copyWith(color: colors.mutedText),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _BoxStat(box: 'Box 1', interval: '1 Day', color: colors.danger),
                        _BoxStat(box: 'Box 2', interval: '3 Days', color: colors.accent),
                        _BoxStat(box: 'Box 3', interval: '7 Days', color: colors.primary),
                        _BoxStat(box: 'Box 4', interval: '14 Days', color: colors.success),
                      ],
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              // Recent Words Preview
              Text(
                'Recent Words',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                ),
              ),
              AppSpacing.vGapSm,

              vocabAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (words) {
                  final preview = words.take(4).toList();
                  return Column(
                    children: preview.map((w) {
                      final box = srs.getBox(w.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: AppCard(
                          child: InkWell(
                            onTap: () => context.push('/vocab/word/${w.id}'),
                            borderRadius: AppSpacing.brCard,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colors.primaryTint,
                                    borderRadius: AppSpacing.brFull,
                                  ),
                                  child: Text(
                                    'Box $box',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        w.word,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: colors.text,
                                        ),
                                      ),
                                      Text(
                                        w.definition,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colors.mutedText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded,
                                    color: colors.mutedText),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final AppCustomColors colors;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.brCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(color: colors.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoxStat extends StatelessWidget {
  final String box;
  final String interval;
  final Color color;

  const _BoxStat({
    required this.box,
    required this.interval,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 6),
        Text(
          box,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          interval,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

