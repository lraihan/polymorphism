import 'dart:async';
import 'dart:math' as math;

class AppUtils {
  // Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalize each word
  static String capitalizeWords(String text) => text.split(' ').map(capitalize).join(' ');

  // Remove special characters and spaces
  static String sanitizeString(String text) => text.replaceAll(RegExp('[^a-zA-Z0-9]'), '');

  // Generate initials from name
  static String getInitials(String name, [int count = 2]) {
    final words = name.trim().split(' ');
    final initials = words.take(count).map((word) => word.isNotEmpty ? word[0].toUpperCase() : '').join();
    return initials;
  }

  // Check if string is numeric
  static bool isNumeric(String str) => double.tryParse(str) != null;

  // Truncate text with ellipsis
  static String truncateAutoSizeText(String text, int maxLength, [String suffix = '...']) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + suffix;
  }

  // Remove HTML tags
  static String removeHtmlTags(String html) => html.replaceAll(RegExp('<[^>]*>'), '');

  // Get random item from list
  static T getRandomItem<T>(List<T> list) {
    final random = math.Random();
    return list[random.nextInt(list.length)];
  }

  // Shuffle list
  static List<T> shuffleList<T>(List<T> list) {
    final newList = List<T>.from(list)..shuffle();
    return newList;
  }

  // Get unique items from list
  static List<T> getUniqueItems<T>(List<T> list) => list.toSet().toList();

  // Group list by key
  static Map<K, List<T>> groupBy<T, K>(List<T> list, K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final item in list) {
      final key = keySelector(item);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  // Debounce function
  static void debounce(String key, void Function() action, {Duration delay = const Duration(milliseconds: 500)}) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, action);
  }

  static final Map<String, Timer> _debounceTimers = {};

  // Throttle function
  static void throttle(String key, void Function() action, {Duration delay = const Duration(milliseconds: 500)}) {
    if (_throttleTimers.containsKey(key)) return;

    action();
    _throttleTimers[key] = Timer(delay, () {
      _throttleTimers.remove(key);
    });
  }

  static final Map<String, Timer> _throttleTimers = {};

  // Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  // Clamp value between min and max
  static T clamp<T extends num>(T value, T min, T max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  // Convert hex color to int
  static int hexToInt(String hex) {
    var cleanHex = hex.replaceAll('#', '');
    if (cleanHex.length == 6) cleanHex = 'FF$cleanHex';
    return int.parse(cleanHex, radix: 16);
  }

  // Generate UUID v4
  static String generateUuid() {
    final random = math.Random();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    bytes[6] = (bytes[6] & 0x0F) | 0x40; // Version 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // Variant bits

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}
