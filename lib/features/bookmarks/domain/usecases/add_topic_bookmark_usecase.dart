import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/daos/bookmarks_dao.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';

// Use case to add a topic to bookmarks
class AddTopicBookmarkUseCase {
  final BookmarksDao _bookmarksDao;

  AddTopicBookmarkUseCase(this._bookmarksDao);

  Future<Either<Failure, void>> call({
    required String userId,
    required String topicId,
  }) async {
    try {
      // Check if already bookmarked
      final isBookmarked = await _bookmarksDao.isTopicBookmarked(userId, topicId);

      if (isBookmarked) {
        return left(const DatabaseFailure('Topic already bookmarked'));
      }

      // Add bookmark
      const uuid = Uuid();
      final companion = BookmarksCompanion.insert(
        id: uuid.v4(),
        userId: userId,
        topicId: topicId,
        createdAt: DateTime.now(),
      );

      await _bookmarksDao.insertBookmark(companion);
      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to add bookmark: ${e.toString()}'));
    }
  }
}
