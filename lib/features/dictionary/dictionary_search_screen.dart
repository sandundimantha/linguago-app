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

class DictionarySearchScreen extends ConsumerStatefulWidget {
  const DictionarySearchScreen({super.key});

  @override
  ConsumerState<DictionarySearchScreen> createState() =>
      _DictionarySearchScreenState();
}

class _DictionarySearchScreenState
    extends ConsumerState<DictionarySearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final vocabAsync = ref.watch(vocabListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        title: Text(
          'English Dictionary',
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
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: TextField(
                controller: _searchCtrl,
                autofocus: false,
                onChanged: (val) => setState(() => _query = val.trim()),
                decoration: InputDecoration(
                  hintText: 'Search words, definitions, idioms...',
                  prefixIcon:
                      Icon(Icons.search_rounded, color: colors.primary),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppSpacing.brCard,
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
              ),
            ),

            Expanded(
              child: vocabAsync.when(
                loading: () => ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenMargin,
                    vertical: 8,
                  ),
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, _) => const CardLoadingSkeleton(height: 80),
                ),
                error: (e, _) => AppErrorScreen(
                  message: 'Failed to load dictionary: $e',
                  onRetry: () => ref.refresh(vocabListProvider),
                ),
                data: (words) {
                  final results = words.where((w) {
                    if (_query.isEmpty) return true;
                    return w.word.toLowerCase().contains(_query.toLowerCase()) ||
                        w.definition
                            .toLowerCase()
                            .contains(_query.toLowerCase()) ||
                        w.synonyms.any((s) =>
                            s.toLowerCase().contains(_query.toLowerCase()));
                  }).toList();

                  if (results.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'No Words Found',
                      message:
                          'We could not find any definitions matching "$_query". Check the spelling or try searching another word.',
                      actionLabel: 'Clear Search',
                      onAction: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenMargin,
                      vertical: 4,
                    ),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = results[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: AppSpacing.brCard,
                          border: Border.all(color: colors.border),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Row(
                            children: [
                              Text(
                                item.word,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.text,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.phonetic,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.mutedText,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors.primaryTint,
                                  borderRadius: AppSpacing.brFull,
                                ),
                                child: Text(
                                  item.partOfSpeech,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              item.definition,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colors.mutedText,
                                height: 1.3,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.volume_up_rounded,
                                color: colors.primary),
                            onPressed: () => TtsService().speak(item.word),
                          ),
                          onTap: () =>
                              context.push('/dictionary/result/${item.id}'),
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

