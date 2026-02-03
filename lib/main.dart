import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/app/app.dart';
import 'package:padhai/core/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure dependency injection
  configureDependencies();
  
  runApp(
    const ProviderScope(
      child: PadhaiApp(),
    ),
  );
}
