import 'package:flutter/material.dart';
import 'package:trial1/bmi_record.dart';
import 'package:trial1/storage_service.dart';
import 'package:trial1/widgets/gauge_painter.dart';

class ResultScreen extends StatefulWidget {
  final BmiRecord record;

  const ResultScreen({super.key, required this.record});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaved = false;

  String get _bmiCategory {
    final bmi = widget.record.bmi;
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Healthy Weight';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  Color get _categoryColor {
    final bmi = widget.record.bmi;
    if (bmi < 18.5) return const Color(0xFF2B6CB0);  // Sapphire
    if (bmi < 25.0) return const Color(0xFF1B4D3E);  // Forest Green
    if (bmi < 30.0) return const Color(0xFFB7791F);  // Amber Gold
    return const Color(0xFF9B2C2C);                  // Burgundy
  }

  String get _imagePath {
    final bmi = widget.record.bmi;
    if (bmi < 18.5) return 'assets/images/under.png';
    if (bmi < 25.0) return 'assets/images/good.png';
    if (bmi < 30.0) return 'assets/images/bad.png';
    return 'assets/images/obese.png';
  }

  String get _adviceText {
    final bmi = widget.record.bmi;
    if (bmi < 18.5) {
      return 'Focus on nutrient-dense foods, healthy fats, and progressive strength training to build lean muscle mass.';
    } else if (bmi < 25.0) {
      return 'Great job! Maintain your current routine by balancing a nutritious diet with regular cardio and physical exercise.';
    } else if (bmi < 30.0) {
      return 'Incorporate more daily movement, monitor portion sizes, and aim for 150 minutes of moderate activity weekly.';
    } else {
      return 'Prioritize a health-focused meal plan and safe cardiovascular exercise. Consulting a doctor is highly recommended.';
    }
  }

  String _getBodyFatStatus(double bfp, String gender) {
    if (gender.toLowerCase() == 'male') {
      if (bfp < 6.0) return 'Low';
      if (bfp <= 13.0) return 'Athlete';
      if (bfp <= 17.0) return 'Fit';
      if (bfp <= 24.0) return 'Average';
      return 'High';
    } else {
      if (bfp < 14.0) return 'Low';
      if (bfp <= 20.0) return 'Athlete';
      if (bfp <= 24.0) return 'Fit';
      if (bfp <= 31.0) return 'Average';
      return 'High';
    }
  }

  Future<void> _saveReport() async {
    if (_isSaved) return;
    await StorageService.saveRecord(widget.record);
    setState(() {
      _isSaved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Report saved to history successfully!'),
        backgroundColor: Colors.emerald.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Ideal weight bounds based on WHO standards (18.5 to 24.9 BMI)
    final hM = widget.record.height / 100.0;
    final double minIdeal = 18.5 * (hM * hM);
    final double maxIdeal = 24.9 * (hM * hM);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. DYNAMIC NEEDLE GAUGE CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      BmiGauge(bmi: widget.record.bmi),
                      const SizedBox(height: 15),
                      Text(
                        _bmiCategory.toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.black,
                          color: _categoryColor,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'BMI = ${widget.record.bmi.toStringAsFixed(1)}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. HEALTH & WELLNESS METRICS GRID
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.25,
                children: [
                  _buildMetricCard(
                    theme,
                    'Body Fat %',
                    '${widget.record.bodyFat.toStringAsFixed(1)}%',
                    _getBodyFatStatus(widget.record.bodyFat, widget.record.gender),
                    Icons.bubble_chart_rounded,
                    Colors.cyan,
                  ),
                  _buildMetricCard(
                    theme,
                    'Ideal Weight',
                    '${minIdeal.toStringAsFixed(1)}-${maxIdeal.toStringAsFixed(1)}',
                    'kg',
                    Icons.monitor_weight_outlined,
                    Colors.emerald,
                  ),
                  _buildMetricCard(
                    theme,
                    'BMR (Rest)',
                    '${widget.record.bmr.round()}',
                    'kcal / day',
                    Icons.local_fire_department_rounded,
                    Colors.orange,
                  ),
                  _buildMetricCard(
                    theme,
                    'TDEE (Active)',
                    '${widget.record.tdee.round()}',
                    'kcal / day',
                    Icons.bolt_rounded,
                    Colors.indigo,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. RECOMMENDATION CARD WITH EMBEDDED GRAPHIC
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Render asset image
                      Image.asset(
                        _imagePath,
                        height: 75,
                        width: 75,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HEALTH SUGGESTIONS',
                              style: theme.textTheme.bodySmall?.copyWith(
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: _categoryColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _adviceText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),

              // 4. ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('RE-CALCULATE'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: _isSaved
                            ? null
                            : LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                              ),
                        color: _isSaved ? Colors.grey.shade700 : null,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isSaved ? null : _saveReport,
                        icon: Icon(_isSaved ? Icons.check_circle : Icons.save_rounded, color: Colors.white),
                        label: Text(
                          _isSaved ? 'SAVED' : 'SAVE REPORT',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    ThemeData theme,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color accentColor,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                Icon(icon, color: accentColor, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
