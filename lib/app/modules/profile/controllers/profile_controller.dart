import 'package:get/get.dart';
import 'package:project_master_template/app/core/navigation/app_router.dart';
import 'package:project_master_template/app/core/navigation/app_routes.dart';
import 'package:project_master_template/app/core/services/logger_service.dart';
import 'package:project_master_template/app/data/service/storage_service.dart';
import 'package:project_master_template/app/widgets/dialogs/app_dialogs.dart';

class ProfileController extends GetxController {
  // Services
  final LoggerService _logger = Get.find<LoggerService>();
  final StorageService _storage = Get.find<StorageService>();

  // Observable variables
  final isLoading = false.obs;
  final isEditMode = false.obs;

  // User profile data
  final userName = 'John Doe'.obs;
  final userEmail = 'john.doe@example.com'.obs;
  final userPhone = '+1 234 567 8900'.obs;
  final userBio = 'Flutter developer passionate about creating amazing mobile experiences.'.obs;
  final userLocation = 'San Francisco, CA'.obs;
  final userWebsite = 'https://johndoe.dev'.obs;
  final profileImageUrl = Rxn<String>();

  // Statistics
  final favoriteCount = 24.obs;
  final reviewsCount = 12.obs;
  final visitedCount = 8.obs;
  final achievementsCount = 15.obs;

  @override
  void onInit() {
    super.onInit();
    _logger.info('ProfileController initialized');
    _loadProfileData();
  }

  @override
  void onReady() {
    super.onReady();
    _logger.info('ProfileController ready');
  }

  @override
  void onClose() {
    _logger.info('ProfileController disposed');
    super.onClose();
  }

  // Load profile data from storage or API
  Future<void> _loadProfileData() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Load from storage if available
      final savedName = _storage.getString('user_name');
      final savedEmail = _storage.getString('user_email');
      final savedPhone = _storage.getString('user_phone');
      final savedBio = _storage.getString('user_bio');
      final savedLocation = _storage.getString('user_location');
      final savedWebsite = _storage.getString('user_website');

      if (savedName != null) userName.value = savedName;
      if (savedEmail != null) userEmail.value = savedEmail;
      if (savedPhone != null) userPhone.value = savedPhone;
      if (savedBio != null) userBio.value = savedBio;
      if (savedLocation != null) userLocation.value = savedLocation;
      if (savedWebsite != null) userWebsite.value = savedWebsite;

      _logger.info('Profile data loaded successfully');
    } on Exception catch (error) {
      _logger.error('Failed to load profile data: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to load profile data.');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    isEditMode.toggle();
    _logger.debug('Edit mode toggled: ${isEditMode.value}');
  }

  // Update profile data
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String bio,
    required String location,
    required String website,
  }) async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Update observable values
      userName.value = name;
      userEmail.value = email;
      userPhone.value = phone;
      userBio.value = bio;
      userLocation.value = location;
      userWebsite.value = website;

      // Save to storage
      await _storage.setString('user_name', name);
      await _storage.setString('user_email', email);
      await _storage.setString('user_phone', phone);
      await _storage.setString('user_bio', bio);
      await _storage.setString('user_location', location);
      await _storage.setString('user_website', website);

      // Exit edit mode
      isEditMode.value = false;

      _logger.info('Profile updated successfully');

      AppSnackbar.success(title: 'Success', message: 'Profile updated successfully.');
    } on Exception catch (error) {
      _logger.error('Failed to update profile: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to update profile. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String imagePath) async {
    try {
      isLoading.value = true;

      // Simulate image upload
      await Future.delayed(const Duration(seconds: 2));

      profileImageUrl.value = imagePath;
      await _storage.setString('profile_image_url', imagePath);

      _logger.info('Profile image updated successfully');

      AppSnackbar.success(title: 'Success', message: 'Profile image updated successfully.');
    } on Exception catch (error) {
      _logger.error('Failed to update profile image: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to update profile image.');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final confirmed = await AppDialog.confirm(
        title: 'Delete Account',
        message: 'Are you sure you want to delete your account? This action cannot be undone.',
        isDanger: true,
      );

      if (confirmed != true) return;

      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Clear all user data
      await _storage.clear();

      _logger.info('Account deleted successfully');

      AppSnackbar.info(title: 'Account Deleted', message: 'Your account has been deleted successfully.');

      // Navigate to login
      AppRouter.router.go(AppRoutes.login);
    } on Exception catch (error) {
      _logger.error('Failed to delete account: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to delete account. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Export user data
  Future<void> exportUserData() async {
    try {
      isLoading.value = true;

      // Simulate data export
      await Future.delayed(const Duration(seconds: 2));

      _logger.info('User data exported successfully');

      AppSnackbar.success(title: 'Export Complete', message: 'Your data has been exported successfully.');
    } on Exception catch (error) {
      _logger.error('Failed to export user data: $error');

      AppSnackbar.error(title: 'Error', message: 'Failed to export user data.');
    } finally {
      isLoading.value = false;
    }
  }

  // Getters for computed values
  String get initials {
    final nameParts = userName.value.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return userName.value.isNotEmpty ? userName.value[0].toUpperCase() : 'U';
  }

  bool get hasProfileImage => profileImageUrl.value != null;

  int get totalStats => favoriteCount.value + reviewsCount.value + visitedCount.value + achievementsCount.value;
}
