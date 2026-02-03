// Entity for incorrect answer review
class IncorrectAnswer {
  final int answerId;
  final String questionText;
  final String userAnswer;
  final String correctAnswer;
  final String explanation;
  final String chapterName;
  final String subjectName;
  final DateTime attemptDate;

  const IncorrectAnswer({
    required this.answerId,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    required this.explanation,
    required this.chapterName,
    required this.subjectName,
    required this.attemptDate,
  });
}
