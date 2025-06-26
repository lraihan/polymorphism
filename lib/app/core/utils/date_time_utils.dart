import 'package:intl/intl.dart';

class DateTimeUtils {
  // Common date formats
  static const String defaultDateFormat = 'yyyy-MM-dd';
  static const String defaultTimeFormat = 'HH:mm:ss';
  static const String defaultDateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  static const String displayDateTimeFormat = 'MMM dd, yyyy hh:mm a';

  // Format date to string
  static String formatDate(DateTime date, [String? format]) => DateFormat(format ?? defaultDateFormat).format(date);

  // Format time to string
  static String formatTime(DateTime date, [String? format]) => DateFormat(format ?? defaultTimeFormat).format(date);

  // Format datetime to string
  static String formatDateTime(DateTime date, [String? format]) => DateFormat(format ?? defaultDateTimeFormat).format(date);

  // Parse string to date
  static DateTime? parseDate(String dateString, [String? format]) {
    try {
      return DateFormat(format ?? defaultDateFormat).parse(dateString);
    } on FormatException {
      return null;
    }
  }

  // Parse string to datetime
  static DateTime? parseDateTime(String dateTimeString, [String? format]) {
    try {
      return DateFormat(format ?? defaultDateTimeFormat).parse(dateTimeString);
    } on FormatException {
      return null;
    }
  }

  // Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  // Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  // Get end of day
  static DateTime endOfDay(DateTime date) => DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  // Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) => date.subtract(Duration(days: date.weekday - 1));

  // Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) => startOfWeek(date).add(const Duration(days: 6));

  // Get start of month
  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month,);

  // Get end of month
  static DateTime endOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);

  // Get start of year
  static DateTime startOfYear(DateTime date) => DateTime(date.year, );

  // Get end of year
  static DateTime endOfYear(DateTime date) => DateTime(date.year, 12, 31, 23, 59, 59, 999);

  // Calculate age
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;

    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  // Get days in month
  static int getDaysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  // Check if year is leap year
  static bool isLeapYear(int year) => (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  // Get day name
  static String getDayName(DateTime date) => DateFormat('EEEE').format(date);

  // Get month name
  static String getMonthName(DateTime date) => DateFormat('MMMM').format(date);

  // Add business days (skip weekends)
  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var remainingDays = days;

    while (remainingDays > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday && result.weekday != DateTime.sunday) {
        remainingDays--;
      }
    }

    return result;
  }

  // Get business days between two dates
  static int getBusinessDaysBetween(DateTime start, DateTime end) {
    var businessDays = 0;
    var current = start;

    while (current.isBefore(end)) {
      if (current.weekday != DateTime.saturday && current.weekday != DateTime.sunday) {
        businessDays++;
      }
      current = current.add(const Duration(days: 1));
    }

    return businessDays;
  }
}
