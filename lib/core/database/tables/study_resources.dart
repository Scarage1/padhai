import 'package:drift/drift.dart';

@DataClassName('StudyResourceData')
class StudyResources extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Type of study resource: 'summary', 'formula', 'concept_map', 'exam_tip'
  TextColumn get resourceType => text()();
  
  /// Foreign key to chapters table
  IntColumn get chapterId => integer()();
  
  /// Title of the resource
  TextColumn get title => text()();
  
  /// Content in Markdown format
  TextColumn get content => text()();
  
  /// Optional file URL for downloadable PDFs
  TextColumn get fileUrl => text().nullable()();
  
  /// Timestamp when resource was created
  IntColumn get createdAt => integer()();
}
