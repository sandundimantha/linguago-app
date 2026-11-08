import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';

/// 3-slide welcome carousel shown after the splash on first launch.
class WelcomeSlidesScreen extends StatefulWidget {
  const WelcomeSlidesScreen({super.key});

  @override
  State<WelcomeSlidesScreen> createState() => _WelcomeSlidesScreenState();
}

class _Slide {
  final String emoji;
  final String title;
  final String subtitle;
  const _Slide(this.emoji, this.title, this.subtitle);
}

class _WelcomeSlidesScreenState extends State<WelcomeSlidesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _Slide(
      '🌍',
      'Learn English\nYour Way',
      'Personalised lessons built around your goals, language, and daily schedule.',
    ),
    _Slide(
      '🎮',
      'Gamified\nDaily Lessons',
      'Earn XP, maintain streaks, and climb the leaderboard as you level up your English.',
    ),
    _Slide(
      '🗣️',
      'AI Speaking\nPractice',
      'Speak with our AI tutor and get instant pronunciation feedback anytime, anywhere.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/onboarding/language');
    }
  }

  void _skip() => context.go('/onboarding/language');

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = MediaQuery.of(context).size;
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: AppSpacing.screenMargin),
                child: AnimatedOpacity(
                  opacity: isLast ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: TextButton(
                    onPressed: isLast ? null : _skip,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.mutedText,
                          ),
                    ),
                  ),
                ),
              ),
            ),

            // Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return _SlideView(
                    slide: slide,
                    screenWidth: size.width,
                    colors: colors,
                  );
                },
              ),
            ),

            // Dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentPage ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentPage ? colors.primary : colors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            // CTA button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                24,
                AppSpacing.screenMargin,
                AppSpacing.screenMargin,
              ),
              child: PrimaryButton(
                label: isLast ? 'Get Started 🚀' : 'Next',
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  final double screenWidth;
  final AppCustomColors colors;

  const _SlideView({
    required this.slide,
    required this.screenWidth,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration area
          Container(
            width: screenWidth * 0.55,
            height: screenWidth * 0.55,
            decoration: BoxDecoration(
              color: colors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                slide.emoji,
                style: TextStyle(fontSize: screenWidth * 0.22),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.text,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.mutedText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

