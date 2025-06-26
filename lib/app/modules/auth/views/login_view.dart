import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';
import 'package:project_master_template/app/core/utils/validators.dart';
import 'package:project_master_template/app/modules/auth/controllers/auth_controller.dart';
import 'package:project_master_template/app/widgets/widgets.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: AutoSizeText('login'.tr), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.m,
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),

                // Logo/Icon
                Icon(Icons.account_circle, size: 100, color: theme.colorScheme.primary),
                const SizedBox(height: AppSizes.paddingL),

                // Welcome text
                AutoSizeText('welcome_back'.tr, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSizes.paddingS),
                AutoSizeText(
                  'sign_in_to_continue'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha(153)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.paddingXL),

                // Email field
                AppTextField(
                  controller: controller.emailController,
                  label: 'email'.tr,
                  hint: 'enter_your_email'.tr,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: AppValidator.email,
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Password field
                AppTextField(
                  controller: controller.passwordController,
                  label: 'password'.tr,
                  hint: 'enter_your_password'.tr,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: AppValidator.password,
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.forgotPassword),
                    child: AutoSizeText('forgot_password'.tr),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),

                // Login button
                Obx(
                  () => AppButton(
                    text: 'login'.tr,
                    onPressed: controller.login,
                    isLoading: controller.isLoading.value,
                    isExpanded: true,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText('dont_have_account'.tr, style: theme.textTheme.bodyMedium),
                    TextButton(onPressed: () => context.go(AppRoutes.register), child: AutoSizeText('register'.tr)),
                  ],
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
  });
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AutoSizeText(widget.label!, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSizes.paddingXS),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : widget.suffixIcon,
            border: const OutlineInputBorder(borderRadius: AppBorderRadius.s),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.s,
              borderSide: BorderSide(color: theme.colorScheme.outline.withAlpha(128)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.s,
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.s,
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            contentPadding: AppSpacing.m,
          ),
        ),
      ],
    );
  }
}
