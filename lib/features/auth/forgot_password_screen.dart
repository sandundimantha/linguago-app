import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

/// Forgot password screen — enter email and receive a reset link.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(authNotifierProvider.notifier)
        .resetPassword(_emailCtrl.text.trim());
    if (ok && mounted) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;

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
        leading: const BackButton(),
        title: Text(
          'Reset Password',
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
            vertical: 24,
          ),
          child: _sent ? _buildSuccess(colors, textTheme) : _buildForm(colors, textTheme, isLoading),
        ),
      ),
    );
  }

  Widget _buildForm(AppCustomColors colors, TextTheme textTheme, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.accentTint,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🔑', style: TextStyle(fontSize: 40)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Enter the email address associated with your account and we'll send a password reset link.",
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.mutedText,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Email',
            style: textTheme.labelMedium?.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              hintStyle:
                  TextStyle(color: colors.mutedText.withValues(alpha: 0.6)),
              prefixIcon:
                  Icon(Icons.email_outlined, color: colors.mutedText, size: 20),
              filled: true,
              fillColor: colors.card,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final emailRe =
                  RegExp(r'^[\w\.\-\+]+@[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}$');
              if (!emailRe.hasMatch(v.trim())) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Send Reset Link',
            isLoading: isLoading,
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(AppCustomColors colors, TextTheme textTheme) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: colors.successTint,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('✅', style: TextStyle(fontSize: 48)),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Check your inbox!',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We sent a password reset link to\n${_emailCtrl.text.trim()}',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.mutedText,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Back to Login',
          onPressed: () => context.go('/auth/login'),
        ),
      ],
    );
  }
}

