// lib/features/study_materials/presentation/screens/study_materials_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/features/study_materials/presentation/providers/study_resources_provider.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';

class StudyMaterialsScreen extends ConsumerStatefulWidget {
  final String chapterId;
  final String chapterName;

  const StudyMaterialsScreen({
    super.key,
    required this.chapterId,
    required this.chapterName,
  });

  @override
  ConsumerState<StudyMaterialsScreen> createState() =>
      _StudyMaterialsScreenState();
}

class _StudyMaterialsScreenState extends ConsumerState<StudyMaterialsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _resourceTypes = [
    'summary',
    'formula',
    'concept_map',
    'exam_tip',
  ];
  
  final Map<String, String> _tabLabels = {
    'summary': 'Summary',
    'formula': 'Formulas',
    'concept_map': 'Concept Map',
    'exam_tip': 'Exam Tips',
  };
  
  final Map<String, IconData> _tabIcons = {
    'summary': Icons.article_outlined,
    'formula': Icons.functions,
    'concept_map': Icons.account_tree_outlined,
    'exam_tip': Icons.lightbulb_outline,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _resourceTypes.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.chapterName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: _resourceTypes.map((type) {
            return Tab(
              icon: Icon(_tabIcons[type]),
              text: _tabLabels[type],
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _resourceTypes.map((type) {
          return _ResourceTypeTab(
            chapterId: widget.chapterId,
            resourceType: type,
            tabLabel: _tabLabels[type]!,
          );
        }).toList(),
      ),
    );
  }
}

class _ResourceTypeTab extends ConsumerWidget {
  final int chapterId;
  final String resourceType;
  final String tabLabel;

  const _ResourceTypeTab({
    required this.chapterId,
    required this.resourceType,
    required this.tabLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(
      resourcesByTypeProvider((
        chapterId: chapterId,
        resourceType: resourceType,
      )),
    );

    return resourcesAsync.when(
      data: (resources) {
        if (resources.isEmpty) {
          return _EmptyResourcesView(tabLabel: tabLabel);
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(resourcesByTypeProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              final resource = resources[index];
              return _ResourceCard(resource: resource);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => AppErrorWidget(
        message: error.toString(),
        onRetry: () {
          ref.invalidate(resourcesByTypeProvider);
        },
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final StudyResource resource;

  const _ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        childrenPadding: const EdgeInsets.all(AppSpacing.lg),
        title: Text(
          resource.title,
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Row(
            children: [
              Icon(
                _getIconForType(resource.resourceType),
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _getTypeLabel(resource.resourceType),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        children: [
          MarkdownBody(
            data: resource.content,
            styleSheet: MarkdownStyleSheet(
              h1: AppTypography.h1,
              h2: AppTypography.h2,
              h3: AppTypography.h3,
              p: AppTypography.bodyMedium,
              code: AppTypography.bodyMedium.copyWith(
                fontFamily: 'Courier',
                backgroundColor: AppColors.surface,
              ),
              codeblockDecoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              blockquotePadding: const EdgeInsets.all(AppSpacing.md),
              blockquoteDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                border: Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 4,
                  ),
                ),
              ),
              tableBody: AppTypography.bodyMedium,
              tableBorder: TableBorder.all(
                color: AppColors.border,
                width: 1,
              ),
              tableColumnWidth: const FlexColumnWidth(),
            ),
          ),
          if (resource.fileUrl != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement PDF download
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PDF download coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'summary':
        return Icons.article_outlined;
      case 'formula':
        return Icons.functions;
      case 'concept_map':
        return Icons.account_tree_outlined;
      case 'exam_tip':
        return Icons.lightbulb_outline;
      default:
        return Icons.description_outlined;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'summary':
        return 'Chapter Summary';
      case 'formula':
        return 'Formula Sheet';
      case 'concept_map':
        return 'Concept Map';
      case 'exam_tip':
        return 'Exam Tips';
      default:
        return type;
    }
  }
}

class _EmptyResourcesView extends StatelessWidget {
  final String tabLabel;

  const _EmptyResourcesView({required this.tabLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No $tabLabel Available',
              style: AppTypography.h3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Study materials for this section will be added soon.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
