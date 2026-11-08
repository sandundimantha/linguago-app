import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/ai_chat_models.dart';

final scenariosListProvider = Provider<List<ScenarioModel>>((ref) {
  return const [
    ScenarioModel(
      id: 'cafe_order',
      title: 'Ordering at a Café',
      subtitle: 'Order coffee, milk alternatives, snacks, and pay the bill.',
      category: 'Daily Life',
      aiRole: 'Barista at Coffee Spot',
      userRole: 'Customer',
      initialAiMessage: 'Hi there! Welcome to Coffee Spot. What can I brew for you today?',
      level: 'Beginner',
      iconName: 'local_cafe_rounded',
      emoji: '☕',
      backgroundHint: 'Practice ordering items politely and answering milk/food questions.',
    ),
    ScenarioModel(
      id: 'hotel_checkin',
      title: 'Hotel Check-In',
      subtitle: 'Check into your hotel room, ask about breakfast, and get directions.',
      category: 'Travel',
      aiRole: 'Hotel Receptionist',
      userRole: 'Guest',
      initialAiMessage: 'Good afternoon, welcome to Grand Central Hotel! Are you checking in with us today?',
      level: 'Elementary',
      iconName: 'hotel_rounded',
      emoji: '🏨',
      backgroundHint: 'Provide your name, confirm your reservation, and ask about amenities.',
    ),
    ScenarioModel(
      id: 'job_interview',
      title: 'Job Interview Practice',
      subtitle: 'Introduce yourself, describe strengths, and answer behavioral questions.',
      category: 'Career',
      aiRole: 'Hiring Manager',
      userRole: 'Job Candidate',
      initialAiMessage: 'Welcome! Thank you for coming in today. Could you start by introducing yourself?',
      level: 'Intermediate',
      iconName: 'work_rounded',
      emoji: '💼',
      backgroundHint: 'Answer in professional English and highlight your background.',
    ),
    ScenarioModel(
      id: 'airport_directions',
      title: 'Navigating the Airport',
      subtitle: 'Find your departure gate, security check, and baggage claim.',
      category: 'Travel',
      aiRole: 'Airport Information Officer',
      userRole: 'Passenger',
      initialAiMessage: 'Hello! How can I assist you with your flight or finding your gate today?',
      level: 'Beginner',
      iconName: 'flight_takeoff_rounded',
      emoji: '✈️',
      backgroundHint: 'Ask where gates and baggage claims are located.',
    ),
  ];
});

class ScenarioPickerScreen extends ConsumerStatefulWidget {
  const ScenarioPickerScreen({super.key});

  @override
  ConsumerState<ScenarioPickerScreen> createState() => _ScenarioPickerScreenState();
}

class _ScenarioPickerScreenState extends ConsumerState<ScenarioPickerScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final scenarios = ref.watch(scenariosListProvider);

    final categories = ['All', 'Daily Life', 'Travel', 'Career'];
    final filteredScenarios = _selectedCategory == 'All'
        ? scenarios
        : scenarios.where((s) => s.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'AI Conversation',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: false,
        backgroundColor: colors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Upgrade to Unlimited',
            icon: Icon(Icons.star_rounded, color: colors.accent, size: 28),
            onPressed: () => context.push('/premium/paywall'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Tutor Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.primary,
                    colors.primary.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🤖', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Language Partner',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Practice real-life English anytime with instant friendly corrections.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : colors.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      selectedColor: colors.primary,
                      backgroundColor: colors.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? colors.primary : colors.border,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Scenarios Heading
            Text(
              'Select a Roleplay Scenario',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 12),

            // Scenarios List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredScenarios.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final scenario = filteredScenarios[index];
                return _buildScenarioCard(scenario, colors, textTheme);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioCard(
    ScenarioModel scenario,
    AppCustomColors colors,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: () {
        context.push('/ai-chat', extra: scenario);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(scenario.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scenario.title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          scenario.level,
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scenario.subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.mutedText,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded,
                          size: 14, color: colors.mutedText),
                      const SizedBox(width: 4),
                      Text(
                        'AI: ${scenario.aiRole}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: colors.mutedText),
          ],
        ),
      ),
    );
  }
}

