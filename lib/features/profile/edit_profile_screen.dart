import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Sandun Dimantha');
  final _emailCtrl = TextEditingController(text: 'sandun@example.com');
  String _selectedLevel = 'Intermediate';
  String _selectedGoal = 'Everyday Conversation';

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(userPreferencesProvider);
    if (prefs.englishLevel != null) _selectedLevel = prefs.englishLevel!;
    if (prefs.learningGoal != null) _selectedGoal = prefs.learningGoal!;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final notifier = ref.read(userPreferencesProvider.notifier);
    await notifier.setEnglishLevel(_selectedLevel);
    await notifier.setLearningGoal(_selectedGoal);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully! ✨')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Edit Profile',
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

              // Avatar selection
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: colors.primaryTint,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.primary, width: 2),
                      ),
                      child: const Center(
                        child: Text('👨‍💻', style: TextStyle(fontSize: 48)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Name Field
              Text('Full Name', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.card,
                  border: OutlineInputBorder(
                    borderRadius: AppSpacing.brCard,
                    borderSide: BorderSide(color: colors.border),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Email Field
              Text('Email Address', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.card,
                  border: OutlineInputBorder(
                    borderRadius: AppSpacing.brCard,
                    borderSide: BorderSide(color: colors.border),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // English Level Dropdown
              Text('Target Level', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: AppSpacing.brCard,
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLevel,
                    isExpanded: true,
                    items: ['Beginner', 'Elementary', 'Intermediate', 'Advanced']
                        .map((lvl) => DropdownMenuItem(value: lvl, child: Text(lvl)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLevel = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Learning Goal Dropdown
              Text('Learning Goal', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: AppSpacing.brCard,
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGoal,
                    isExpanded: true,
                    items: [
                      'Everyday Conversation',
                      'Travel & Tourism',
                      'Business & Career',
                      'Academic Study',
                      'Exam Preparation',
                      'Move Abroad'
                    ]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGoal = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 36),

              PrimaryButton(
                label: 'Save Changes',
                onPressed: _save,
              ),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}

