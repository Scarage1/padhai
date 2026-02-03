import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

// Note: Current schema only supports topic bookmarks
// Question bookmarks not yet supported in schema
class AddQuestionBookmarkUseCase {
  Future<Either<Failure, void>> call({
    required String userId,
    required String questionId,
  }) async {
    // Not implemented - schema only supports topic bookmarks
    return left(const DatabaseFailure('Question bookmarks not yet supported'));
  }
}
