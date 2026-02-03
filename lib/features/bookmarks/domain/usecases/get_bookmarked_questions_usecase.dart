import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/bookmarked_question.dart';

// Note: Current schema only supports topic bookmarks
// Question bookmarks not yet supported in schema
class GetBookmarkedQuestionsUseCase {
  Future<Either<Failure, List<BookmarkedQuestion>>> call({
    required String userId,
  }) async {
    // Not implemented - schema only supports topic bookmarks
    return right([]);
  }
}
