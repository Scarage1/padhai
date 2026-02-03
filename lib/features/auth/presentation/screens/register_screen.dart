// lib/features/auth/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/core/utils/extensions/context_extensions.dart';
import 'package:padhai/core/utils/validators.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:padhai/shared/widgets/app_button.dart';
import 'package:padhai/shared/widgets/app_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
          _emailController.text.trim(),
          _nameController.text.trim(),
          _passwordController.text,
        );

    if (!mounted) return;

    if (success) {
      context.go(AppRoute.dashboard.path);
    } else {
      final error = ref.read(authProvider).error;
      context.showErrorSnackBar(error ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Account', style: AppTypography.h1),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Start your learning journey today',
                  style: AppTypography.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  validator: Validators.validateName,
                  prefixIcon: const Icon(Icons.person_outlined),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Password',
                  hint: 'Create a password (min 6 characters)',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) =>
                      Validators.validateMinLength(value, 6, 'Password'),
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                AppButton(
                  label: 'Create Account',
                  onPressed: _handleRegister,
                  fullWidth: true,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Already have an account? Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
