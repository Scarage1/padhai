// lib/app/router/routes.dart

enum AppRoute {
  splash('/'),
  onboarding('/onboarding'),
  login('/login'),
  register('/register'),
  dashboard('/dashboard'),
  subjectDetail('/subject/:subjectId'),
  chapterDetail('/chapter/:chapterId'),
  topicDetail('/topic/:topicId'),
  quiz('/quiz/:chapterId'),
  quizResult('/quiz/:attemptId/result'),
  bookmarks('/bookmarks'),
  analytics('/analytics'),
  review('/review'),
  profile('/profile');

  const AppRoute(this.path);
  final String path;
}
