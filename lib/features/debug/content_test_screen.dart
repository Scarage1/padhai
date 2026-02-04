// lib/features/debug/content_test_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/core/content/content_initialization_service.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';

class ContentTestScreen extends StatefulWidget {
  const ContentTestScreen({super.key});

  @override
  State<ContentTestScreen> createState() => _ContentTestScreenState();
}

class _ContentTestScreenState extends State<ContentTestScreen> {
  late final ContentInitializationService _contentService;
  bool _isLoading = false;
  String _statusMessage = 'Ready to load content';
  bool _isContentLoaded = false;

  @override
  void initState() {
    super.initState();
    _contentService = ContentInitializationService(getIt<AppDatabase>());
    _checkContentStatus();
  }

  Future<void> _checkContentStatus() async {
    final isLoaded = await _contentService.isContentLoaded();
    setState(() {
      _isContentLoaded = isLoaded;
      _statusMessage = isLoaded
          ? '✅ Content is already loaded'
          : 'ℹ️ No content loaded yet';
    });
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '🔄 Loading content...';
    });

    final success = await _contentService.loadSampleContent();

    setState(() {
      _isLoading = false;
      _isContentLoaded = success;
      _statusMessage = success
          ? '✅ Content loaded successfully!'
          : '❌ Failed to load content';
    });
  }

  Future<void> _clearContent() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '🗑️ Clearing content...';
    });

    await _contentService.clearAllContent();

    setState(() {
      _isLoading = false;
      _isContentLoaded = false;
      _statusMessage = '✅ Content cleared successfully';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Content Test Screen'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: _isContentLoaded ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Icon(
                      _isContentLoaded ? Icons.check_circle : Icons.info,
                      size: 48,
                      color: _isContentLoaded ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _statusMessage,
                      style: AppTypography.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _loadContent,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: Text(_isLoading ? 'Loading...' : 'Load Sample Content'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(AppSpacing.md),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            ElevatedButton.icon(
              onPressed: _isLoading || !_isContentLoaded ? null : _clearContent,
              icon: const Icon(Icons.delete),
              label: const Text('Clear All Content'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(AppSpacing.md),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Test Feature Buttons
            if (_isContentLoaded) ...[
              Text(
                'Test Features',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.md),
              
              OutlinedButton.icon(
                onPressed: () {
                  context.push('/chapter/1/study-materials?name=Nutrition in Plants');
                },
                icon: const Icon(Icons.school),
                label: const Text('Test Study Materials'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.md),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              OutlinedButton.icon(
                onPressed: () {
                  context.push('/chapter/1/practice?name=Nutrition in Plants');
                },
                icon: const Icon(Icons.fitness_center),
                label: const Text('Test Practice Mode'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.md),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              OutlinedButton.icon(
                onPressed: () {
                  context.push('/topic/1/flashcards?name=Photosynthesis');
                },
                icon: const Icon(Icons.style),
                label: const Text('Test Flashcards'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.md),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
