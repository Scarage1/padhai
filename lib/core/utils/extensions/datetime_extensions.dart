// lib/core/utils/extensions/datetime_extensions.dart

extension DateTimeExtensions on DateTime {
  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  // Get days difference from today
  int get daysFromToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);
    return today.difference(date).inDays;
  }

  // Format as relative time
  String toRelativeTime() {
    final diff = DateTime.now().difference(this);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
