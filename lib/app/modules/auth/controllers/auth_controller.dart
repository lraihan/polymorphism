import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_master_template/app/core/navigation/navigation_extensions.dart';
import 'package:project_master_template/app/core/services/logger_service.dart';
import 'package:project_master_template/app/data/service/storage_service.dart';
import 'package:project_master_template/app/widgets/dialogs/app_dialogs.dart';

class AuthController extends GetxController {
  // Services
  final LoggerService _logger = Get.find<LoggerService>();
  final StorageService _storage = Get.find<StorageService>();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final rememberMe = false.obs;
  final acceptTerms = false.obs;

  // User data
  final currentUser = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    _logger.info('AuthController initialized');
    _checkAuthStatus();
  }

  @override
  void onReady() {
    super.onReady();
    _logger.info('AuthController ready');
  }

  @override
  void onClose() {
    _logger.info('AuthController disposed');
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  void _checkAuthStatus() {
    final token = _storage.getString('auth_token');
    final userData = _storage.getString('user_data');

    if (token != null && userData != null) {
      isLoggedIn.value = true;
      // Parse user data from storage if needed
      _logger.info('User already logged in');
    }
  }

  // Login method
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      _logger.info('Starting login process');

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful login
      final userData = {'id': '123', 'email': email, 'name': 'John Doe', 'avatar': null};

      // Store auth data
      await _storage.setString('auth_token', 'mock_token_123');
      await _storage.setString('user_data', userData.toString());

      if (rememberMe.value) {
        await _storage.setBool('remember_me', value: true);
      }

      // Update state
      currentUser.value = userData;
      isLoggedIn.value = true;

      _logger.info('User logged in successfully');

      // Navigate to home
      AppNavigation.replaceWithHome();

      // Show success message
      AppSnackbar.success(title: 'Welcome!', message: 'You have successfully logged in.');
    } on Exception catch (error) {
      _logger.error('Login failed: $error');

      AppSnackbar.error(title: 'Login Failed', message: 'Invalid email or password. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Login method with parameters (keeping for API compatibility)
  Future<void> loginWithCredentials({required String email, required String password}) async {
    emailController.text = email;
    passwordController.text = password;
    await login();
  }

  // Register method
  Future<void> register({required String name, required String email, required String password}) async {
    try {
      if (!acceptTerms.value) {
        AppSnackbar.warning(title: 'Terms Required', message: 'Please accept the terms and conditions to continue.');
        return;
      }

      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful registration
      _logger.info('User registered successfully');

      // Navigate to login
      AppNavigation.goToLogin();

      // Show success message
      AppSnackbar.success(title: 'Success!', message: 'Account created successfully. Please login.');

      // Reset form state
      acceptTerms.value = false;
    } on Exception catch (error) {
      _logger.error('Registration failed: $error');

      AppSnackbar.error(title: 'Registration Failed', message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      final confirmed = await AppDialog.confirm(title: 'Logout', message: 'Are you sure you want to logout?');

      if (confirmed != true) return;

      isLoading.value = true;

      // Clear stored data
      await _storage.remove('auth_token');
      await _storage.remove('user_data');
      await _storage.remove('remember_me');

      // Update state
      currentUser.value = null;
      isLoggedIn.value = false;
      rememberMe.value = false;

      _logger.info('User logged out successfully');

      // Navigate to login
      AppNavigation.replaceWithLogin();

      // Show success message
      AppSnackbar.info(title: 'Logged Out', message: 'You have been successfully logged out.');
    } on Exception catch (error) {
      _logger.error('Logout failed: $error');

      AppSnackbar.error(title: 'Logout Failed', message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot password method
  Future<void> forgotPassword({required String email}) async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _logger.info('Password reset email sent');

      AppSnackbar.success(title: 'Email Sent', message: 'Password reset instructions have been sent to your email.');
    } on Exception catch (error) {
      _logger.error('Forgot password failed: $error');

      AppSnackbar.error(title: 'Failed', message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.toggle();
    _logger.debug('Remember me toggled: ${rememberMe.value}');
  }

  // Toggle accept terms
  void toggleAcceptTerms() {
    acceptTerms.toggle();
    _logger.debug('Accept terms toggled: ${acceptTerms.value}');
  }

  // Check if user is authenticated
  bool get isAuthenticated => isLoggedIn.value;

  // Get user display name
  String get userName => currentUser.value?['name'] ?? 'User';

  // Get user email
  String get userEmail => currentUser.value?['email'] ?? '';

  // Navigate to appropriate page based on auth status
  void checkAuthAndNavigate() {
    if (isAuthenticated) {
      AppNavigation.goToHome();
    } else {
      AppNavigation.goToLogin();
    }
  }
}
