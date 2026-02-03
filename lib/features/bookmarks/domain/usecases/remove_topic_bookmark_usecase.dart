import 'package:fpdart/fpdart.dart';
import '../../../../core/database/daos/bookmarks_dao.dart';
import '../../../../core/error/failures.dart';

// Use case to remove a topic from bookmarks
class RemoveTopicBookmarkUseCase {
  final BookmarksDao _bookmarksDao;

  RemoveTopicBookmarkUseCase(this._bookmarksDao);

  Future<Either<Failure, void>> call({
    required String userId,
    required String topicId,
  }) async {
    try {
      await _bookmarksDao.deleteBookmark(userId, topicId);
      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to remove bookmark: ${e.toString()}'));
    }
  }
}
