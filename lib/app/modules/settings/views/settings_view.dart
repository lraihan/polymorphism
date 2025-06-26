import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';
import 'package:project_master_template/app/core/theme/theme_controller.dart';
import 'package:project_master_template/app/modules/settings/controllers/settings_controller.dart';
import 'package:project_master_template/app/widgets/widgets.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const AutoSizeText('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        padding: AppSpacing.m,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _SectionHeader(title: 'Appearance', theme: theme),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Obx(
                    () => _SwitchTile(
                      icon: themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      title: 'Dark Mode',
                      subtitle: 'Switch between light and dark theme',
                      value: themeController.isDarkMode,
                      onChanged: (value) => themeController.toggleTheme(),
                    ),
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.palette,
                    title: 'Theme Settings',
                    subtitle: 'Customize app appearance',
                    onTap: () => context.go(AppRoutes.settingsTheme),
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'Change app language',
                    onTap: () => context.go(AppRoutes.settingsLanguage),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // Notifications Section
            _SectionHeader(title: 'Notifications', theme: theme),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Obx(
                    () => _SwitchTile(
                      icon: Icons.notifications,
                      title: 'Push Notifications',
                      subtitle: 'Receive push notifications',
                      value: controller.pushNotificationsEnabled.value,
                      onChanged: (value) => controller.togglePushNotifications(value: value),
                    ),
                  ),
                  const Divider(height: 1),
                  Obx(
                    () => _SwitchTile(
                      icon: Icons.email,
                      title: 'Email Notifications',
                      subtitle: 'Receive email notifications',
                      value: controller.emailNotificationsEnabled.value,
                      onChanged: (value) => controller.toggleEmailNotifications(value: value),
                    ),
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.tune,
                    title: 'Notification Settings',
                    subtitle: 'Customize notification preferences',
                    onTap: () => context.go(AppRoutes.settingsNotifications),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // Privacy & Security Section
            _SectionHeader(title: 'Privacy & Security', theme: theme),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.security,
                    title: 'Privacy Settings',
                    subtitle: 'Manage your privacy preferences',
                    onTap: () {
                      // Handle privacy settings
                    },
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: () {
                      // Handle password change
                    },
                  ),
                  const Divider(height: 1),
                  Obx(
                    () => _SwitchTile(
                      icon: Icons.fingerprint,
                      title: 'Biometric Login',
                      subtitle: 'Use fingerprint or face ID',
                      value: controller.biometricAuth.value,
                      onChanged: (value) => controller.toggleBiometricAuth(value: value),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // Support Section
            _SectionHeader(title: 'Support', theme: theme),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.help,
                    title: 'Help & FAQ',
                    subtitle: 'Get help and find answers',
                    onTap: () => context.go(AppRoutes.help),
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.feedback,
                    title: 'Send Feedback',
                    subtitle: 'Share your thoughts with us',
                    onTap: () {
                      // Handle feedback
                    },
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.info,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () => context.go(AppRoutes.settingsAbout),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingXL),

            // Logout Button
            AppButton(
              text: 'Logout',
              onPressed: () async {
                final confirmed = await AppDialog.confirm(
                  title: 'Logout',
                  message: 'Are you sure you want to logout?',
                  isDanger: true,
                );

                if ((confirmed ?? false) && context.mounted) {
                  context.go(AppRoutes.login);
                  AppSnackbar.info(title: 'Logged Out', message: 'You have been successfully logged out.');
                }
              },
              isExpanded: true,
              isOutlined: true,
              backgroundColor: theme.colorScheme.error,
              icon: const Icon(Icons.logout),
            ),

            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.theme});
  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: AppSizes.paddingXS, bottom: AppSizes.paddingS),
    child: AutoSizeText(
      title,
      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
    ),
  );
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppListTile(
    leading: Icon(icon),
    title: AutoSizeText(title),
    subtitle: AutoSizeText(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => AppListTile(
    leading: Icon(icon),
    title: AutoSizeText(title),
    subtitle: AutoSizeText(subtitle),
    trailing: Switch(value: value, onChanged: onChanged),
  );
}
