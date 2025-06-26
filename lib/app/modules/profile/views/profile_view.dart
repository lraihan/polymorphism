import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';
import 'package:project_master_template/app/modules/profile/controllers/profile_controller.dart';
import 'package:project_master_template/app/widgets/widgets.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go(AppRoutes.profileEdit),
            tooltip: 'Edit Profile',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(AppRoutes.profileSettings),
            tooltip: 'Profile Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.m,
        child: Column(
          children: [
            // Profile Picture and Info
            AppCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary,
                    child: AutoSizeText(
                      'JD',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  AutoSizeText('John Doe', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppSizes.paddingXS),
                  AutoSizeText(
                    'john.doe@example.com',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withAlpha(179)),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(icon: Icons.favorite, label: 'Favorites', value: '24', theme: theme),
                      _StatItem(icon: Icons.star, label: 'Reviews', value: '12', theme: theme),
                      _StatItem(icon: Icons.location_on, label: 'Visited', value: '8', theme: theme),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // Menu Items
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.person,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () => context.go(AppRoutes.profileEdit),
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.security,
                    title: 'Privacy Settings',
                    subtitle: 'Manage your privacy preferences',
                    onTap: () => context.go(AppRoutes.profileSettings),
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Configure notification preferences',
                    onTap: () => context.go(AppRoutes.notifications),
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () => context.go(AppRoutes.help),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

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
              icon: const Icon(Icons.logout),
            ),

            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.label, required this.value, required this.theme});
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: theme.colorScheme.primary, size: AppSizes.iconL),
      const SizedBox(height: AppSizes.paddingXS),
      AutoSizeText(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      AutoSizeText(
        label,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(153)),
      ),
    ],
  );
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.title, required this.subtitle, required this.onTap});
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
