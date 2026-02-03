// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/chapters/domain/usecases/get_topics_by_chapter_usecase.dart'
    as _i896;
import '../../features/dashboard/domain/usecases/get_subjects_usecase.dart'
    as _i733;
import '../../features/dashboard/domain/usecases/get_user_stats_usecase.dart'
    as _i880;
import '../../features/quiz/domain/usecases/get_questions_by_chapter_usecase.dart'
    as _i1012;
import '../../features/quiz/domain/usecases/save_quiz_attempt_usecase.dart'
    as _i368;
import '../../features/subjects/domain/usecases/get_chapters_by_subject_usecase.dart'
    as _i175;
import '../database/app_database.dart' as _i982;
import '../network/api_client.dart' as _i557;
import '../network/network_info.dart' as _i932;
import '../storage/secure_storage.dart' as _i619;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final networkModule = _$NetworkModule();
    final storageModule = _$StorageModule();
    gh.lazySingleton<_i982.AppDatabase>(() => appModule.database);
    gh.lazySingleton<_i895.Connectivity>(() => networkModule.connectivity);
    gh.lazySingleton<_i557.ApiClient>(() => _i557.ApiClient());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => storageModule.secureStorage,
    );
    gh.factory<_i896.GetTopicsByChapterUseCase>(
      () => _i896.GetTopicsByChapterUseCase(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i1012.GetQuestionsByChapterUseCase>(
      () => _i1012.GetQuestionsByChapterUseCase(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i368.SaveQuizAttemptUseCase>(
      () => _i368.SaveQuizAttemptUseCase(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i733.GetSubjectsUseCase>(
      () => _i733.GetSubjectsUseCase(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i880.GetUserStatsUseCase>(
      () => _i880.GetUserStatsUseCase(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i175.GetChaptersBySubjectUseCase>(
      () => _i175.GetChaptersBySubjectUseCase(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i619.SecureStorage>(
      () => _i619.SecureStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.factory<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSource(
        gh<_i982.AppDatabase>(),
        gh<_i619.SecureStorage>(),
      ),
    );
    gh.factory<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSource(
        gh<_i557.ApiClient>(),
        gh<_i619.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i992.AuthLocalDataSource>(),
        gh<_i932.NetworkInfo>(),
      ),
    );
    gh.factory<_i941.RegisterUseCase>(
      () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i17.GetCurrentUserUseCase>(
      () => _i17.GetCurrentUserUseCase(gh<_i787.AuthRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i464.AppModule {}

class _$NetworkModule extends _i932.NetworkModule {}

class _$StorageModule extends _i619.StorageModule {}
