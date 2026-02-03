// lib/features/auth/domain/usecases/register_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';
import 'package:padhai/features/auth/domain/repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, User>> call(
    String email,
    String name,
    String password,
  ) {
    return _repository.register(email, name, password);
  }
}
