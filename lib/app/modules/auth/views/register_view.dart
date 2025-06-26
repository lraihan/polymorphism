import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';
import 'package:project_master_template/app/core/utils/validators.dart';
import 'package:project_master_template/app/widgets/widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        AppSnackbar.warning(title: 'Terms Required', message: 'Please accept the terms and conditions to continue.');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate registration delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to login on successful registration
      if (mounted) {
        context.go(AppRoutes.login);
        AppSnackbar.success(title: 'Success!', message: 'Account created successfully. Please login.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const AutoSizeText('Register'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.m,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.paddingL),

                // Logo/Icon
                Icon(Icons.person_add, size: 80, color: theme.colorScheme.primary),
                const SizedBox(height: AppSizes.paddingL),

                // Welcome text
                AutoSizeText('Create Account', style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSizes.paddingS),
                AutoSizeText(
                  'Sign up to get started',
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha(153)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.paddingXL),

                // Name field
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: AppValidator.name,
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Email field
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: AppValidator.email,
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Password field
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: AppValidator.password,
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Confirm password field
                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) => AppValidator.confirmPassword(value, _passwordController.text),
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Terms and conditions
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingL),

                // Register button
                AppButton(text: 'Register', onPressed: _handleRegister, isLoading: _isLoading, isExpanded: true),
                const SizedBox(height: AppSizes.paddingM),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText('Already have an account? ', style: theme.textTheme.bodyMedium),
                    TextButton(onPressed: () => context.go(AppRoutes.login), child: const AutoSizeText('Login')),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
