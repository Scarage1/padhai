// lib/core/database/content_seeder.dart
// Content seeder per DOC-011 Content Specification

import 'package:padhai/core/database/app_database.dart';

/// Seeds topics and questions per DOC-011 Content Specification
class ContentSeeder {
  final AppDatabase _database;

  ContentSeeder(this._database);

  /// Seed all content
  Future<void> seedAll() async {
    await _seedScienceTopics();
    await _seedMathsTopics();
    await _seedScienceQuestions();
    await _seedMathsQuestions();
  }

  /// Seed Science topics for chapters 1-5
  Future<void> _seedScienceTopics() async {
    // Chapter 1: Crop Production and Management
    await _insertTopic('TOP_SCI_001_001', 'CHT_SUB001_001', 'Agricultural Practices',
        _agriculturePracticesContent, 1, 8);
    await _insertTopic('TOP_SCI_001_002', 'CHT_SUB001_001', 'Preparation of Soil',
        _soilPreparationContent, 2, 6);
    await _insertTopic('TOP_SCI_001_003', 'CHT_SUB001_001', 'Sowing and Adding Manure',
        _sowingContent, 3, 10);
    await _insertTopic('TOP_SCI_001_004', 'CHT_SUB001_001', 'Irrigation and Harvesting',
        _irrigationContent, 4, 8);

    // Chapter 2: Microorganisms: Friend and Foe
    await _insertTopic('TOP_SCI_002_001', 'CHT_SUB001_002', 'Introduction to Microorganisms',
        _microorganismsIntroContent, 1, 8);
    await _insertTopic('TOP_SCI_002_002', 'CHT_SUB001_002', 'Useful Microorganisms',
        _usefulMicroContent, 2, 10);
    await _insertTopic('TOP_SCI_002_003', 'CHT_SUB001_002', 'Harmful Microorganisms',
        _harmfulMicroContent, 3, 8);
    await _insertTopic('TOP_SCI_002_004', 'CHT_SUB001_002', 'Food Preservation',
        _foodPreservationContent, 4, 6);

    // Chapter 3: Synthetic Fibres and Plastics
    await _insertTopic('TOP_SCI_003_001', 'CHT_SUB001_003', 'Types of Fibres',
        _fibresTypesContent, 1, 8);
    await _insertTopic('TOP_SCI_003_002', 'CHT_SUB001_003', 'Synthetic Fibres',
        _syntheticFibresContent, 2, 10);
    await _insertTopic('TOP_SCI_003_003', 'CHT_SUB001_003', 'Plastics',
        _plasticsContent, 3, 8);
    await _insertTopic('TOP_SCI_003_004', 'CHT_SUB001_003', 'Environmental Impact',
        _environmentImpactContent, 4, 6);

    // Chapter 4: Materials: Metals and Non-Metals
    await _insertTopic('TOP_SCI_004_001', 'CHT_SUB001_004', 'Physical Properties',
        _metalPhysicalContent, 1, 8);
    await _insertTopic('TOP_SCI_004_002', 'CHT_SUB001_004', 'Chemical Properties',
        _metalChemicalContent, 2, 10);
    await _insertTopic('TOP_SCI_004_003', 'CHT_SUB001_004', 'Reactivity Series',
        _reactivitySeriesContent, 3, 8);
    await _insertTopic('TOP_SCI_004_004', 'CHT_SUB001_004', 'Uses of Metals and Non-Metals',
        _metalUsesContent, 4, 6);

    // Chapter 5: Coal and Petroleum
    await _insertTopic('TOP_SCI_005_001', 'CHT_SUB001_005', 'Natural Resources',
        _naturalResourcesContent, 1, 8);
    await _insertTopic('TOP_SCI_005_002', 'CHT_SUB001_005', 'Coal Formation and Uses',
        _coalContent, 2, 8);
    await _insertTopic('TOP_SCI_005_003', 'CHT_SUB001_005', 'Petroleum and Natural Gas',
        _petroleumContent, 3, 10);
    await _insertTopic('TOP_SCI_005_004', 'CHT_SUB001_005', 'Conservation of Resources',
        _conservationContent, 4, 6);
  }

  /// Seed Maths topics for chapters 1-5
  Future<void> _seedMathsTopics() async {
    // Chapter 1: Rational Numbers
    await _insertTopic('TOP_MAT_001_001', 'CHT_SUB002_001', 'Introduction to Rational Numbers',
        _rationalIntroContent, 1, 8);
    await _insertTopic('TOP_MAT_001_002', 'CHT_SUB002_001', 'Properties of Rational Numbers',
        _rationalPropertiesContent, 2, 10);
    await _insertTopic('TOP_MAT_001_003', 'CHT_SUB002_001', 'Operations on Rational Numbers',
        _rationalOperationsContent, 3, 12);
    await _insertTopic('TOP_MAT_001_004', 'CHT_SUB002_001', 'Representing on Number Line',
        _rationalNumberLineContent, 4, 8);

    // Chapter 2: Linear Equations in One Variable
    await _insertTopic('TOP_MAT_002_001', 'CHT_SUB002_002', 'Introduction to Equations',
        _equationsIntroContent, 1, 8);
    await _insertTopic('TOP_MAT_002_002', 'CHT_SUB002_002', 'Solving Linear Equations',
        _solvingEquationsContent, 2, 12);
    await _insertTopic('TOP_MAT_002_003', 'CHT_SUB002_002', 'Word Problems',
        _wordProblemsContent, 3, 10);
    await _insertTopic('TOP_MAT_002_004', 'CHT_SUB002_002', 'Equations with Variables on Both Sides',
        _variablesBothSidesContent, 4, 10);

    // Chapter 3: Understanding Quadrilaterals
    await _insertTopic('TOP_MAT_003_001', 'CHT_SUB002_003', 'Introduction to Polygons',
        _polygonsIntroContent, 1, 8);
    await _insertTopic('TOP_MAT_003_002', 'CHT_SUB002_003', 'Types of Quadrilaterals',
        _quadrilateralTypesContent, 2, 10);
    await _insertTopic('TOP_MAT_003_003', 'CHT_SUB002_003', 'Properties of Parallelograms',
        _parallelogramPropertiesContent, 3, 10);
    await _insertTopic('TOP_MAT_003_004', 'CHT_SUB002_003', 'Angle Sum Property',
        _angleSumContent, 4, 8);

    // Chapter 4: Practical Geometry
    await _insertTopic('TOP_MAT_004_001', 'CHT_SUB002_004', 'Constructing Quadrilaterals',
        _constructingQuadContent, 1, 10);
    await _insertTopic('TOP_MAT_004_002', 'CHT_SUB002_004', 'SSS Construction',
        _sssConstructionContent, 2, 8);
    await _insertTopic('TOP_MAT_004_003', 'CHT_SUB002_004', 'SAS Construction',
        _sasConstructionContent, 3, 8);
    await _insertTopic('TOP_MAT_004_004', 'CHT_SUB002_004', 'Special Cases',
        _specialCasesContent, 4, 8);

    // Chapter 5: Data Handling
    await _insertTopic('TOP_MAT_005_001', 'CHT_SUB002_005', 'Introduction to Data',
        _dataIntroContent, 1, 8);
    await _insertTopic('TOP_MAT_005_002', 'CHT_SUB002_005', 'Organizing Data',
        _organizingDataContent, 2, 8);
    await _insertTopic('TOP_MAT_005_003', 'CHT_SUB002_005', 'Pie Charts',
        _pieChartsContent, 3, 10);
    await _insertTopic('TOP_MAT_005_004', 'CHT_SUB002_005', 'Probability',
        _probabilityContent, 4, 10);
  }

  Future<void> _insertTopic(
    String id,
    String chapterId,
    String title,
    String content,
    int topicNumber,
    int estimatedMinutes,
  ) async {
    await _database.into(_database.topics).insert(
      TopicsCompanion.insert(
        id: id,
        chapterId: chapterId,
        title: title,
        content: content,
        topicNumber: topicNumber,
        estimatedMinutes: estimatedMinutes,
      ),
    );
  }

  /// Seed Science questions (sample - 3 per topic)
  Future<void> _seedScienceQuestions() async {
    // Chapter 1, Topic 1: Agricultural Practices
    await _insertQuestion(
      'Q_SCI_001_001_01', 'TOP_SCI_001_001', 'CHT_SUB001_001',
      'Which of the following is a Kharif crop?',
      '["Wheat", "Paddy", "Gram", "Mustard"]', 'Paddy',
      'Paddy is a Kharif crop sown during the monsoon season (June-July) and harvested in September-October.',
      'beginner',
    );
    await _insertQuestion(
      'Q_SCI_001_001_02', 'TOP_SCI_001_001', 'CHT_SUB001_001',
      'The practice of growing two or more crops simultaneously in the same field is called:',
      '["Crop rotation", "Mixed cropping", "Intercropping", "Multiple cropping"]', 'Mixed cropping',
      'Mixed cropping is the practice of growing two or more crops together in the same field.',
      'intermediate',
    );
    await _insertQuestion(
      'Q_SCI_001_001_03', 'TOP_SCI_001_001', 'CHT_SUB001_001',
      'In which type of cropping system, crops are grown in definite row patterns?',
      '["Mixed cropping", "Intercropping", "Crop rotation", "Relay cropping"]', 'Intercropping',
      'In intercropping, two or more crops are grown simultaneously in definite row patterns.',
      'advanced',
    );

    // Chapter 1, Topic 2: Preparation of Soil
    await _insertQuestion(
      'Q_SCI_001_002_01', 'TOP_SCI_001_002', 'CHT_SUB001_001',
      'The process of loosening and turning the soil is called:',
      '["Sowing", "Ploughing", "Harvesting", "Irrigation"]', 'Ploughing',
      'Ploughing is the first step in cultivation that loosens soil and allows roots to penetrate deeply.',
      'beginner',
    );
    await _insertQuestion(
      'Q_SCI_001_002_02', 'TOP_SCI_001_002', 'CHT_SUB001_001',
      'Which implement is used to remove weeds and loosen soil?',
      '["Plough", "Hoe", "Seed drill", "Sickle"]', 'Hoe',
      'Hoe is a simple tool used for removing weeds and loosening the soil.',
      'intermediate',
    );
    await _insertQuestion(
      'Q_SCI_001_002_03', 'TOP_SCI_001_002', 'CHT_SUB001_001',
      'Crumbs are broken down using which agricultural implement?',
      '["Cultivator", "Plough", "Leveller", "Hoe"]', 'Leveller',
      'Leveller is used to break down crumbs after ploughing and make the field smooth for sowing.',
      'advanced',
    );

    // Add more questions for other topics...
    // Chapter 2: Microorganisms
    await _insertQuestion(
      'Q_SCI_002_001_01', 'TOP_SCI_002_001', 'CHT_SUB001_002',
      'Which of the following is NOT a type of microorganism?',
      '["Bacteria", "Virus", "Fungus", "Fern"]', 'Fern',
      'Fern is a plant, not a microorganism. Bacteria, viruses, and fungi are types of microorganisms.',
      'beginner',
    );
    await _insertQuestion(
      'Q_SCI_002_001_02', 'TOP_SCI_002_001', 'CHT_SUB001_002',
      'Which microorganism is used in making bread?',
      '["Bacteria", "Yeast", "Algae", "Virus"]', 'Yeast',
      'Yeast is a fungus that is used in making bread. It causes fermentation.',
      'intermediate',
    );
    await _insertQuestion(
      'Q_SCI_002_001_03', 'TOP_SCI_002_001', 'CHT_SUB001_002',
      'Rhizobium bacteria is found in root nodules of which plants?',
      '["Wheat", "Legumes", "Rice", "Maize"]', 'Legumes',
      'Rhizobium bacteria lives in root nodules of leguminous plants and fixes atmospheric nitrogen.',
      'advanced',
    );

    // Chapter 3: Synthetic Fibres
    await _insertQuestion(
      'Q_SCI_003_001_01', 'TOP_SCI_003_001', 'CHT_SUB001_003',
      'Rayon is also known as:',
      '["Natural silk", "Artificial silk", "Wool", "Nylon"]', 'Artificial silk',
      'Rayon is called artificial silk because it has properties similar to silk but is synthetic.',
      'beginner',
    );
    await _insertQuestion(
      'Q_SCI_003_002_01', 'TOP_SCI_003_002', 'CHT_SUB001_003',
      'Which synthetic fibre is strongest?',
      '["Rayon", "Polyester", "Nylon", "Acrylic"]', 'Nylon',
      'Nylon is the strongest synthetic fibre. It is used in parachutes and ropes.',
      'intermediate',
    );
    await _insertQuestion(
      'Q_SCI_003_003_01', 'TOP_SCI_003_003', 'CHT_SUB001_003',
      'PET bottles are made from:',
      '["Polythene", "PVC", "Polyester", "Bakelite"]', 'Polyester',
      'PET (Polyethylene Terephthalate) is a type of polyester used for making bottles.',
      'intermediate',
    );

    // Chapter 4: Metals and Non-Metals
    await _insertQuestion(
      'Q_SCI_004_001_01', 'TOP_SCI_004_001', 'CHT_SUB001_004',
      'Which metal is liquid at room temperature?',
      '["Iron", "Mercury", "Copper", "Aluminium"]', 'Mercury',
      'Mercury is the only metal that is liquid at room temperature.',
      'beginner',
    );
    await _insertQuestion(
      'Q_SCI_004_002_01', 'TOP_SCI_004_002', 'CHT_SUB001_004',
      'The reaction of metals with oxygen produces:',
      '["Metal hydroxide", "Metal oxide", "Metal carbonate", "Metal chloride"]', 'Metal oxide',
      'When metals react with oxygen, they form metal oxides. Example: 4Na + O₂ → 2Na₂O',
      'intermediate',
    );
    await _insertQuestion(
      'Q_SCI_004_003_01', 'TOP_SCI_004_003', 'CHT_SUB001_004',
      'Which is the most reactive metal?',
      '["Copper", "Iron", "Potassium", "Gold"]', 'Potassium',
      'Potassium is highly reactive. It reacts violently with water and is stored in kerosene.',
      'advanced',
    );

    // Chapter 5: Coal and Petroleum
    await _insertQuestion(
      'Q_SCI_005_001_01', 'TOP_SCI_005_001', 'CHT_SUB001_005',
      'Coal, petroleum, and natural gas are called:',
      '["Renewable resources", "Fossil fuels", "Mineral fuels", "Alternative fuels"]', 'Fossil fuels',
      'These are called fossil fuels because they were formed from remains of dead organisms.',
      'beginner',
    );
    await _insertQuestion(
      'Q_SCI_005_002_01', 'TOP_SCI_005_002', 'CHT_SUB001_005',
      'The process of converting coal into coke, coal tar, and coal gas is called:',
      '["Fractional distillation", "Carbonisation", "Destructive distillation", "Cracking"]',
      'Destructive distillation',
      'Destructive distillation of coal yields coke, coal tar, and coal gas.',
      'intermediate',
    );
    await _insertQuestion(
      'Q_SCI_005_003_01', 'TOP_SCI_005_003', 'CHT_SUB001_005',
      'Petroleum is refined by the process of:',
      '["Simple distillation", "Fractional distillation", "Steam distillation", "Vacuum distillation"]',
      'Fractional distillation',
      'Petroleum is refined by fractional distillation based on different boiling points of components.',
      'advanced',
    );
  }

  /// Seed Maths questions (sample - 3 per topic for first 2 chapters)
  Future<void> _seedMathsQuestions() async {
    // Chapter 1, Topic 1: Rational Numbers Introduction
    await _insertQuestion(
      'Q_MAT_001_001_01', 'TOP_MAT_001_001', 'CHT_SUB002_001',
      'Which of the following is a rational number?',
      '["√2", "π", "3/4", "√5"]', '3/4',
      'A rational number can be expressed as p/q where p and q are integers and q ≠ 0.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_001_001_02', 'TOP_MAT_001_001', 'CHT_SUB002_001',
      'The reciprocal of -3/7 is:',
      '["3/7", "-7/3", "7/3", "-3/7"]', '-7/3',
      'The reciprocal of a/b is b/a. So reciprocal of -3/7 is -7/3.',
      'intermediate',
    );
    await _insertQuestion(
      'Q_MAT_001_002_01', 'TOP_MAT_001_002', 'CHT_SUB002_001',
      'The additive identity for rational numbers is:',
      '["1", "0", "-1", "None"]', '0',
      'Zero is the additive identity because a + 0 = a for any rational number a.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_001_003_01', 'TOP_MAT_001_003', 'CHT_SUB002_001',
      'What is 2/3 + 3/4?',
      '["5/7", "17/12", "5/12", "11/12"]', '17/12',
      'LCM of 3 and 4 is 12. So 2/3 + 3/4 = 8/12 + 9/12 = 17/12.',
      'intermediate',
    );

    // Chapter 2: Linear Equations
    await _insertQuestion(
      'Q_MAT_002_001_01', 'TOP_MAT_002_001', 'CHT_SUB002_002',
      'An equation with only one variable is called:',
      '["Quadratic equation", "Linear equation", "Polynomial", "Expression"]',
      'Linear equation',
      'A linear equation has variables with power 1. Example: 2x + 3 = 7.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_002_002_01', 'TOP_MAT_002_002', 'CHT_SUB002_002',
      'Solve: 3x + 5 = 14',
      '["x = 2", "x = 3", "x = 4", "x = 5"]', 'x = 3',
      '3x + 5 = 14 → 3x = 14 - 5 → 3x = 9 → x = 3.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_002_002_02', 'TOP_MAT_002_002', 'CHT_SUB002_002',
      'Solve: 2(x - 3) = x + 4',
      '["x = 10", "x = 8", "x = 7", "x = 5"]', 'x = 10',
      '2x - 6 = x + 4 → 2x - x = 4 + 6 → x = 10.',
      'intermediate',
    );
    await _insertQuestion(
      'Q_MAT_002_003_01', 'TOP_MAT_002_003', 'CHT_SUB002_002',
      'The sum of two consecutive numbers is 37. The smaller number is:',
      '["17", "18", "19", "20"]', '18',
      'Let numbers be x and x+1. x + (x+1) = 37 → 2x = 36 → x = 18.',
      'intermediate',
    );

    // Chapter 3: Quadrilaterals
    await _insertQuestion(
      'Q_MAT_003_001_01', 'TOP_MAT_003_001', 'CHT_SUB002_003',
      'Sum of angles of a quadrilateral is:',
      '["180°", "270°", "360°", "540°"]', '360°',
      'Sum of interior angles of a quadrilateral = (4-2) × 180° = 360°.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_003_002_01', 'TOP_MAT_003_002', 'CHT_SUB002_003',
      'A quadrilateral with all sides equal and all angles 90° is:',
      '["Rectangle", "Rhombus", "Square", "Parallelogram"]', 'Square',
      'A square has all sides equal and all angles equal to 90°.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_003_003_01', 'TOP_MAT_003_003', 'CHT_SUB002_003',
      'In a parallelogram, opposite angles are:',
      '["Complementary", "Supplementary", "Equal", "None"]', 'Equal',
      'In a parallelogram, opposite angles are equal and adjacent angles are supplementary.',
      'intermediate',
    );

    // Chapter 4: Practical Geometry
    await _insertQuestion(
      'Q_MAT_004_001_01', 'TOP_MAT_004_001', 'CHT_SUB002_004',
      'Minimum how many measurements are needed to construct a unique quadrilateral?',
      '["3", "4", "5", "6"]', '5',
      'To construct a unique quadrilateral, we need 5 independent measurements.',
      'intermediate',
    );

    // Chapter 5: Data Handling
    await _insertQuestion(
      'Q_MAT_005_001_01', 'TOP_MAT_005_001', 'CHT_SUB002_005',
      'A pictorial representation of data using pictures is called:',
      '["Bar graph", "Pictograph", "Pie chart", "Histogram"]', 'Pictograph',
      'A pictograph uses pictures or symbols to represent data.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_005_003_01', 'TOP_MAT_005_003', 'CHT_SUB002_005',
      'In a pie chart, the total angle is:',
      '["180°", "270°", "360°", "540°"]', '360°',
      'A pie chart is a circle, and the total angle at the center is 360°.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_005_004_01', 'TOP_MAT_005_004', 'CHT_SUB002_005',
      'The probability of an impossible event is:',
      '["0", "1", "0.5", "Cannot determine"]', '0',
      'An impossible event has probability 0 as it can never occur.',
      'beginner',
    );
    await _insertQuestion(
      'Q_MAT_005_004_02', 'TOP_MAT_005_004', 'CHT_SUB002_005',
      'The probability of a sure event is:',
      '["0", "0.5", "1", "2"]', '1',
      'A sure event has probability 1 as it is certain to occur.',
      'intermediate',
    );
  }

  Future<void> _insertQuestion(
    String id,
    String topicId,
    String chapterId,
    String questionText,
    String options,
    String correctAnswer,
    String explanation,
    String difficulty,
  ) async {
    await _database.into(_database.questions).insert(
      QuestionsCompanion.insert(
        id: id,
        topicId: topicId,
        chapterId: chapterId,
        questionText: questionText,
        questionType: 'mcq',
        options: options,
        correctAnswer: correctAnswer,
        explanation: explanation,
        difficulty: difficulty,
      ),
    );
  }

  // ============ CONTENT STRINGS ============

  // Science Chapter 1
  static const String _agriculturePracticesContent = '''
# Agricultural Practices

Agriculture is the science and art of cultivating plants and livestock for human use.

## Key Points

- Agriculture provides food, fiber, and fuel
- India is primarily an agricultural country
- About 70% of Indian population depends on agriculture

## Types of Crops

### Based on Season

| Season | Crops | Sowing Time | Harvesting Time |
|--------|-------|-------------|-----------------|
| Kharif | Paddy, Maize, Soybean | June-July | September-October |
| Rabi | Wheat, Gram, Peas | October-November | March-April |

### Based on Usage

- **Food crops**: Wheat, Rice, Pulses
- **Cash crops**: Sugarcane, Cotton, Jute
- **Plantation crops**: Tea, Coffee, Rubber

## Agricultural Practices Steps

1. Preparation of soil
2. Sowing
3. Adding manure and fertilizers
4. Irrigation
5. Protecting from weeds
6. Harvesting
7. Storage

## Summary

- Agriculture involves multiple systematic steps
- Different crops are grown in different seasons
- Proper management ensures better yield
''';

  static const String _soilPreparationContent = '''
# Preparation of Soil

The first step before growing crops is preparation of soil. It involves loosening and turning the soil.

## Why Prepare Soil?

- Allows roots to penetrate deep
- Helps in uprooting weeds
- Allows mixing of nutrients
- Improves aeration of soil

## Agricultural Implements

### Plough
- Used for tilling the land
- Made of wood or iron
- Pulled by bullocks or tractors

### Hoe
- Simple tool for removing weeds
- Loosens soil around plants

### Cultivator
- Tractor-driven implement
- Faster than traditional plough
- Saves time and labor

## Levelling

After ploughing, the field is levelled using a leveller to:
- Break large soil crumbs
- Even out the field
- Help in proper irrigation

## Summary

- Soil preparation is crucial for good crop yield
- Various implements are used based on need
- Modern tools save time and effort
''';

  static const String _sowingContent = '''
# Sowing and Adding Manure

## Sowing

Sowing is the process of putting seeds in the soil.

### Methods of Sowing

1. **Traditional Method**
   - Seeds scattered by hand
   - Not uniform distribution

2. **Seed Drill**
   - Sows seeds at uniform distances
   - Proper depth maintained
   - Saves time and seeds

### Selection of Seeds

- Use healthy seeds
- Remove damaged seeds
- Seeds should be disease-free

## Manure and Fertilizers

### Manure
- Organic substance
- Made from decomposed matter
- Improves soil texture
- Examples: Compost, Vermicompost

### Fertilizers
- Chemicals containing nutrients
- Provide specific nutrients
- Examples: Urea, NPK

| Manure | Fertilizer |
|--------|------------|
| Organic | Inorganic |
| Slow action | Quick action |
| Improves soil | May harm soil |
| Cheaper | Expensive |

## Summary

- Proper sowing ensures good germination
- Both manure and fertilizers are important
- Balanced use gives best results
''';

  static const String _irrigationContent = '''
# Irrigation and Harvesting

## Irrigation

Supply of water to crops at regular intervals is called irrigation.

### Sources of Irrigation

1. Wells and tubewells
2. Canals
3. Rivers
4. Ponds and lakes
5. Dams

### Traditional Methods

- **Moat (Pulley system)**: Water lifted using pulleys
- **Chain pump**: Series of buckets on chain
- **Dhekli**: Lever system with bucket

### Modern Methods

- **Sprinkler System**: Water sprayed like rain
- **Drip System**: Water drops near plant roots

## Harvesting

Cutting of mature crop is called harvesting.

### Methods

1. **Manual harvesting**: Using sickle
2. **Machine harvesting**: Using combine harvesters

### Winnowing

- Separation of grain from chaff
- Done by throwing grains in air
- Chaff blown away by wind

## Storage

- Grains must be dried before storage
- Silos and granaries used for large scale storage
- Protect from pests and moisture

## Summary

- Proper irrigation is essential for crops
- Modern methods save water
- Harvested grains need proper storage
''';

  // Science Chapter 2 - Microorganisms
  static const String _microorganismsIntroContent = '''
# Introduction to Microorganisms

Microorganisms are living organisms that cannot be seen with naked eyes.

## Types of Microorganisms

1. **Bacteria**
   - Single-celled organisms
   - Some useful, some harmful
   - Example: Lactobacillus

2. **Fungi**
   - Can be single or multi-celled
   - Example: Yeast, Mushroom

3. **Protozoa**
   - Single-celled organisms
   - Example: Amoeba, Paramecium

4. **Algae**
   - Can make their own food
   - Example: Chlamydomonas

5. **Viruses**
   - Reproduce only in host
   - Very small in size

## Where do they live?

- Soil
- Water
- Air
- Inside bodies of organisms

## Summary

- Microorganisms are everywhere
- They can be helpful or harmful
- Studied using microscope
''';

  static const String _usefulMicroContent = '''
# Useful Microorganisms

Many microorganisms are beneficial to humans.

## Uses in Food Industry

1. **Making Curd**
   - Lactobacillus bacteria
   - Converts milk to curd

2. **Making Bread**
   - Yeast (Saccharomyces)
   - Causes dough to rise

3. **Making Alcohol**
   - Yeast fermentation
   - Sugar → Alcohol + CO₂

## Medical Uses

1. **Antibiotics**
   - Medicines from microorganisms
   - Kill or stop growth of bacteria
   - Example: Penicillin from Penicillium

2. **Vaccines**
   - Protect against diseases
   - Made from weakened microorganisms

## Agricultural Uses

1. **Nitrogen Fixation**
   - Rhizobium in legume roots
   - Fixes atmospheric nitrogen

2. **Decomposition**
   - Break down organic matter
   - Return nutrients to soil

## Summary

- Microorganisms are essential for many processes
- They help in food, medicine, and agriculture
- Controlled use is beneficial
''';

  static const String _harmfulMicroContent = '''
# Harmful Microorganisms

Some microorganisms cause diseases in plants and animals.

## Diseases in Humans

| Disease | Caused By | Mode of Spread |
|---------|-----------|----------------|
| Tuberculosis | Bacteria | Air |
| Typhoid | Bacteria | Water |
| Cholera | Bacteria | Water |
| Malaria | Protozoa | Mosquito |
| Common cold | Virus | Air |
| COVID-19 | Virus | Air/Contact |

## Diseases in Animals

- Anthrax in cattle
- Foot and mouth disease

## Diseases in Plants

- Citrus canker (Bacteria)
- Rust of wheat (Fungi)
- Yellow vein mosaic (Virus)

## Prevention

1. Keep surroundings clean
2. Drink clean water
3. Cover food properly
4. Vaccination
5. Personal hygiene

## Summary

- Pathogens cause diseases
- Prevention is better than cure
- Hygiene reduces infection risk
''';

  static const String _foodPreservationContent = '''
# Food Preservation

Methods to prevent spoilage of food by microorganisms.

## Why Food Spoils?

- Microorganisms grow on food
- They decompose food
- Make it unfit for consumption

## Preservation Methods

### 1. Chemical Preservation
- Salt kills bacteria
- Sugar (jams, jellies)
- Vinegar (pickles)
- Sodium benzoate (in packaged food)

### 2. Physical Methods

**Heating**
- Pasteurization: Heating milk to 70°C for 15-30 seconds
- Kills harmful microorganisms

**Cooling**
- Refrigeration slows growth
- Freezing stops growth

**Drying**
- Remove moisture
- Microorganisms need water

### 3. Other Methods

- Vacuum packing
- Nitrogen packing
- Canning

## Summary

- Preservation extends food life
- Multiple methods available
- Choose based on food type
''';

  // Science Chapter 3 - Synthetic Fibres
  static const String _fibresTypesContent = '''
# Types of Fibres

Fibres are thin, thread-like strands used for making fabrics.

## Classification

### Natural Fibres
- Obtained from plants or animals
- Examples:
  - Cotton (plant)
  - Jute (plant)
  - Silk (animal - silkworm)
  - Wool (animal - sheep)

### Synthetic Fibres
- Made by humans in factories
- From chemicals
- Examples:
  - Nylon
  - Polyester
  - Acrylic

## Natural vs Synthetic

| Natural | Synthetic |
|---------|-----------|
| From nature | Man-made |
| Biodegradable | Non-biodegradable |
| Comfortable | Less comfortable |
| Absorb water | Quick dry |

## Summary

- Two main types of fibres
- Each has advantages
- Used based on requirement
''';

  static const String _syntheticFibresContent = '''
# Synthetic Fibres

Synthetic fibres are made from chemicals derived from petroleum.

## Types of Synthetic Fibres

### 1. Rayon
- Made from wood pulp
- Also called artificial silk
- Used for bedsheets, curtains

### 2. Nylon
- First fully synthetic fibre
- Very strong
- Used for:
  - Parachutes
  - Ropes
  - Stockings
  - Toothbrush bristles

### 3. Polyester
- Does not wrinkle easily
- Remains crisp
- PET bottles made from it
- Terylene is a type of polyester

### 4. Acrylic
- Wool-like synthetic fibre
- Used for sweaters, shawls
- Cheaper than wool

## Advantages

- Strong and durable
- Easy to wash
- Dry quickly
- Less expensive

## Summary

- Many types available
- Each has unique properties
- Widely used today
''';

  static const String _plasticsContent = '''
# Plastics

Plastics are synthetic materials that can be moulded into different shapes.

## Types of Plastics

### 1. Thermoplastics
- Can be bent easily on heating
- Can be remoulded
- Examples: Polythene, PVC

### 2. Thermosetting Plastics
- Cannot be softened by heating again
- Examples: Bakelite, Melamine

## Properties of Plastics

- Light weight
- Strong and durable
- Poor conductors of heat
- Non-reactive
- Can be moulded

## Uses

| Plastic | Use |
|---------|-----|
| Polythene | Carry bags |
| PVC | Pipes, insulation |
| Bakelite | Electrical switches |
| Melamine | Kitchenware |
| Teflon | Non-stick cookware |

## Summary

- Two main types of plastics
- Very useful in daily life
- Need to use responsibly
''';

  static const String _environmentImpactContent = '''
# Environmental Impact

Synthetic materials affect our environment.

## Problems with Plastics

### 1. Non-biodegradable
- Takes hundreds of years to decompose
- Accumulates in environment

### 2. Harmful to Animals
- Animals eat plastic bags
- Marine life affected

### 3. Pollution
- Burning releases toxic gases
- Clogs drains causing floods

## 5R Principle

1. **Reduce** - Use less plastic
2. **Reuse** - Use again if possible
3. **Recycle** - Convert to new products
4. **Recover** - Get energy from waste
5. **Refuse** - Say no to plastic bags

## Better Alternatives

- Jute bags instead of plastic
- Paper cups instead of plastic
- Biodegradable materials

## Summary

- Synthetic materials harm environment
- 5R principle helps reduce damage
- Choose eco-friendly options
''';

  // Science Chapter 4 - Metals and Non-Metals
  static const String _metalPhysicalContent = '''
# Physical Properties of Metals and Non-Metals

## Properties of Metals

1. **Lustre** - Shiny appearance
2. **Hardness** - Generally hard (except Na, K)
3. **Malleability** - Can be beaten into sheets
4. **Ductility** - Can be drawn into wires
5. **Conductivity** - Good conductors of heat and electricity
6. **Sonorous** - Produce sound when struck

## Properties of Non-Metals

1. No lustre (except iodine, graphite)
2. Generally soft (except diamond)
3. Not malleable
4. Not ductile
5. Poor conductors (except graphite)
6. Non-sonorous

## Comparison

| Property | Metals | Non-Metals |
|----------|--------|------------|
| State | Solid (except Hg) | Solid/Gas/Liquid |
| Lustre | Yes | No |
| Malleability | Yes | No |
| Conductivity | Good | Poor |

## Summary

- Metals and non-metals have opposite properties
- Properties determine their uses
''';

  static const String _metalChemicalContent = '''
# Chemical Properties of Metals and Non-Metals

## Reaction with Oxygen

### Metals
- Form metal oxides
- Most are basic in nature
- Example: 4Na + O₂ → 2Na₂O

### Non-Metals
- Form non-metal oxides
- Most are acidic in nature
- Example: C + O₂ → CO₂

## Reaction with Water

### Metals
| Metal | Reaction |
|-------|----------|
| Sodium | Very reactive, catches fire |
| Magnesium | Reacts with hot water |
| Iron | Reacts with steam |
| Gold | No reaction |

### Non-Metals
- Generally do not react with water

## Reaction with Acids

### Metals
- Release hydrogen gas
- Example: Zn + H₂SO₄ → ZnSO₄ + H₂

### Non-Metals
- Do not react with dilute acids

## Summary

- Chemical properties help identify metals
- Reactivity varies among metals
''';

  static const String _reactivitySeriesContent = '''
# Reactivity Series

Arrangement of metals in order of decreasing reactivity.

## The Reactivity Series

Most Reactive ↓

1. Potassium (K)
2. Sodium (Na)
3. Calcium (Ca)
4. Magnesium (Mg)
5. Aluminium (Al)
6. Zinc (Zn)
7. Iron (Fe)
8. Lead (Pb)
9. Hydrogen (H) - reference
10. Copper (Cu)
11. Silver (Ag)
12. Gold (Au)

Least Reactive ↑

## Displacement Reactions

- More reactive metal displaces less reactive
- Example: Fe + CuSO₄ → FeSO₄ + Cu
- Iron displaces copper from its solution

## Uses of Reactivity

- Extraction of metals
- Galvanization (Zn coating on iron)
- Making alloys

## Summary

- Reactivity varies greatly among metals
- Used to predict chemical reactions
''';

  static const String _metalUsesContent = '''
# Uses of Metals and Non-Metals

## Uses of Metals

### Iron
- Construction (beams, rods)
- Making vehicles
- Kitchen utensils

### Copper
- Electrical wires
- Coins
- Vessels

### Aluminium
- Aircraft bodies
- Cooking utensils
- Packaging (foil)

### Gold & Silver
- Jewellery
- Coins
- Electronics

## Uses of Non-Metals

### Carbon
- Fuel (coal)
- Pencils (graphite)
- Diamonds (jewellery)

### Sulphur
- Medicines
- Fungicides
- Fireworks

### Nitrogen
- Fertilizers
- Food packaging
- Explosives

### Oxygen
- Respiration
- Combustion
- Medical use

## Summary

- Each element has unique uses
- Properties determine applications
''';

  // Science Chapter 5 - Coal and Petroleum
  static const String _naturalResourcesContent = '''
# Natural Resources

Resources obtained from nature are called natural resources.

## Types of Natural Resources

### 1. Inexhaustible Resources
- Present in unlimited quantity
- Examples: Sunlight, Air, Water

### 2. Exhaustible Resources
- Limited in quantity
- Will run out if used continuously
- Examples: Coal, Petroleum, Forests

## Fossil Fuels

- Formed from remains of dead organisms
- Over millions of years
- Found beneath earth's surface
- Examples:
  - Coal
  - Petroleum
  - Natural Gas

## Why Called Fossil Fuels?

- Fossils = Remains of dead organisms
- These fuels formed from fossils
- Under heat and pressure
- Over millions of years

## Summary

- Natural resources are precious
- Some can be exhausted
- Need to use wisely
''';

  static const String _coalContent = '''
# Coal Formation and Uses

## Formation of Coal

1. Dead plants buried deep
2. Covered by soil and water
3. High pressure and temperature
4. Over millions of years
5. Converted to coal

This process is called **Carbonisation**.

## Types of Coal

| Type | Carbon Content | Quality |
|------|----------------|---------|
| Peat | Lowest | Poor |
| Lignite | Low | Fair |
| Bituminous | Medium | Good |
| Anthracite | Highest | Best |

## Products from Coal

### Destructive Distillation
Heating coal in absence of air gives:

1. **Coke**
   - Almost pure carbon
   - Used in steel making

2. **Coal Tar**
   - Thick black liquid
   - Used for road surfacing
   - Source of many chemicals

3. **Coal Gas**
   - Used as fuel

## Uses of Coal

- Power generation
- Steel industry
- Manufacturing

## Summary

- Coal is a fossil fuel
- Formed over millions of years
- Many useful products
''';

  static const String _petroleumContent = '''
# Petroleum and Natural Gas

## Petroleum (Crude Oil)

- Also called black gold
- Found beneath ocean floors
- Formed from marine organisms

## Formation

1. Dead sea organisms settle
2. Covered by sand and clay
3. High pressure and temperature
4. Converted to petroleum

## Refining of Petroleum

**Fractional Distillation**
- Crude oil heated in refinery
- Separates into fractions
- Based on boiling points

### Products of Petroleum

| Product | Use |
|---------|-----|
| LPG | Cooking fuel |
| Petrol | Vehicle fuel |
| Kerosene | Jet fuel |
| Diesel | Heavy vehicles |
| Lubricating oil | Machines |
| Paraffin wax | Candles |
| Bitumen | Road making |

## Natural Gas

- Found above petroleum
- Mainly methane
- CNG used in vehicles
- LPG used in homes

## Summary

- Petroleum is very valuable
- Many products obtained
- Natural gas is cleaner fuel
''';

  static const String _conservationContent = '''
# Conservation of Resources

## Why Conserve?

- Fossil fuels are exhaustible
- Formation takes millions of years
- Current consumption very high
- Future generations need them

## PCRA Guidelines

Petroleum Conservation Research Association recommends:

### For Vehicles
- Drive at constant speed
- Maintain correct tyre pressure
- Regular servicing
- Switch off at red lights
- Use public transport

### At Home
- Use efficient appliances
- Turn off when not in use
- Use CFL/LED bulbs
- Solar water heaters

## Alternative Energy Sources

1. **Solar Energy** - From sun
2. **Wind Energy** - From wind
3. **Hydropower** - From flowing water
4. **Geothermal** - From earth's heat
5. **Biomass** - From organic matter

## Summary

- Conservation is essential
- Small steps make big difference
- Renewable sources are future
''';

  // Mathematics Content
  static const String _rationalIntroContent = '''
# Introduction to Rational Numbers

A rational number can be expressed as p/q where q ≠ 0.

## Definition

- p and q are integers
- q is not zero
- Example: 3/4, -5/7, 2/1

## Natural Numbers ⊂ Whole Numbers ⊂ Integers ⊂ Rational Numbers

## Examples

| Number | Rational? | Reason |
|--------|-----------|--------|
| 5 | Yes | 5/1 |
| -3 | Yes | -3/1 |
| 0.5 | Yes | 1/2 |
| √2 | No | Non-terminating, non-repeating |

## Standard Form

A rational number is in standard form if:
- q is positive
- p and q have no common factor other than 1

Example: 6/8 in standard form = 3/4

## Summary

- Rational numbers include all fractions
- Can be positive, negative, or zero
- Standard form simplifies fractions
''';

  static const String _rationalPropertiesContent = '''
# Properties of Rational Numbers

## 1. Closure Property

| Operation | Closed? |
|-----------|---------|
| Addition | Yes |
| Subtraction | Yes |
| Multiplication | Yes |
| Division | No (÷0 undefined) |

## 2. Commutative Property

- Addition: a + b = b + a ✓
- Multiplication: a × b = b × a ✓
- Subtraction: a - b ≠ b - a ✗
- Division: a ÷ b ≠ b ÷ a ✗

## 3. Associative Property

- Addition: (a + b) + c = a + (b + c) ✓
- Multiplication: (a × b) × c = a × (b × c) ✓

## 4. Identity Elements

- Additive identity: 0 (a + 0 = a)
- Multiplicative identity: 1 (a × 1 = a)

## 5. Inverse Elements

- Additive inverse of a/b = -a/b
- Multiplicative inverse of a/b = b/a (a ≠ 0)

## Summary

- Properties help simplify calculations
- Not all properties apply to all operations
''';

  static const String _rationalOperationsContent = '''
# Operations on Rational Numbers

## Addition

To add fractions:
1. Find LCM of denominators
2. Make denominators same
3. Add numerators

Example: 2/3 + 1/4
= 8/12 + 3/12 = 11/12

## Subtraction

Similar to addition:
Example: 3/4 - 1/2
= 3/4 - 2/4 = 1/4

## Multiplication

Multiply numerators and denominators:
a/b × c/d = ac/bd

Example: 2/3 × 3/4 = 6/12 = 1/2

## Division

Multiply by reciprocal:
a/b ÷ c/d = a/b × d/c

Example: 2/3 ÷ 4/5 = 2/3 × 5/4 = 10/12 = 5/6

## Order of Operations

BODMAS:
1. Brackets
2. Of (powers)
3. Division
4. Multiplication
5. Addition
6. Subtraction

## Summary

- Four basic operations
- Each has specific rules
- Follow BODMAS for complex expressions
''';

  static const String _rationalNumberLineContent = '''
# Representing Rational Numbers on Number Line

## Number Line

A line with numbers marked at equal intervals.

## Steps to Represent

1. Identify the fraction
2. Divide unit into parts = denominator
3. Count parts = numerator

## Example: Represent 3/4

1. Take segment from 0 to 1
2. Divide into 4 equal parts
3. Mark 3rd division = 3/4

## Negative Rational Numbers

- Represented on left side of 0
- Example: -2/3 is between -1 and 0

## Finding Rationals Between Two Numbers

Between a/b and c/d:
- Mean = (a/b + c/d) ÷ 2

There are infinite rational numbers between any two rationals!

## Summary

- Number line visualizes rationals
- Helps understand order
- Infinite rationals between any two
''';

  static const String _equationsIntroContent = '''
# Introduction to Equations

## What is an Equation?

A mathematical statement showing equality of two expressions.

Example: 2x + 3 = 7

## Parts of an Equation

- **LHS** (Left Hand Side): 2x + 3
- **RHS** (Right Hand Side): 7
- **Variable**: x (unknown value)
- **Constants**: 2, 3, 7

## Linear Equation

An equation where the highest power of variable is 1.

Examples:
- 3x + 5 = 11 ✓ (Linear)
- x² + 3 = 7 ✗ (Not linear)

## Solution

The value of variable that makes equation true.

For 2x + 3 = 7:
- Solution: x = 2
- Verification: 2(2) + 3 = 4 + 3 = 7 ✓

## Summary

- Equations show equality
- Linear equations have power 1
- Solution satisfies the equation
''';

  static const String _solvingEquationsContent = '''
# Solving Linear Equations

## Rules for Solving

1. Add/subtract same number from both sides
2. Multiply/divide both sides by same number (≠0)
3. Simplify step by step

## Method 1: Transposition

Moving terms from one side to another by changing sign.

Example: Solve 3x + 4 = 13
- 3x = 13 - 4
- 3x = 9
- x = 3

## Method 2: Balancing

Keep equation balanced.

Example: Solve 5x - 7 = 18
- 5x - 7 + 7 = 18 + 7
- 5x = 25
- x = 5

## Complex Example

Solve: 2(x - 3) + 4 = 3x - 1
- 2x - 6 + 4 = 3x - 1
- 2x - 2 = 3x - 1
- -2 + 1 = 3x - 2x
- -1 = x
- x = -1

## Summary

- Multiple methods available
- Always verify solution
- Practice builds speed
''';

  static const String _wordProblemsContent = '''
# Word Problems

## Steps to Solve

1. Read the problem carefully
2. Identify what is unknown (variable)
3. Form an equation
4. Solve the equation
5. Check the answer

## Example 1: Age Problems

The sum of ages of a father and son is 50. Father is 4 times older than son. Find their ages.

Let son's age = x
Father's age = 4x

x + 4x = 50
5x = 50
x = 10

Son = 10 years, Father = 40 years

## Example 2: Number Problems

The sum of two consecutive numbers is 35. Find them.

Let numbers be x and x+1
x + (x+1) = 35
2x + 1 = 35
2x = 34
x = 17

Numbers: 17 and 18

## Summary

- Translate words to equations
- Identify the unknown
- Verify answer makes sense
''';

  static const String _variablesBothSidesContent = '''
# Equations with Variables on Both Sides

## Method

1. Collect variable terms on one side
2. Collect constants on other side
3. Simplify

## Example 1

Solve: 5x - 3 = 2x + 6

- 5x - 2x = 6 + 3
- 3x = 9
- x = 3

## Example 2

Solve: 3(x + 2) = 2(x - 1) + 11

- 3x + 6 = 2x - 2 + 11
- 3x + 6 = 2x + 9
- 3x - 2x = 9 - 6
- x = 3

## Example 3 (Fractions)

Solve: (x + 3)/4 = (x - 1)/3

Cross multiply:
- 3(x + 3) = 4(x - 1)
- 3x + 9 = 4x - 4
- 9 + 4 = 4x - 3x
- x = 13

## Summary

- Variables can be on both sides
- Group like terms together
- Cross multiply for fractions
''';

  static const String _polygonsIntroContent = '''
# Introduction to Polygons

A polygon is a closed figure made of line segments.

## Types of Polygons

| Sides | Name |
|-------|------|
| 3 | Triangle |
| 4 | Quadrilateral |
| 5 | Pentagon |
| 6 | Hexagon |
| 7 | Heptagon |
| 8 | Octagon |

## Classifications

### Convex Polygon
- All interior angles < 180°
- No diagonals outside

### Concave Polygon
- At least one angle > 180°
- Some diagonals outside

### Regular Polygon
- All sides equal
- All angles equal

## Angle Sum Property

Sum of interior angles = (n - 2) × 180°

For quadrilateral: (4 - 2) × 180° = 360°

## Summary

- Polygons named by sides
- Different classifications
- Angle sum formula useful
''';

  static const String _quadrilateralTypesContent = '''
# Types of Quadrilaterals

## Quadrilateral Family

### 1. Trapezium
- One pair of parallel sides
- Non-parallel sides called legs

### 2. Parallelogram
- Both pairs of opposite sides parallel
- Opposite sides equal

### 3. Rectangle
- Parallelogram with all angles 90°
- Diagonals equal

### 4. Rhombus
- Parallelogram with all sides equal
- Diagonals bisect at 90°

### 5. Square
- Rectangle + Rhombus
- All sides equal
- All angles 90°

### 6. Kite
- Two pairs of adjacent sides equal
- Diagonals perpendicular

## Hierarchy

Square → Rectangle → Parallelogram → Trapezium
Square → Rhombus → Parallelogram → Trapezium

## Summary

- Special quadrilaterals have special properties
- Square is most special
- Each has unique features
''';

  static const String _parallelogramPropertiesContent = '''
# Properties of Parallelograms

## Basic Properties

1. Opposite sides are equal
   - AB = CD, BC = AD

2. Opposite angles are equal
   - ∠A = ∠C, ∠B = ∠D

3. Adjacent angles are supplementary
   - ∠A + ∠B = 180°

4. Diagonals bisect each other
   - AO = OC, BO = OD

## Rectangle Properties

All parallelogram properties, plus:
- All angles are 90°
- Diagonals are equal

## Rhombus Properties

All parallelogram properties, plus:
- All sides are equal
- Diagonals bisect at 90°
- Diagonals bisect vertex angles

## Square Properties

Has properties of both rectangle and rhombus!

## Summary

- Each type has specific properties
- Properties help solve problems
''';

  static const String _angleSumContent = '''
# Angle Sum Property

## Interior Angles

Sum of interior angles of a polygon:
**S = (n - 2) × 180°**

| Polygon | n | Sum |
|---------|---|-----|
| Triangle | 3 | 180° |
| Quadrilateral | 4 | 360° |
| Pentagon | 5 | 540° |
| Hexagon | 6 | 720° |

## Exterior Angles

Sum of exterior angles = 360° (always!)

Each exterior angle of regular polygon = 360°/n

## Example Problem

Find the fourth angle of a quadrilateral if other angles are 80°, 100°, and 70°.

Sum = 360°
Fourth angle = 360° - (80° + 100° + 70°)
= 360° - 250° = 110°

## Summary

- Interior angle sum depends on sides
- Exterior angle sum always 360°
''';

  // Maths Chapter 4 - Practical Geometry
  static const String _constructingQuadContent = '''
# Constructing Quadrilaterals

## Required Information

To construct a unique quadrilateral, we need 5 independent measurements:
- 4 sides + 1 diagonal
- 3 sides + 2 diagonals
- 4 sides + 1 angle
- 3 sides + 2 included angles

## Basic Tools

- Ruler
- Compass
- Protractor
- Set squares

## Steps to Construct

1. Draw a rough sketch
2. Mark the given measurements
3. Follow systematic construction
4. Verify the construction

## Summary

- 5 measurements needed
- Multiple combinations possible
- Accuracy is important
''';

  static const String _sssConstructionContent = '''
# SSS Construction

When 4 sides and 1 diagonal are given.

## Example

Construct quadrilateral ABCD where:
- AB = 4 cm, BC = 5 cm
- CD = 4.5 cm, DA = 5.5 cm
- AC = 6 cm

## Steps

1. Draw AC = 6 cm
2. With A as center, radius 4 cm, draw arc
3. With C as center, radius 5 cm, draw arc
4. Mark intersection as B
5. With A as center, radius 5.5 cm, draw arc
6. With C as center, radius 4.5 cm, draw arc
7. Mark intersection as D
8. Join AB, BC, CD, DA

## Summary

- Diagonal divides into 2 triangles
- Construct triangles separately
- Join to form quadrilateral
''';

  static const String _sasConstructionContent = '''
# SAS Construction

When 3 sides and 2 included angles are given.

## Example

Construct quadrilateral PQRS where:
- PQ = 5 cm, ∠P = 60°
- PS = 4 cm, ∠S = 90°
- SR = 4.5 cm

## Steps

1. Draw PQ = 5 cm
2. At P, draw angle 60°
3. Mark PS = 4 cm on this ray
4. At S, draw angle 90°
5. Mark SR = 4.5 cm on this ray
6. Join RQ

## Tips

- Measure angles accurately
- Use protractor carefully
- Verify measurements

## Summary

- Angles determine direction
- Work systematically
- Verify final figure
''';

  static const String _specialCasesContent = '''
# Special Cases in Construction

## Constructing Parallelogram

Given: Two adjacent sides and included angle

### Steps
1. Draw one side
2. Draw included angle
3. Mark second side
4. Use parallel property
5. Complete parallelogram

## Constructing Rhombus

Given: Diagonals

### Steps
1. Draw one diagonal
2. Draw perpendicular bisector
3. Mark half of second diagonal on each side
4. Join vertices

## Constructing Rectangle

Given: Two adjacent sides

### Steps
1. Draw one side
2. Draw 90° angle at both ends
3. Mark second side on both
4. Join to complete

## Summary

- Special quadrilaterals have shortcuts
- Use properties to simplify
''';

  // Maths Chapter 5 - Data Handling
  static const String _dataIntroContent = '''
# Introduction to Data

Data is collection of information in form of numbers or words.

## Types of Data

### Raw Data
- Unorganized information
- As collected originally

### Organized Data
- Arranged systematically
- Easier to understand

## Ways to Organize

1. **Frequency Distribution Table**
   - Shows how often values occur

2. **Grouped Frequency Distribution**
   - Data divided into class intervals

## Example

Marks of 10 students: 45, 50, 45, 60, 55, 50, 45, 65, 50, 55

| Marks | Frequency |
|-------|-----------|
| 45 | 3 |
| 50 | 3 |
| 55 | 2 |
| 60 | 1 |
| 65 | 1 |

## Summary

- Data needs organization
- Tables make data clear
''';

  static const String _organizingDataContent = '''
# Organizing Data

## Frequency Distribution Table

Shows how often each value occurs.

### Components
- Class interval (range)
- Tally marks
- Frequency (count)

## Example

Heights of students (in cm):
150, 155, 150, 160, 155, 150, 165, 160, 155, 150

| Height | Tally | Frequency |
|--------|-------|-----------|
| 150 | |||| | 4 |
| 155 | ||| | 3 |
| 160 | || | 2 |
| 165 | | | 1 |

## Grouped Data

For large data sets:

| Class Interval | Frequency |
|----------------|-----------|
| 150-155 | 7 |
| 155-160 | 5 |
| 160-165 | 3 |

## Summary

- Tally marks help counting
- Grouping simplifies large data
''';

  static const String _pieChartsContent = '''
# Pie Charts

A circular graph showing data as sectors.

## Creating Pie Chart

1. Calculate percentage for each category
2. Convert to degrees: (percentage/100) × 360°
3. Draw sectors with protractor

## Example

Monthly expenses:
- Food: 40%
- Rent: 30%
- Transport: 20%
- Others: 10%

Angles:
- Food: 0.4 × 360° = 144°
- Rent: 0.3 × 360° = 108°
- Transport: 0.2 × 360° = 72°
- Others: 0.1 × 360° = 36°

## Reading Pie Charts

- Larger sector = larger value
- Compare sectors visually
- Read percentages from legend

## Summary

- Pie charts show parts of whole
- Total is always 360°
- Easy visual comparison
''';

  static const String _probabilityContent = '''
# Probability

Probability measures the chance of an event occurring.

## Basic Formula

Probability = Favorable outcomes / Total outcomes

P(E) = n(E) / n(S)

## Types of Events

1. **Sure Event**: P = 1
   - Will definitely happen

2. **Impossible Event**: P = 0
   - Will never happen

3. **Equally Likely**: Same chance
   - Example: Coin toss

## Probability Range

0 ≤ P(E) ≤ 1

- P = 0: Impossible
- P = 1: Certain
- P = 0.5: Equally likely

## Example

Rolling a die:
- P(getting 3) = 1/6
- P(even number) = 3/6 = 1/2
- P(less than 7) = 6/6 = 1

## Summary

- Probability is between 0 and 1
- Helps predict outcomes
- Based on favorable/total ratio
''';
}
