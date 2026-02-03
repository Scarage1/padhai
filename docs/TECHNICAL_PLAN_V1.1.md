# v1.1.0 Technical Implementation Plan
**Principal Engineer Response to Product Engineering Head**

**Date:** February 3, 2026  
**Status:** APPROVED - Ready for Implementation  
**Target Release:** March 17, 2026 (6 weeks)

---

## Executive Summary

**Assessment:** Product requirements are technically feasible and align with our Clean Architecture foundation. The 91% content deficit can be addressed through a well-structured JSON-based content system. All proposed features integrate cleanly with existing codebase.

**Recommendation:** ✅ GO - Proceed with phased implementation starting immediately.

**Critical Path:** Content infrastructure (Week 1-2) → Feature development (Week 3-4) → Content population & testing (Week 5-6)

---

## Architecture Decisions

### 1. Content Delivery System

**Decision:** Hybrid JSON + Database Approach

**Rationale:**
- **JSON files** for bulk content (questions, resources) - enables hot updates without app store
- **SQLite database** for user data, progress, bookmarks - existing strength
- **Asset pipeline** for images/PDFs - Flutter's built-in optimization

**Implementation:**
```dart
// Content structure
assets/content/
├── questions/
│   ├── science_ch1.json  // 20 questions
│   ├── science_ch2.json
│   └── ... (10 files total)
├── resources/
│   ├── study_materials.json
│   └── flashcards.json
└── metadata/
    └── content_version.json  // For update checks
```

**Loading Strategy:**
- First launch: Load all JSON → populate database
- Subsequent launches: Check version, update if needed
- Lazy loading: Load chapter content on-demand

### 2. Database Schema Evolution

**Migration Strategy:** Drift migrations with version bump

**Changes:**
```dart
// Version 2 migration
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async { /* existing */ },
  onUpgrade: (Migrator m, int from, int to) async {
    if (from == 1) {
      // Add new tables
      await m.createTable(studyResources);
      await m.createTable(flashcards);
      
      // Alter existing tables
      await m.addColumn(questions, questions.questionType);
      await m.addColumn(questions, questions.ncertReference);
      await m.addColumn(questions, questions.hint);
    }
  },
);
```

**New Tables:**
1. `study_resources` - Summaries, formulas, concept maps
2. `flashcards` - Term/definition pairs with spaced repetition
3. `practice_attempts` - Separate tracking for practice mode

### 3. Feature Module Architecture

**Pattern:** Feature-first structure (existing pattern)

**New Modules:**
```
lib/features/
├── study_materials/
│   ├── data/ (resources_repository.dart)
│   ├── domain/ (resource.dart, resource_type.dart)
│   └── presentation/ (study_materials_screen.dart, resource_card.dart)
├── practice_mode/
│   ├── data/ (practice_repository.dart)
│   ├── domain/ (practice_session.dart)
│   └── presentation/ (practice_screen.dart, hint_widget.dart)
├── flashcards/
│   ├── data/ (flashcard_repository.dart)
│   ├── domain/ (flashcard.dart, spaced_repetition.dart)
│   └── presentation/ (flashcard_screen.dart, card_swipe.dart)
└── syllabus/
    ├── data/ (pdf_repository.dart)
    └── presentation/ (syllabus_viewer_screen.dart)
```

**Dependency Injection:**
- All repositories registered in `injection.dart`
- Riverpod providers for state management
- Follow existing patterns from quiz/topics features

### 4. Asset Management

**Image Strategy:**
- **SVG preferred** for diagrams (scalable, small size)
- **WebP** for photos (better compression than PNG)
- **Lazy loading** with cached_network_image pattern
- **Asset bundling** for initial release, remote URLs for future updates

**Organization:**
```
assets/
├── images/content/
│   ├── science/
│   │   └── ch{1-5}/*.svg
│   └── mathematics/
│       └── ch{1-5}/*.svg
├── documents/
│   └── syllabus/*.pdf
└── fonts/ (existing)
```

**Size Optimization:**
- SVG SVGO optimization
- WebP 80% quality
- PDF compression
- Target: <5MB total for all assets

---

## Sprint Breakdown (6 weeks = 3 sprints)

### Sprint 1: Foundation (Weeks 1-2)

**Goal:** Content infrastructure + database ready

#### Week 1: Database & Content System
**Tasks:**
1. ✅ Create database migration (version 1 → 2)
   - Add `study_resources` table
   - Add `flashcards` table  
   - Add `practice_attempts` table
   - Alter `questions` table (3 new columns)

2. ✅ JSON content system
   - Define JSON schemas (questions, resources, flashcards)
   - Create content loader utility
   - Implement version checking
   - Build validation scripts

3. ✅ Asset directory setup
   - Create all required directories
   - Add placeholder images
   - Set up pubspec.yaml asset declarations

**Deliverable:** Database v2 + content loading framework working

#### Week 2: Study Materials + Practice Mode
**Tasks:**
1. ✅ Study Materials feature
   - Data layer: Repository, DAO
   - Domain layer: Entities, use cases
   - Presentation: Resource library screen, PDF viewer
   - Integration with dashboard

2. ✅ Practice Mode feature
   - Extend quiz repository for practice mode
   - Implement hint system
   - Create untimed quiz UI variant
   - Progress tracking (separate from quiz)

3. ✅ Asset pipeline
   - Image loading utilities
   - PDF viewer integration (syncfusion_flutter_pdfviewer)
   - Error handling for missing assets

**Deliverable:** Two new features functional, ready for content

---

### Sprint 2: Features & UI (Weeks 3-4)

**Goal:** All v1.1 features implemented

#### Week 3: Flashcards + Revision Planner
**Tasks:**
1. ✅ Flashcards feature
   - Data layer: Flashcard DAO, repository
   - Domain: Spaced repetition algorithm (SM-2)
   - Presentation: Swipeable card UI
   - Mastery level tracking

2. ✅ Revision Planner feature
   - Algorithm: Topic priority based on performance
   - Calendar integration
   - Daily goals and notifications
   - Dashboard widget

3. ✅ Syllabus Viewer
   - PDF display with zoom
   - Progress indicator (topics covered)
   - Deep linking from topics to syllabus sections

**Deliverable:** Flashcards, planner, syllabus viewer working

#### Week 4: UX Enhancements
**Tasks:**
1. ✅ Chapter unlocking logic
   - Update chapter repository with unlock checks
   - UI: Lock indicators, criteria tooltips
   - Achievement: "Chapter Unlocked" notification

2. ✅ Achievement system
   - Badge definitions (10 types)
   - Achievement tracker
   - Badge display in profile
   - Share functionality (screenshot)

3. ✅ Improved onboarding
   - Difficulty calibration quiz (5 questions)
   - Feature tour with tooltips
   - Sample quiz preview for non-users

4. ✅ Dark mode
   - Theme provider setup
   - All screens dark theme support
   - Diagram contrast adjustments

**Deliverable:** Complete UX polish, all features ready for content

---

### Sprint 3: Content & QA (Weeks 5-6)

**Goal:** Production-ready v1.1.0

#### Week 5: Content Population & Integration
**Tasks:**
1. ✅ Content creation coordination
   - 366+ questions in JSON format
   - 50+ diagrams (SVG/WebP)
   - Study resources (summaries, formulas)
   - Flashcard sets (100+ cards)
   - Syllabus PDFs (2 files)

2. ✅ Content validation
   - Run automated validation scripts
   - Answer key verification
   - NCERT alignment check
   - Image reference validation

3. ✅ Content integration
   - Load all JSON files
   - Verify database population
   - Test image loading
   - PDF availability check

**Deliverable:** Full content loaded, validated, accessible

#### Week 6: Testing & Release
**Tasks:**
1. ✅ Automated testing
   - Unit tests for new features (80% coverage)
   - Integration tests for quiz/practice flows
   - Widget tests for new screens

2. ✅ Manual testing
   - 7 critical user flows
   - Student beta testing (5-10 students)
   - Teacher content review (2 educators)
   - Performance benchmarking

3. ✅ Bug fixes & polish
   - Address all critical bugs
   - Performance optimization
   - Crash monitoring setup
   - Analytics event tracking

4. ✅ Release preparation
   - Version bump to 1.1.0+2
   - Release notes
   - App store assets (screenshots, description)
   - Staged rollout plan

**Deliverable:** v1.1.0 released to production

---

## Technical Specifications

### Database Schema Changes

```dart
// lib/core/database/tables/study_resources.dart
@DataClassName('StudyResourceData')
class StudyResources extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get resourceType => text()(); // 'summary', 'formula', 'concept_map', 'exam_tip'
  IntColumn get chapterId => integer()();
  TextColumn get title => text()();
  TextColumn get content => text()(); // Markdown
  TextColumn get fileUrl => text().nullable()(); // PDF URL
  IntColumn get createdAt => integer()();
}

// lib/core/database/tables/flashcards.dart
@DataClassName('FlashcardData')
class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get topicId => integer()();
  TextColumn get term => text()();
  TextColumn get definition => text()();
  IntColumn get masteryLevel => integer().withDefault(const Constant(0))(); // 0-5
  IntColumn get nextReviewDate => integer().nullable()();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
}

// lib/core/database/tables/practice_attempts.dart
@DataClassName('PracticeAttemptData')
class PracticeAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get topicId => integer()();
  IntColumn get questionId => integer()();
  TextColumn get userAnswer => text()();
  BoolColumn get isCorrect => boolean()();
  BoolColumn get hintUsed => boolean().withDefault(const Constant(false))();
  IntColumn get attemptedAt => integer()();
}

// Extend questions table (migration)
class QuestionsV2 extends Questions {
  TextColumn get questionType => text().withDefault(const Constant('mcq'))();
  TextColumn get ncertReference => text().nullable()();
  TextColumn get hint => text().nullable()();
}
```

### JSON Content Schema

```json
// assets/content/questions/science_ch1.json
{
  "chapter_id": 1,
  "chapter_name": "Crop Production and Management",
  "version": "1.0.0",
  "questions": [
    {
      "id": 1001,
      "topic_id": 1,
      "question_text": "What is the term for the process of loosening and turning of soil?",
      "question_type": "mcq",
      "options": ["Tilling", "Irrigation", "Manuring", "Harvesting"],
      "correct_answer": "Tilling",
      "explanation": "Tilling or ploughing is the process of loosening and turning the soil. This allows roots to penetrate deep into the soil and helps in mixing nutrients uniformly.",
      "difficulty": "beginner",
      "image_url": null,
      "ncert_reference": "Class 8 Science Ch1 Section 1.2",
      "hint": "Think about preparing the soil before sowing seeds."
    }
  ]
}

// assets/content/resources/study_materials.json
{
  "version": "1.0.0",
  "resources": [
    {
      "id": 1,
      "type": "summary",
      "chapter_id": 1,
      "subject": "science",
      "title": "Crop Production - Chapter Summary",
      "content": "# Chapter Summary\n\n## Key Points...",
      "file_url": "assets/documents/summaries/science_ch1_summary.pdf"
    }
  ]
}
```

### Content Loading System

```dart
// lib/core/content/content_loader.dart
class ContentLoader {
  final AppDatabase _database;
  
  Future<void> loadQuestionsFromJson(String filePath) async {
    final jsonString = await rootBundle.loadString(filePath);
    final data = json.decode(jsonString);
    
    // Validate schema
    _validateQuestionSchema(data);
    
    // Parse and insert
    for (var q in data['questions']) {
      await _database.questionsDao.insertQuestion(
        QuestionCompanion(
          topicId: Value(q['topic_id']),
          questionText: Value(q['question_text']),
          questionType: Value(q['question_type']),
          options: Value(json.encode(q['options'])),
          correctAnswer: Value(q['correct_answer']),
          explanation: Value(q['explanation']),
          difficulty: Value(q['difficulty']),
          imageUrl: Value(q['image_url']),
          ncertReference: Value(q['ncert_reference']),
          hint: Value(q['hint']),
        ),
      );
    }
  }
  
  void _validateQuestionSchema(Map<String, dynamic> data) {
    // Validation logic
    assert(data.containsKey('questions'));
    assert(data['questions'] is List);
    // ... more checks
  }
}
```

### Spaced Repetition Algorithm

```dart
// lib/features/flashcards/domain/spaced_repetition.dart
class SuperMemo2Algorithm {
  // SM-2 algorithm implementation
  static DateTime calculateNextReview({
    required int currentMasteryLevel,
    required bool wasCorrect,
    required DateTime lastReview,
  }) {
    int newLevel = wasCorrect 
      ? min(currentMasteryLevel + 1, 5)
      : max(currentMasteryLevel - 1, 0);
    
    // Intervals: 1d, 3d, 7d, 14d, 30d, 60d
    final intervals = [1, 3, 7, 14, 30, 60];
    final daysUntilNext = intervals[newLevel];
    
    return lastReview.add(Duration(days: daysUntilNext));
  }
}
```

---

## Dependencies

### New Packages Required

```yaml
dependencies:
  # PDF Viewer
  syncfusion_flutter_pdfviewer: ^24.2.9
  
  # Image optimization
  cached_network_image: ^3.3.1
  flutter_svg: ^2.0.10+1
  
  # Swipeable cards
  flutter_card_swiper: ^7.0.1
  
  # Calendar
  table_calendar: ^3.1.1
  
  # Notifications
  flutter_local_notifications: ^17.0.0

dev_dependencies:
  # Content validation
  json_schema: ^5.1.4
```

---

## Testing Strategy

### Unit Tests (Target: 80% coverage)

**New test files:**
- `test/features/study_materials/study_materials_repository_test.dart`
- `test/features/practice_mode/practice_repository_test.dart`
- `test/features/flashcards/spaced_repetition_test.dart`
- `test/core/content/content_loader_test.dart`

**Critical test cases:**
- Content validation (malformed JSON)
- Spaced repetition algorithm correctness
- Chapter unlock logic (edge cases)
- Practice mode hint system
- Database migration (v1 → v2)

### Integration Tests

**Flows to test:**
1. Complete practice mode session (load → answer → hint → complete)
2. Study material access (load → view PDF → bookmark)
3. Flashcard review (load → swipe → mark mastery → schedule next)
4. Chapter unlock (complete topics → take test → unlock next)

### Manual Testing Checklist

**User Flows:**
1. ✅ New user onboarding (calibration quiz)
2. ✅ Topic reading → Quiz → Practice mode
3. ✅ Study materials browsing → PDF download
4. ✅ Flashcard session (10 cards)
5. ✅ Chapter completion → unlock next
6. ✅ Revision planner setup → daily goals
7. ✅ Dark mode toggle (all screens)

**Student Beta Testing:**
- Recruit 5-10 CBSE Class 8 students
- 1-week testing period
- Focus: Content accuracy, feature usability
- Feedback: Survey + interviews

---

## Risk Mitigation

### Risk 1: Content Creation Delay
**Impact:** High - Blocks release  
**Mitigation:**
- Start content creation in parallel with Week 1-2 development
- Use placeholders to test features
- Prioritize Science Ch1-3 (most critical)
- Have backup: Release v1.1 with partial content (200 questions) if needed

### Risk 2: Performance Degradation
**Impact:** Medium - User experience  
**Mitigation:**
- Benchmark before/after content load
- Implement pagination for question lists
- Lazy load images
- Profile database queries (add indexes if needed)

### Risk 3: Asset Size Bloat
**Impact:** Medium - Download size, storage  
**Mitigation:**
- SVG for all diagrams (text-based, small)
- WebP compression for photos
- PDF compression (reduce quality to 150dpi)
- Monitor APK size: Fail build if >100MB

### Risk 4: Migration Failure
**Impact:** High - Data loss  
**Mitigation:**
- Test migration on multiple database states
- Implement rollback mechanism
- Backup user data before migration
- Staged rollout (10% → 50% → 100%)

### Risk 5: CBSE Curriculum Misalignment
**Impact:** Critical - Educational integrity  
**Mitigation:**
- Mandatory teacher review before release
- NCERT textbook cross-reference for all content
- Tag every question with source
- Content update mechanism for corrections

---

## Success Metrics

### Development Metrics
- ✅ All 8 sprint tasks completed on time
- ✅ 0 critical bugs in production
- ✅ 80%+ unit test coverage
- ✅ <100MB APK size
- ✅ <3s app startup time with full content

### Content Metrics
- ✅ 400+ questions loaded
- ✅ 50+ diagrams available
- ✅ 100% NCERT alignment verified
- ✅ 0% placeholder content

### User Metrics (Post-release, 2 weeks)
- 70%+ users access Study Materials
- 50%+ users try Practice Mode
- 40%+ users use Flashcards
- 4.5+ App Store rating
- 99.5%+ crash-free sessions

---

## Post-v1.1 Roadmap

### v1.2 (Minor Update, +4 weeks)
- More subjects: Add English, Hindi, Social Science
- Multiplayer: Friend challenges, school leaderboards
- Teacher dashboard: Progress monitoring for teachers
- Voice notes: Audio explanations for visually impaired

### v2.0 (Major Update, +12 weeks)
- AI tutor: Personalized learning paths
- Video lessons: Short explainer videos per topic
- Live doubt solving: Connect with tutors
- Gamification: XP system, avatar customization

---

## Approval & Sign-off

**Principal Engineer:** ✅ APPROVED  
**Product Engineering Head:** _Pending_

**Notes:**
- All architecture decisions align with Clean Architecture principles
- Content infrastructure is scalable for future updates
- Feature implementations follow existing patterns
- Risk mitigation strategies are comprehensive
- Timeline is aggressive but achievable with focused effort

**Next Steps:**
1. Product Head approval
2. Coordinate with content team (start immediately)
3. Begin Sprint 1 Week 1 development
4. Daily standups to track progress

---

**Document Version:** 1.0  
**Last Updated:** February 3, 2026  
**Author:** Principal Engineer
