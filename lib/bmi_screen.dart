import 'package:flutter/material.dart';
import 'package:trial1/history_screen.dart';
import 'package:trial1/result_screen.dart';
import 'package:trial1/bmi_record.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // Calculation Variables
  bool _isMetric = true;
  String _gender = 'male'; // 'male' or 'female'
  double _heightCm = 172.0; // range: 100 to 220
  double _weightKg = 68.0;  // range: 30 to 180
  int _age = 24;
  String _activityLevel = 'moderately active';

  final List<Map<String, String>> _activities = [
    {'value': 'sedentary', 'label': 'Sedentary', 'desc': 'Little to no exercise'},
    {'value': 'lightly active', 'label': 'Lightly Active', 'desc': 'Exercise 1-3 times/week'},
    {'value': 'moderately active', 'label': 'Moderately Active', 'desc': 'Exercise 3-5 times/week'},
    {'value': 'very active', 'label': 'Very Active', 'desc': 'Hard exercise 6-7 times/week'},
    {'value': 'extra active', 'label': 'Extra Active', 'desc': 'Very intense daily physical job'},
  ];

  // Convert height cm to ft & in for display
  String _getHeightDisplay() {
    if (_isMetric) {
      return '${_heightCm.toInt()} cm';
    } else {
      final double totalInches = _heightCm / 2.54;
      final int feet = (totalInches / 12).floor();
      final int inches = (totalInches % 12).round();
      return "$feet' $inches\"";
    }
  }

  // Convert weight kg to lbs for display
  String _getWeightDisplay() {
    if (_isMetric) {
      return '${_weightKg.toStringAsFixed(1)} kg';
    } else {
      final double lbs = _weightKg * 2.20462;
      return '${lbs.toStringAsFixed(1)} lbs';
    }
  }

  void _adjustWeight(bool increase) {
    setState(() {
      final increment = _isMetric ? 0.5 : (1.0 / 2.20462); // 0.5kg or 1lb
      if (increase) {
        if (_weightKg + increment <= 200.0) _weightKg += increment;
      } else {
        if (_weightKg - increment >= 25.0) _weightKg -= increment;
      }
    });
  }

  void _adjustAge(bool increase) {
    setState(() {
      if (increase) {
        if (_age < 120) _age++;
      } else {
        if (_age > 2) _age--;
      }
    });
  }

  void _calculateAndNavigate() {
    // Generate a new BMI record
    final record = BmiRecord.create(
      weight: _weightKg,
      height: _heightCm,
      age: _age,
      gender: _gender,
      activityLevel: _activityLevel,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(record: record),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart BMI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'View History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. UNIT SELECTION TOGGLE
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F1724) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildUnitOption('Metric', _isMetric),
                      _buildUnitOption('Imperial', !_isMetric),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 2. GENDER SELECTION
              Row(
                children: [
                  Expanded(
                    child: _buildGenderCard(
                      'Male',
                      Icons.male_rounded,
                      _gender == 'male',
                      Colors.blue,
                      () => setState(() => _gender = 'male'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderCard(
                      'Female',
                      Icons.female_rounded,
                      _gender == 'female',
                      Colors.pink,
                      () => setState(() => _gender = 'female'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. HEIGHT SLIDER CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'HEIGHT',
                        style: theme.textTheme.bodySmall?.copyWith(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getHeightDisplay(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.black,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: theme.colorScheme.primary,
                          inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.15),
                          thumbColor: theme.colorScheme.primary,
                          overlayColor: theme.colorScheme.primary.withOpacity(0.12),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          value: _heightCm,
                          min: 100.0,
                          max: 220.0,
                          onChanged: (val) {
                            setState(() => _heightCm = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. WEIGHT & AGE ROW
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'WEIGHT',
                              style: theme.textTheme.bodySmall?.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getWeightDisplay(),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildAdjusterBtn(Icons.remove, () => _adjustWeight(false)),
                                const SizedBox(width: 14),
                                _buildAdjusterBtn(Icons.add, () => _adjustWeight(true)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'AGE',
                              style: theme.textTheme.bodySmall?.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_age',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildAdjusterBtn(Icons.remove, () => _adjustAge(false)),
                                const SizedBox(width: 14),
                                _buildAdjusterBtn(Icons.add, () => _adjustAge(true)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 5. ACTIVITY LEVEL SELECTOR CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVITY LEVEL',
                        style: theme.textTheme.bodySmall?.copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: _activityLevel,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: _activities.map((act) {
                            return DropdownMenuItem<String>(
                              value: act['value']!,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    act['label']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    act['desc']!,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _activityLevel = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),

              // 6. CALCULATE BUTTON
              Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _calculateAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'CALCULATE BMI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitOption(String label, bool isSelected) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isMetric = (label == 'Metric');
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String label, IconData icon, bool isSelected, Color activeColor, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected 
              ? activeColor.withOpacity(0.08) 
              : (isDark ? const Color(0xFF151D2A) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? activeColor 
                : (isDark ? const Color(0xFF222F43) : Colors.grey.shade200),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 45,
              color: isSelected ? activeColor : theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 10),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isSelected ? activeColor : theme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjusterBtn(IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1724) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF222F43) : Colors.grey.shade200,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
