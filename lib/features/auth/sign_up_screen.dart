import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import '../../data/repositories/firebase_lesson_repository.dart';

/// Create Account screen with name, email, password, and confirm password fields.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = await ref.read(authNotifierProvider.notifier).signUp(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
    if (user != null && mounted) {
      final lessonRepo = ref.read(lessonRepositoryProvider);
      if (lessonRepo is FirebaseLessonRepository) {
        final prefs = ref.read(userPreferencesProvider);
        await lessonRepo.saveUserProfile(user: user, preferences: prefs);
      }
      if (mounted) context.go('/');
    }
  }

  Future<void> _signUpWithGoogle() async {
    final user =
        await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    if (user != null && mounted) {
      final lessonRepo = ref.read(lessonRepositoryProvider);
      if (lessonRepo is FirebaseLessonRepository) {
        final prefs = ref.read(userPreferencesProvider);
        await lessonRepo.saveUserProfile(user: user, preferences: prefs);
      }
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;

    // Show error snackbar
    ref.listen<AsyncValue>(authNotifierProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: colors.danger,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'Create Account',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name
                _buildLabel('Full Name', textTheme, colors),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    hint: 'Sandun Dimantha',
                    colors: colors,
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 2) {
                      return 'Enter at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                _buildLabel('Email', textTheme, colors),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: _inputDecoration(
                    hint: 'you@example.com',
                    colors: colors,
                    prefixIcon: Icons.email_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final emailRe = RegExp(
                        r'^[\w\.\-\+]+@[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}$');
                    if (!emailRe.hasMatch(v.trim())) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                _buildLabel('Password', textTheme, colors),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    hint: 'Min 8 characters',
                    colors: colors,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.mutedText,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 8) {
                      return 'At least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password
                _buildLabel('Confirm Password', textTheme, colors),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  decoration: _inputDecoration(
                    hint: 'Re-enter password',
                    colors: colors,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.mutedText,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v != _passwordCtrl.text) return 'Passwords don\'t match';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Sign up button
                PrimaryButton(
                  label: 'Sign Up',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
                const SizedBox(height: 16),

                // Or divider
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.mutedText,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.border)),
                  ],
                ),
                const SizedBox(height: 16),

                // Continue with Google button
                OutlinedButton(
                  onPressed: isLoading ? null : _signUpWithGoogle,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: colors.card,
                    side: BorderSide(color: colors.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.brButton,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 32,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Continue with Google',
                        style: textTheme.titleSmall?.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Link to log-in
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/auth/login'),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.mutedText,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(
      String label, TextTheme textTheme, AppCustomColors colors) {
    return Text(
      label,
      style: textTheme.labelMedium?.copyWith(
        color: colors.text,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required AppCustomColors colors,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.mutedText.withValues(alpha: 0.6)),
      prefixIcon: Icon(prefixIcon, color: colors.mutedText, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.brButton,
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.brButton,
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.brButton,
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.brButton,
        borderSide: BorderSide(color: colors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.brButton,
        borderSide: BorderSide(color: colors.danger, width: 2),
      ),
    );
  }
}

