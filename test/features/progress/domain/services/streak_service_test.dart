// test/features/progress/domain/services/streak_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:padhai/features/progress/domain/services/streak_service.dart';

void main() {
  late StreakService streakService;
  
  setUp(() {
    streakService = StreakService();
  });
  
  group('calculateStreak', () {
    test('returns 0 when no active dates', () {
      final streak = streakService.calculateStreak(activeDates: []);
      expect(streak, equals(0));
    });
    
    test('returns 0 when gap exists', () {
      final dates = [
        DateTime.now().subtract(const Duration(days: 3)),
        DateTime.now().subtract(const Duration(days: 4)),
      ];
      
      final streak = streakService.calculateStreak(activeDates: dates);
      expect(streak, equals(0));
    });
    
    test('returns correct streak count', () {
      final dates = [
        DateTime.now(),
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().subtract(const Duration(days: 2)),
        DateTime.now().subtract(const Duration(days: 3)),
        DateTime.now().subtract(const Duration(days: 4)),
      ];
      
      final streak = streakService.calculateStreak(activeDates: dates);
      expect(streak, equals(5));
    });
    
    test('counts streak starting from yesterday', () {
      final dates = [
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().subtract(const Duration(days: 2)),
      ];
      
      final streak = streakService.calculateStreak(activeDates: dates);
      expect(streak, equals(2));
    });
    
    test('handles multiple activities on same day', () {
      final dates = [
        DateTime.now(),
        DateTime.now().subtract(const Duration(hours: 2)),
        DateTime.now().subtract(const Duration(days: 1)),
      ];
      
      final streak = streakService.calculateStreak(activeDates: dates);
      expect(streak, equals(2));
    });
  });
  
  group('isActiveToday', () {
    test('returns true when active today', () {
      final result = streakService.isActiveToday(
        activeDates: [DateTime.now()],
      );
      expect(result, isTrue);
    });
    
    test('returns false when not active today', () {
      final result = streakService.isActiveToday(
        activeDates: [DateTime.now().subtract(const Duration(days: 1))],
      );
      expect(result, isFalse);
    });
  });
}
