import 'package:fpdart/fpdart.dart';
import '../../../../core/database/daos/bookmarks_dao.dart';
import '../../../../core/error/failures.dart';
import '../entities/bookmarked_topic.dart';

// Use case to get all bookmarked topics for a user
class GetBookmarkedTopicsUseCase {
  final BookmarksDao _bookmarksDao;

  GetBookmarkedTopicsUseCase(this._bookmarksDao);

  Future<Either<Failure, List<BookmarkedTopic>>> call({
    required String userId,
  }) async {
    try {
      final results = await _bookmarksDao.getBookmarkedTopicsWithDetails(userId);
      
      final topics = results.map((row) {
        final bookmark = row.readTable(_bookmarksDao.bookmarks);
        final topic = row.readTable(_bookmarksDao.topics);
        final chapter = row.readTable(_bookmarksDao.chapters);
        final subject = row.readTable(_bookmarksDao.subjects);

        return BookmarkedTopic(
          id: bookmark.id.hashCode,
          topicId: topic.id.hashCode,
          topicTitle: topic.title,
          chapterName: chapter.name,
          subjectName: subject.name,
          createdAt: bookmark.createdAt,
        );
      }).toList();

      return right(topics);
    } catch (e) {
      return left(DatabaseFailure('Failed to fetch bookmarks: ${e.toString()}'));
    }
  }
}
