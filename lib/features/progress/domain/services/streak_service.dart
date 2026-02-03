// lib/features/progress/domain/services/streak_service.dart

/// Streak calculation rules
/// 
/// A day counts as active if user:
/// 1. Views at least 1 topic content, OR
/// 2. Completes at least 1 quiz
/// 
/// Streak resets at midnight local time if previous day was inactive

class StreakService {
  /// Calculate current streak
  int calculateStreak({
    required List<DateTime> activeDates,
  }) {
    if (activeDates.isEmpty) return 0;
    
    // Normalize to dates only (no time)
    final dates = activeDates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Descending
    
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));
    
    // Check if today or yesterday is in the list
    if (!dates.contains(todayDate) && !dates.contains(yesterdayDate)) {
      return 0; // Streak broken
    }
    
    // Count consecutive days
    int streak = 0;
    DateTime checkDate = dates.contains(todayDate) ? todayDate : yesterdayDate;
    
    for (final date in dates) {
      if (date == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break; // Gap found
      }
    }
    
    return streak;
  }
  
  /// Check if user was active today
  bool isActiveToday({
    required List<DateTime> activeDates,
  }) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return activeDates.any((d) => 
      d.year == todayDate.year && 
      d.month == todayDate.month && 
      d.day == todayDate.day
    );
  }
}
