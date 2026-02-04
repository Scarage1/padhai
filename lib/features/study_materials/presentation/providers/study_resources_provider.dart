// lib/features/study_materials/presentation/providers/study_resources_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/study_materials/domain/usecases/get_study_resources_by_chapter_usecase.dart';
import 'package:padhai/features/study_materials/domain/usecases/get_resources_by_type_usecase.dart';

// Provider for GetStudyResourcesByChapterUseCase
final getStudyResourcesByChapterUseCaseProvider =
    Provider<GetStudyResourcesByChapterUseCase>((ref) {
  return GetStudyResourcesByChapterUseCase(getIt<AppDatabase>());
});

// Provider for GetResourcesByTypeUseCase
final getResourcesByTypeUseCaseProvider = Provider<GetResourcesByTypeUseCase>((ref) {
  return GetResourcesByTypeUseCase(getIt<AppDatabase>());
});

// Provider for all study resources by chapter
final studyResourcesProvider =
    FutureProvider.family<List<StudyResource>, String>((ref, chapterId) async {
  final useCase = ref.watch(getStudyResourcesByChapterUseCaseProvider);
  final result = await useCase(chapterId);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (resources) => resources,
  );
});

// Provider for resources by type
final resourcesByTypeProvider = FutureProvider.family<List<StudyResource>, 
    ({String chapterId, String resourceType})>((ref, params) async {
  final useCase = ref.watch(getResourcesByTypeUseCaseProvider);
  final result = await useCase(
    chapterId: params.chapterId,
    resourceType: params.resourceType,
  );
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (resources) => resources,
  );
});

// Stream provider for reactive updates
final studyResourcesStreamProvider =
    StreamProvider.family<List<StudyResource>, int>((ref, chapterId) {
  final database = getIt<AppDatabase>();
  return database.studyResourcesDao.watchResourcesByChapter(chapterId);
});
