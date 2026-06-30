class BmiRecord {
  final String id;
  final double weight; // in kg
  final double height; // in cm
  final int age;
  final String gender; // 'male' or 'female'
  final String activityLevel;
  final double bmi;
  final double bodyFat;
  final double bmr;
  final double tdee;
  final DateTime date;

  BmiRecord({
    required this.id,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.bmi,
    required this.bodyFat,
    required this.bmr,
    required this.tdee,
    required this.date,
  });

  // Calculate metrics programmatically when creating a new record
  factory BmiRecord.create({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
  }) {
    final double heightInM = height / 100.0;
    final double bmi = weight / (heightInM * heightInM);

    // Body Fat Percentage (Deurenberg formula)
    // BFP = 1.20 * BMI + 0.23 * Age - 10.8 * Gender - 5.4 (Male = 1, Female = 0)
    final double genderFactor = gender.toLowerCase() == 'male' ? 1.0 : 0.0;
    final double bodyFat = (1.20 * bmi) + (0.23 * age) - (10.8 * genderFactor) - 5.4;

    // Basal Metabolic Rate (BMR) - Mifflin-St Jeor Equation
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = (10.0 * weight) + (6.25 * height) - (5.0 * age) + 5.0;
    } else {
      bmr = (10.0 * weight) + (6.25 * height) - (5.0 * age) - 161.0;
    }

    // TDEE multiplier based on activity level
    double activityMultiplier;
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'lightly active':
        activityMultiplier = 1.375;
        break;
      case 'moderately active':
        activityMultiplier = 1.55;
        break;
      case 'very active':
        activityMultiplier = 1.725;
        break;
      case 'extra active':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }
    final double tdee = bmr * activityMultiplier;

    return BmiRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      bmi: bmi,
      bodyFat: bodyFat < 0 ? 0.0 : bodyFat,
      bmr: bmr,
      tdee: tdee,
      date: DateTime.now(),
    );
  }

  // Convert map to BmiRecord
  factory BmiRecord.fromJson(Map<String, dynamic> json) {
    return BmiRecord(
      id: json['id'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      age: json['age'] as int,
      gender: json['gender'] as String,
      activityLevel: json['activityLevel'] as String,
      bmi: (json['bmi'] as num).toDouble(),
      bodyFat: (json['bodyFat'] as num).toDouble(),
      bmr: (json['bmr'] as num).toDouble(),
      tdee: (json['tdee'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  // Convert BmiRecord to map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'activityLevel': activityLevel,
      'bmi': bmi,
      'bodyFat': bodyFat,
      'bmr': bmr,
      'tdee': tdee,
      'date': date.toIso8601String(),
    };
  }
}
