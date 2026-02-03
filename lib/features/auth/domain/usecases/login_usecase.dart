// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';
import 'package:padhai/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
