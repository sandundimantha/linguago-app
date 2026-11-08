import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/choice_card.dart';
import '../../../data/models/lesson_models.dart';

class ListeningQuestionView extends StatefulWidget {
  final LessonQuestion question;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const ListeningQuestionView({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<ListeningQuestionView> createState() => _ListeningQuestionViewState();
}

class _ListeningQuestionViewState extends State<ListeningQuestionView> {
  bool _isPlaying = false;

  void _simulateAudioPlayback() {
    setState(() => _isPlaying = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.question.prompt,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 24),

        // Audio Player Box
        Center(
          child: GestureDetector(
            onTap: _simulateAudioPlayback,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _isPlaying ? colors.primaryDarker : colors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _isPlaying ? 'Playing audio...' : 'Tap to listen',
            style: textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Options
        Expanded(
          child: ListView.separated(
            itemCount: widget.question.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final isSelected = widget.selectedIndex == i;
              return ChoiceCard(
                text: widget.question.options[i],
                optionIndex: String.fromCharCode(65 + i),
                state: isSelected
                    ? ChoiceCardState.selected
                    : ChoiceCardState.normal,
                onTap: () => widget.onSelect(i),
              );
            },
          ),
        ),
      ],
    );
  }
}

