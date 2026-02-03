// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  // Reset GetIt for testing (allows multiple calls)
  if (getIt.isRegistered<AppDatabase>()) {
    return; // Already configured
  }
  getIt.init();
}

@module
abstract class AppModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();
}
