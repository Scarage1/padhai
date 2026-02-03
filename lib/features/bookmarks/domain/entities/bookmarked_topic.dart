// Entity representing a bookmarked topic
class BookmarkedTopic {
  final int id;
  final int topicId;
  final String topicTitle;
  final String chapterName;
  final String subjectName;
  final DateTime createdAt;

  const BookmarkedTopic({
    required this.id,
    required this.topicId,
    required this.topicTitle,
    required this.chapterName,
    required this.subjectName,
    required this.createdAt,
  });
}
