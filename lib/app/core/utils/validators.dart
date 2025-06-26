import 'package:get/get.dart';

class AppValidator {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'email_invalid'.tr;
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr;
    }

    if (value.length < 8) {
      return 'password_min_length'.tr;
    }

    if (!value.contains(RegExp('[A-Z]'))) {
      return 'password_uppercase_required'.tr;
    }

    if (!value.contains(RegExp('[a-z]'))) {
      return 'password_lowercase_required'.tr;
    }

    if (!value.contains(RegExp('[0-9]'))) {
      return 'password_number_required'.tr;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'password_special_char_required'.tr;
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_required'.tr;
    }

    if (value != password) {
      return 'passwords_do_not_match'.tr;
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return 'field_required'.tr.replaceAll('%s', fieldName ?? 'field'.tr);
    }
    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'name_required'.tr;
    }

    if (value.length < 2) {
      return 'name_min_length'.tr;
    }

    if (value.length > 50) {
      return 'name_max_length'.tr;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'name_invalid_format'.tr;
    }

    return null;
  }

  // Minimum length validation
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return 'field_required'.tr.replaceAll('%s', fieldName ?? 'field'.tr);
    }

    if (value.length < minLength) {
      return 'field_min_length'.tr.replaceAll('%s', fieldName ?? 'field'.tr).replaceAll('%d', minLength.toString());
    }

    return null;
  }

  // Maximum length validation
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.length > maxLength) {
      return 'field_max_length'.tr.replaceAll('%s', fieldName ?? 'field'.tr).replaceAll('%d', maxLength.toString());
    }

    return null;
  }

  // Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'phone_required'.tr;
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'phone_invalid'.tr;
    }

    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'url_required'.tr;
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'url_invalid'.tr;
    }

    return null;
  }

  // Number validation
  static String? number(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return 'field_required'.tr.replaceAll('%s', fieldName ?? 'field'.tr);
    }

    if (double.tryParse(value) == null) {
      return 'number_invalid'.tr;
    }

    return null;
  }

  // Integer validation
  static String? integer(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return 'field_required'.tr.replaceAll('%s', fieldName ?? 'field'.tr);
    }

    if (int.tryParse(value) == null) {
      return 'integer_invalid'.tr;
    }

    return null;
  }

  // Range validation
  static String? range(String? value, double min, double max, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return 'field_required'.tr.replaceAll('%s', fieldName ?? 'field'.tr);
    }

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'number_invalid'.tr;
    }

    if (numValue < min || numValue > max) {
      return 'value_range'.tr.replaceAll('%s', fieldName ?? 'value'.tr).replaceAll('%min', min.toString()).replaceAll('%max', max.toString());
    }

    return null;
  }

  // Credit card validation
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'credit_card_required'.tr;
    }

    // Remove spaces and dashes
    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it's all digits and has valid length
    if (!RegExp(r'^\d{13,19}$').hasMatch(cardNumber)) {
      return 'credit_card_invalid'.tr;
    }

    // Luhn algorithm validation
    if (!_isValidLuhn(cardNumber)) {
      return 'credit_card_invalid'.tr;
    }

    return null;
  }

  // CVV validation
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'cvv_required'.tr;
    }

    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
      return 'cvv_invalid'.tr;
    }

    return null;
  }

  // Date validation (MM/YY format)
  static String? expiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'expiry_date_required'.tr;
    }

    if (!RegExp(r'^\d{2}\/\d{2}$').hasMatch(value)) {
      return 'expiry_date_invalid_format'.tr;
    }

    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) {
      return 'expiry_date_invalid'.tr;
    }

    if (month < 1 || month > 12) {
      return 'expiry_month_invalid'.tr;
    }

    final currentDate = DateTime.now();
    final expiryDate = DateTime(2000 + year, month);

    if (expiryDate.isBefore(DateTime(currentDate.year, currentDate.month))) {
      return 'expiry_date_expired'.tr;
    }

    return null;
  }

  // Age validation
  static String? age(String? value, {int minAge = 18, int maxAge = 120}) {
    if (value == null || value.isEmpty) {
      return 'age_required'.tr;
    }

    final ageValue = int.tryParse(value);
    if (ageValue == null) {
      return 'age_invalid'.tr;
    }

    if (ageValue < minAge) {
      return 'age_min'.tr.replaceAll('%d', minAge.toString());
    }

    if (ageValue > maxAge) {
      return 'age_max'.tr.replaceAll('%d', maxAge.toString());
    }

    return null;
  }

  // Combine multiple validators
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) return result;
    }
    return null;
  }

  // Luhn algorithm for credit card validation
  static bool _isValidLuhn(String cardNumber) {
    var sum = 0;
    var alternate = false;

    for (var i = cardNumber.length - 1; i >= 0; i--) {
      var digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }
}
