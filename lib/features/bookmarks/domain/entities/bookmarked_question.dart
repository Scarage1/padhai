// Entity representing a bookmarked question
class BookmarkedQuestion {
  final int id;
  final int questionId;
  final String questionText;
  final String chapterName;
  final String subjectName;
  final String difficulty;
  final DateTime createdAt;

  const BookmarkedQuestion({
    required this.id,
    required this.questionId,
    required this.questionText,
    required this.chapterName,
    required this.subjectName,
    required this.difficulty,
    required this.createdAt,
  });
}
