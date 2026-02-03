// lib/core/network/api_endpoints.dart

abstract class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://api.padhai.com';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Content
  static const String subjects = '/subjects';
  static String chapters(String subjectId) => '/subjects/$subjectId/chapters';
  static String topics(String chapterId) => '/chapters/$chapterId/topics';
  static String questions(String chapterId) => '/chapters/$chapterId/questions';

  // Progress
  static const String syncProgress = '/progress/sync';
  static const String submitQuiz = '/quiz/submit';
  static const String userProgress = '/progress/user';

  // Bookmarks
  static const String bookmarks = '/bookmarks';
  static String addBookmark(String topicId) => '/bookmarks/$topicId';
  static String removeBookmark(String topicId) => '/bookmarks/$topicId';
}
