import 'package:flutter/material.dart';

/// Data models for the Home Dashboard screen.
class HomeData {
  final UserProfile user;
  final UserStats stats;
  final DailyGoal goal;
  final ContinueLesson lesson;
  final List<QuickPracticeItem> quickPracticeItems;
  final WordOfTheDay wordOfTheDay;
  final MascotCheer mascotCheer;

  const HomeData({
    required this.user,
    required this.stats,
    required this.goal,
    required this.lesson,
    required this.quickPracticeItems,
    required this.wordOfTheDay,
    required this.mascotCheer,
  });

  /// Mock data mirroring the exact design values from screen.png and code.html
  factory HomeData.mock() {
    return const HomeData(
      user: UserProfile(
        name: 'Alex',
        greeting: 'Good morning, Alex!',
        motivationMessage: 'Keep your momentum going today.',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB1raLnqEpiWWLClcQ-TJp1sN7vxaXSRlLPfLdQY3zQHGPDPML4Xb4ixiobcV80PQIecFjtVnAtjy8qWlwSUvxNXrbteETamMEirqosK5BCCAgJoGFuB61OSPO9R09OkxVNpOkj_usCCzLd5wj0bkaUJCOMCL6_cs9F4KmlYXNmfPH2SLsh2zyj9t3Xm4XUn3uvL0iZkc4yfhzBd8ZltpAwpTqeaWAtsv-HqEhhsYQG',
      ),
      stats: UserStats(
        topBarStreak: 7,
        topBarGems: 420,
        streakDays: 18,
        totalXp: 1450,
        currentHearts: 5,
        maxHearts: 5,
      ),
      goal: DailyGoal(
        targetMinutes: 10,
        completedMinutes: 8,
        progressPercentage: 80,
        remainingMinutesMessage: '2 mins left today!',
        encouragementMessage: "Keep today's streak alive!",
      ),
      lesson: ContinueLesson(
        unitTitle: 'UNIT 3 • CONVERSATIONAL FLUENCY',
        lessonTitle: 'Lesson 4: Ordering at a Café',
        subtitle: 'Polite requests & ordering etiquette',
        currentStep: 3,
        totalSteps: 5,
        xpReward: 30,
        lessonId: '4',
      ),
      quickPracticeItems: [
        QuickPracticeItem(
          id: 'vocab',
          title: 'Vocabulary',
          subtitle: '12 words due for review',
          badgeText: '12 DUE',
          badgeType: QuickPracticeBadgeType.error,
          icon: Icons.menu_book_rounded,
        ),
        QuickPracticeItem(
          id: 'grammar',
          title: 'Grammar Drill',
          subtitle: 'Daily bite-size drills',
          badgeText: '+15 XP',
          badgeType: QuickPracticeBadgeType.primary,
          icon: Icons.extension_rounded,
        ),
        QuickPracticeItem(
          id: 'speaking',
          title: 'Speaking Lab',
          subtitle: 'Accent & speech accuracy',
          badgeText: 'AI LAB',
          badgeType: QuickPracticeBadgeType.secondary,
          icon: Icons.mic_rounded,
        ),
        QuickPracticeItem(
          id: 'listening',
          title: 'Listening',
          subtitle: 'Coffee shop audio clips',
          badgeText: '2 MIN',
          badgeType: QuickPracticeBadgeType.neutral,
          icon: Icons.headphones_rounded,
        ),
      ],
      wordOfTheDay: WordOfTheDay(
        word: 'Serendipity',
        partOfSpeech: 'noun',
        phonetic: '/ˌser.ənˈdɪp.ə.ti/',
        cefrLevel: 'CEFR C1',
        definition: 'Finding valuable or agreeable things not deliberately sought for.',
        example: '“Finding this café was pure serendipity.”',
      ),
      mascotCheer: MascotCheer(
        title: 'Lingo is cheering! 🦉',
        message: '1 lesson left to join Diamond League top 10!',
        mascotImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBhbG3Qq77oOCzG5rgbGEXh1zgLR3QQDPdrtULApnVaNHE3qg9JJ3QbOomr21xuhb54h6XRKbeEl_c0jJ_vGva_yzFKc-M1jTOtU_jAANaU8ONuUcHmA3NcjM0KnVG1LrdWeOz3bP6GfLFkQB1YL8E5esATk8gATp5g9z9RYoNAuHc4ox_c_26oF3oCjsuU6fl3HYAR5DN-0WS22dPce0aS-sZD9kGLJrCWA-w6mxvI',
      ),
    );
  }
}

class UserProfile {
  final String name;
  final String greeting;
  final String motivationMessage;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.greeting,
    required this.motivationMessage,
    required this.avatarUrl,
  });
}

class UserStats {
  final int topBarStreak;
  final int topBarGems;
  final int streakDays;
  final int totalXp;
  final int currentHearts;
  final int maxHearts;

  const UserStats({
    required this.topBarStreak,
    required this.topBarGems,
    required this.streakDays,
    required this.totalXp,
    required this.currentHearts,
    required this.maxHearts,
  });
}

class DailyGoal {
  final int targetMinutes;
  final int completedMinutes;
  final int progressPercentage;
  final String remainingMinutesMessage;
  final String encouragementMessage;

  const DailyGoal({
    required this.targetMinutes,
    required this.completedMinutes,
    required this.progressPercentage,
    required this.remainingMinutesMessage,
    required this.encouragementMessage,
  });
}

class ContinueLesson {
  final String unitTitle;
  final String lessonTitle;
  final String subtitle;
  final int currentStep;
  final int totalSteps;
  final int xpReward;
  final String lessonId;

  const ContinueLesson({
    required this.unitTitle,
    required this.lessonTitle,
    required this.subtitle,
    required this.currentStep,
    required this.totalSteps,
    required this.xpReward,
    required this.lessonId,
  });

  double get progress => totalSteps > 0 ? currentStep / totalSteps : 0.0;
}

enum QuickPracticeBadgeType {
  error,
  primary,
  secondary,
  neutral,
}

class QuickPracticeItem {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final QuickPracticeBadgeType badgeType;
  final IconData icon;

  const QuickPracticeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeType,
    required this.icon,
  });
}

class WordOfTheDay {
  final String word;
  final String partOfSpeech;
  final String phonetic;
  final String cefrLevel;
  final String definition;
  final String example;

  const WordOfTheDay({
    required this.word,
    required this.partOfSpeech,
    required this.phonetic,
    required this.cefrLevel,
    required this.definition,
    required this.example,
  });
}

class MascotCheer {
  final String title;
  final String message;
  final String mascotImageUrl;

  const MascotCheer({
    required this.title,
    required this.message,
    required this.mascotImageUrl,
  });
}

