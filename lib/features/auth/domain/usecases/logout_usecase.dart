// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
