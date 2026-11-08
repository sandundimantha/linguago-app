import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/app_error_screen.dart';
import '../../app/providers.dart';

class WordListScreen extends ConsumerStatefulWidget {
  const WordListScreen({super.key});

  @override
  ConsumerState<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends ConsumerState<WordListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final vocabAsync = ref.watch(vocabListProvider);
    final srs = ref.watch(srsSchedulerProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Word Bank (20 Words)',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                16,
                AppSpacing.screenMargin,
                10,
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search word or definition...',
                  prefixIcon: Icon(Icons.search_rounded, color: colors.mutedText),
                  filled: true,
                  fillColor: colors.card,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: AppSpacing.brCard,
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppSpacing.brCard,
                    borderSide: BorderSide(color: colors.border),
                  ),
                ),
              ),
            ),

            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
                vertical: 6,
              ),
              child: Row(
                children: [
                  'All',
                  'Daily Life',
                  'Communication',
                  'Mindset',
                  'Business',
                  'Workplace',
                  'Academic'
                ].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: colors.primaryTint,
                      labelStyle: textTheme.labelSmall?.copyWith(
                        color: isSelected ? colors.primary : colors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Word List
            Expanded(
              child: vocabAsync.when(
                loading: () => ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenMargin,
                    vertical: 8,
                  ),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => const CardLoadingSkeleton(height: 74),
                ),
                error: (e, _) => AppErrorScreen(
                  message: 'Failed to load words: $e',
                  onRetry: () => ref.refresh(vocabListProvider),
                ),
                data: (words) {
                  final filtered = words.where((w) {
                    final matchesQuery = w.word
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        w.definition
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                    final matchesCat = _selectedCategory == 'All' ||
                        w.category == _selectedCategory;
                    return matchesQuery && matchesCat;
                  }).toList();

                  if (filtered.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.menu_book_rounded,
                      title: 'No Words Found',
                      message:
                          'No vocabulary entries match your current search or category filter.',
                      actionLabel: 'Reset Filters',
                      onAction: () {
                        setState(() {
                          _searchQuery = '';
                          _selectedCategory = 'All';
                        });
                      },
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenMargin,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      final box = srs.getBox(item.id);

                      return Container(
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: AppSpacing.brCard,
                          border: Border.all(color: colors.border),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: AppSpacing.brCard,
                            onTap: () =>
                                context.push('/vocab/word/${item.id}'),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item.word,
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: colors.text,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              item.phonetic,
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                color: colors.mutedText,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.definition,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colors.mutedText,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: colors.primaryTint,
                                                borderRadius:
                                                    AppSpacing.brFull,
                                              ),
                                              child: Text(
                                                'Box $box',
                                                style: textTheme.labelSmall
                                                    ?.copyWith(
                                                  color: colors.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              item.partOfSpeech,
                                              style: textTheme.labelSmall
                                                  ?.copyWith(
                                                color: colors.mutedText,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.volume_up_rounded,
                                      color: colors.primary,
                                    ),
                                    onPressed: () =>
                                        TtsService().speak(item.word),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

