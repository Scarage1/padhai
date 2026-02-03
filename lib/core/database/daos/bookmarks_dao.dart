// lib/core/database/daos/bookmarks_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'bookmarks_dao.g.dart';

@DriftAccessor(tables: [Bookmarks])
class BookmarksDao extends DatabaseAccessor<AppDatabase>
    with _$BookmarksDaoMixin {
  BookmarksDao(super.db);

  Future<int> insertBookmark(BookmarksCompanion bookmark) {
    return into(bookmarks).insert(bookmark);
  }

  Future<int> deleteBookmark(String userId, String topicId) {
    return (delete(bookmarks)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.topicId.equals(topicId)))
        .go();
  }

  Future<List<Bookmark>> getUserBookmarks(String userId) {
    return (select(bookmarks)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<bool> isTopicBookmarked(String userId, String topicId) async {
    final result = await (select(bookmarks)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.topicId.equals(topicId)))
        .getSingleOrNull();
    return result != null;
  }

  Stream<List<Bookmark>> watchUserBookmarks(String userId) {
    return (select(bookmarks)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }
}
