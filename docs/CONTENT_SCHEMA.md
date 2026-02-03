# JSON Content Schema Documentation

## Overview

This document defines the JSON schema for all content types in the Padhai app. Content teams can create/update content without code changes.

## Version Control

All content files should include version metadata:

```json
{
  "version": "1.1.0",
  "updated_at": "2025-06-01"
}
```

---

## 1. Questions Schema

**File Location:** `assets/content/questions/{subject}_ch{number}.json`

**Example:** `assets/content/questions/science_ch1.json`

### Schema Structure

```json
{
  "chapter_id": 1,
  "questions": [
    {
      "id": "sci_ch1_q1",
      "topic_id": 1,
      "question_text": "What is photosynthesis?",
      "options": [
        "Option A",
        "Option B", 
        "Option C",
        "Option D"
      ],
      "correct_answer": "Option A",
      "explanation": "Detailed explanation (minimum 20 characters)",
      "difficulty": "beginner",
      "ncert_reference": "Ch1.2.3",
      "hint": "Optional hint for practice mode",
      "image_url": "content/science/ch1/diagram.png",
      "question_type": "mcq"
    }
  ]
}
```

### Field Specifications

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `id` | String | ✅ | Unique, format: `{subject}_ch{n}_q{n}` | Unique question identifier |
| `topic_id` | Integer | ✅ | Must exist in Topics table | Foreign key to topics |
| `question_text` | String | ✅ | Non-empty | The question content |
| `options` | Array<String> | ✅ | Min 2 items | Answer choices |
| `correct_answer` | String | ✅ | Must be in options | Correct answer text |
| `explanation` | String | ✅ | Min 20 chars | Why answer is correct |
| `difficulty` | String | ❌ | One of: `beginner`, `intermediate`, `advanced` | Default: `intermediate` |
| `ncert_reference` | String | ❌ | Format: `Ch{n}.{section}.{subsection}` | NCERT curriculum mapping |
| `hint` | String | ❌ | - | Hint for practice mode |
| `image_url` | String | ❌ | Valid path in assets | Associated diagram/image |
| `question_type` | String | ❌ | One of: `mcq`, `true_false` | Default: `mcq` |

### Question Type Rules

**MCQ (Multiple Choice):**
- Minimum 2 options, typically 4
- One correct answer

**True/False:**
- Exactly 2 options: `["True", "False"]`
- Set `question_type: "true_false"`

### Validation Rules

1. ✅ `correct_answer` MUST exist in `options` array
2. ✅ Explanation must be minimum 20 characters
3. ✅ True/False questions must have exactly 2 options
4. ✅ Question ID must be unique across all chapters
5. ✅ All required fields must be present

### Example: Science Question

```json
{
  "id": "sci_ch1_q5",
  "topic_id": 1,
  "question_text": "In which part of the plant cell does photosynthesis occur?",
  "options": [
    "Nucleus",
    "Mitochondria",
    "Chloroplast",
    "Cell wall"
  ],
  "correct_answer": "Chloroplast",
  "explanation": "Photosynthesis occurs in chloroplasts, which are specialized organelles found in plant cells. Chloroplasts contain chlorophyll and other pigments that capture light energy. They have a double membrane structure with internal thylakoid membranes where the light-dependent reactions occur, and a stroma where the light-independent reactions (Calvin cycle) take place.",
  "difficulty": "intermediate",
  "ncert_reference": "Ch1.1.1",
  "hint": "Look for the organelle that contains chlorophyll",
  "image_url": "content/science/ch1/chloroplast_diagram.png",
  "question_type": "mcq"
}
```

### Example: True/False Question

```json
{
  "id": "sci_ch1_q2",
  "topic_id": 1,
  "question_text": "Photosynthesis produces oxygen as a byproduct. True or False?",
  "options": ["True", "False"],
  "correct_answer": "True",
  "explanation": "During photosynthesis, plants split water molecules (H₂O) to obtain electrons and hydrogen ions needed for the light-dependent reactions. This process releases oxygen (O₂) as a waste product into the atmosphere. This oxygen is essential for the survival of most life forms on Earth, including humans.",
  "difficulty": "beginner",
  "ncert_reference": "Ch1.1.3",
  "hint": "Consider what plants release during the day",
  "question_type": "true_false"
}
```

---

## 2. Study Resources Schema

**File Location:** `assets/content/resources/{subject}_ch{number}.json`

**Example:** `assets/content/resources/science_ch1.json`

### Schema Structure

```json
{
  "resources": [
    {
      "type": "summary",
      "chapter_id": 1,
      "title": "Chapter 1 Summary",
      "content": "# Markdown Content\n\n- Point 1\n- Point 2",
      "file_url": "documents/summaries/science_ch1.pdf"
    }
  ]
}
```

### Field Specifications

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `type` | String | ✅ | One of: `summary`, `formula`, `concept_map`, `exam_tip` | Resource category |
| `chapter_id` | Integer | ✅ | Must exist in Chapters table | Foreign key to chapters |
| `title` | String | ✅ | Non-empty | Resource title |
| `content` | String | ✅ | Markdown format | Main content (supports Markdown) |
| `file_url` | String | ❌ | Valid path or null | Optional PDF download |

### Resource Types

**1. Summary (`summary`)**
- Chapter overview
- Key concepts
- Important definitions

**2. Formula Sheet (`formula`)**
- Mathematical formulas
- Scientific equations
- Constants and units

**3. Concept Map (`concept_map`)**
- Relationship diagrams
- Hierarchical structures
- Mind maps

**4. Exam Tips (`exam_tip`)**
- Common mistakes
- Scoring strategies
- Quick revision points

### Example: Chapter Summary

```json
{
  "type": "summary",
  "chapter_id": 1,
  "title": "Photosynthesis - Chapter Summary",
  "content": "# Photosynthesis Overview\n\n## Key Concepts\n\n**Photosynthesis** is the process by which green plants manufacture food using:\n- Carbon dioxide (CO₂) from air\n- Water (H₂O) from soil\n- Light energy from the sun\n\n## Chemical Equation\n\n```\n6CO₂ + 6H₂O + Light Energy → C₆H₁₂O₆ + 6O₂\n```\n\n## Importance\n\n- Primary producers in food chains\n- Oxygen production for aerobic life\n- Removes CO₂ from atmosphere",
  "file_url": null
}
```

### Example: Formula Sheet

```json
{
  "type": "formula",
  "chapter_id": 1,
  "title": "Photosynthesis Formulas",
  "content": "# Important Formulas\n\n## Overall Equation\n\n**Chemical:**\n```\n6CO₂ + 6H₂O + Light energy → C₆H₁₂O₆ + 6O₂\n```\n\n## Rate Factors\n\n- Light intensity\n- CO₂ concentration\n- Temperature\n- Water availability",
  "file_url": "documents/formulas/science_ch1_formulas.pdf"
}
```

---

## 3. Flashcards Schema

**File Location:** `assets/content/flashcards/{subject}_ch{number}.json`

**Example:** `assets/content/flashcards/science_ch1.json`

### Schema Structure

```json
{
  "flashcards": [
    {
      "topic_id": 1,
      "term": "Photosynthesis",
      "definition": "The process by which green plants use sunlight to synthesize foods from CO₂ and H₂O"
    }
  ]
}
```

### Field Specifications

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `topic_id` | Integer | ✅ | Must exist in Topics table | Foreign key to topics |
| `term` | String | ✅ | Non-empty, concise | Term to learn |
| `definition` | String | ✅ | Clear, complete sentence | What the term means |

### Flashcard Guidelines

**Term:**
- Keep concise (1-5 words)
- Use proper capitalization
- Scientific/technical vocabulary

**Definition:**
- Complete sentences
- Clear and precise
- Include context when needed
- 20-150 words ideal

### Example: Science Flashcard

```json
{
  "topic_id": 1,
  "term": "Chloroplast",
  "definition": "An organelle found in plant cells where photosynthesis takes place. Contains chlorophyll and has two main regions: thylakoids (where light reactions occur) and stroma (where Calvin cycle occurs)."
}
```

### Example: Mathematics Flashcard

```json
{
  "topic_id": 10,
  "term": "Rational Number",
  "definition": "A number that can be expressed as a fraction p/q where p and q are integers and q ≠ 0. Examples: 1/2, -3/4, 5 (which is 5/1). All integers and terminating/repeating decimals are rational numbers."
}
```

---

## 4. Content Metadata Schema

**File Location:** `assets/content/metadata/version.json`

### Schema Structure

```json
{
  "version": "1.1.0",
  "last_updated": "2025-06-01",
  "total_questions": 400,
  "total_resources": 100,
  "total_flashcards": 200,
  "changelog": [
    {
      "version": "1.1.0",
      "date": "2025-06-01",
      "changes": [
        "Added 366 new questions",
        "Added study materials"
      ]
    }
  ]
}
```

### Field Specifications

| Field | Type | Description |
|-------|------|-------------|
| `version` | String | Semantic version (e.g., "1.1.0") |
| `last_updated` | String | ISO date (YYYY-MM-DD) |
| `total_questions` | Integer | Total question count |
| `total_resources` | Integer | Total study resources |
| `total_flashcards` | Integer | Total flashcard count |
| `changelog` | Array | Version history |

---

## Naming Conventions

### File Names

```
{subject}_ch{chapter_number}.json
```

**Examples:**
- `science_ch1.json` - Science Chapter 1
- `mathematics_ch5.json` - Mathematics Chapter 5

### Question IDs

```
{subject}_ch{chapter}_q{question_number}
```

**Examples:**
- `sci_ch1_q1` - Science Chapter 1, Question 1
- `math_ch3_q25` - Mathematics Chapter 3, Question 25

### Image Paths

```
content/{subject}/ch{number}/{filename}.{ext}
```

**Examples:**
- `content/science/ch1/photosynthesis.png`
- `content/mathematics/ch2/number_line.svg`

---

## Content Quality Guidelines

### Questions

1. **Clear and Unambiguous:** Question text should have one interpretation
2. **Age-Appropriate:** Use Class 8 vocabulary level
3. **Accurate:** Verify facts with NCERT textbooks
4. **Educational:** Focus on conceptual understanding
5. **Diverse Difficulty:** Mix beginner (40%), intermediate (40%), advanced (20%)

### Explanations

1. **Comprehensive:** Explain why answer is correct AND why others are wrong
2. **Pedagogical:** Teach the concept, don't just state facts
3. **Referenced:** Link to NCERT chapters when applicable
4. **Example-Rich:** Use real-world examples when possible

### Study Resources

1. **Structured:** Use Markdown headings for organization
2. **Concise:** Focus on key points, avoid verbosity
3. **Visual:** Include tables, lists, equations
4. **Exam-Focused:** Highlight frequently tested concepts

### Flashcards

1. **Atomic:** One concept per card
2. **Bidirectional:** Definition should clearly map to term
3. **Complete:** Don't assume prior knowledge
4. **Memorable:** Use examples or mnemonics when helpful

---

## Content Loading Process

### Automated Loading

The `ContentLoader` class automatically loads content from JSON files:

```dart
final loader = getIt<ContentLoader>();

// Load all content
final summary = await loader.loadAllContent();

// Check version
final needsUpdate = await loader.needsContentUpdate(currentVersion);
```

### Manual Validation

Before committing new content, validate using:

```bash
dart scripts/validate_content.dart
```

This checks:
- JSON syntax
- Required fields
- Field types
- Value constraints
- Logical consistency

---

## Hot Updates (Over-the-Air)

### Version Checking

```dart
// Check if new content available
final currentVersion = await prefs.getString('content_version') ?? '1.0.0';
final needsUpdate = await contentLoader.needsContentUpdate(currentVersion);

if (needsUpdate) {
  // Download new content from server
  await downloadContentUpdate();
  
  // Load into database
  await contentLoader.loadAllContent();
  
  // Update stored version
  await prefs.setString('content_version', newVersion);
}
```

### Content Delivery Network (CDN)

Future enhancement: Host JSON files on CDN for hot updates without app store submission.

---

## Error Handling

### Common Validation Errors

1. **Missing Required Field**
   ```
   Question 5: Missing required field "explanation"
   ```
   **Fix:** Add the missing field

2. **Invalid Answer**
   ```
   Question 3: correct_answer "Option E" not in options
   ```
   **Fix:** Ensure correct_answer matches one option exactly

3. **Short Explanation**
   ```
   Question 7: Explanation too short (min 20 characters)
   ```
   **Fix:** Write detailed explanation

4. **Invalid Difficulty**
   ```
   Question 2: Invalid difficulty "easy"
   ```
   **Fix:** Use: `beginner`, `intermediate`, or `advanced`

5. **True/False Format Error**
   ```
   Question 10: True/False questions must have exactly 2 options
   ```
   **Fix:** Use only `["True", "False"]` for true_false type

---

## Sample Content Files

Full sample files are available in:

- `assets/content/questions/science_ch1_sample.json`
- `assets/content/resources/science_ch1_sample.json`
- `assets/content/flashcards/science_ch1_sample.json`

Use these as templates for creating new content.

---

## Content Creation Workflow

1. **Create JSON file** using schema template
2. **Add content** (questions/resources/flashcards)
3. **Validate** using `dart scripts/validate_content.dart`
4. **Test locally** by running app
5. **Commit to git** with descriptive message
6. **Deploy** (push to main branch)

---

## Support

For questions about content schemas, contact:
- **Technical:** Principal Engineer
- **Content:** Subject Matter Experts
- **Validation:** QA Team
