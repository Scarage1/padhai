// lib/features/auth/domain/usecases/get_current_user_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';
import 'package:padhai/features/auth/domain/repositories/auth_repository.dart';

@injectable
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, User?>> call() {
    return _repository.getCurrentUser();
  }
}
