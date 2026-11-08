import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/lesson_models.dart';

class MatchPairsView extends StatefulWidget {
  final LessonQuestion question;
  final Map<String, String> userMatches; // left -> right
  final ValueChanged<Map<String, String>> onChanged;

  const MatchPairsView({
    super.key,
    required this.question,
    required this.userMatches,
    required this.onChanged,
  });

  @override
  State<MatchPairsView> createState() => _MatchPairsViewState();
}

class _MatchPairsViewState extends State<MatchPairsView> {
  String? _selectedLeft;
  String? _selectedRight;
  late List<String> _shuffledRights;

  @override
  void initState() {
    super.initState();
    _shuffledRights = widget.question.pairs.map((p) => p.right).toList()
      ..shuffle();
  }

  void _onLeftTap(String left) {
    if (widget.userMatches.containsKey(left)) {
      // remove match
      final updated = Map<String, String>.from(widget.userMatches)..remove(left);
      widget.onChanged(updated);
      setState(() {
        _selectedLeft = null;
      });
      return;
    }

    setState(() {
      _selectedLeft = left;
    });
    _checkPairFormed();
  }

  void _onRightTap(String right) {
    // if already matched to a left, unmatch
    if (widget.userMatches.containsValue(right)) {
      final key = widget.userMatches.entries
          .firstWhere((e) => e.value == right)
          .key;
      final updated = Map<String, String>.from(widget.userMatches)..remove(key);
      widget.onChanged(updated);
      setState(() {
        _selectedRight = null;
      });
      return;
    }

    setState(() {
      _selectedRight = right;
    });
    _checkPairFormed();
  }

  void _checkPairFormed() {
    if (_selectedLeft != null && _selectedRight != null) {
      final updated = Map<String, String>.from(widget.userMatches);
      updated[_selectedLeft!] = _selectedRight!;
      widget.onChanged(updated);
      setState(() {
        _selectedLeft = null;
        _selectedRight = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final lefts = widget.question.pairs.map((p) => p.left).toList();

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
        const SizedBox(height: 8),
        Text(
          'Select one on the left, then its match on the right.',
          style: textTheme.bodySmall?.copyWith(color: colors.mutedText),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                child: ListView.separated(
                  itemCount: lefts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = lefts[i];
                    final isMatched = widget.userMatches.containsKey(item);
                    final isSelected = _selectedLeft == item;

                    return _PairTile(
                      text: item,
                      isSelected: isSelected,
                      isMatched: isMatched,
                      onTap: () => _onLeftTap(item),
                      colors: colors,
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Right Column
              Expanded(
                child: ListView.separated(
                  itemCount: _shuffledRights.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = _shuffledRights[i];
                    final isMatched = widget.userMatches.containsValue(item);
                    final isSelected = _selectedRight == item;

                    return _PairTile(
                      text: item,
                      isSelected: isSelected,
                      isMatched: isMatched,
                      onTap: () => _onRightTap(item),
                      colors: colors,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PairTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isMatched;
  final VoidCallback onTap;
  final AppCustomColors colors;

  const _PairTile({
    required this.text,
    required this.isSelected,
    required this.isMatched,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = colors.card;
    Color border = colors.border;
    Color textCol = colors.text;

    if (isMatched) {
      bg = colors.successTint;
      border = colors.success;
      textCol = colors.success;
    } else if (isSelected) {
      bg = colors.primaryTint;
      border = colors.primary;
      textCol = colors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppSpacing.brCard,
          border: Border.all(color: border, width: 2),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: textCol,
              ),
        ),
      ),
    );
  }
}

