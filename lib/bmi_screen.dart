import 'package:flutter/material.dart';
import 'result_screen.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // New: GlobalKey for Form management (5.2 Robustness)
  final _formKey = GlobalKey<FormState>();

  // Input Variables
  double? _height;
  double? _weight;

  // Controllers are still useful for initial values/clearing, but less critical for validation now
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmiResult;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Helper function remains the same
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _calculateBMI() {
    // 5.2 Validation: Use the Form key to trigger validation checks
    if (_formKey.currentState!.validate()) {
      // If validation passes, save the form state (which runs the onSaved callback)
      _formKey.currentState!.save();

      // Height is guaranteed to be non-null and positive here due to the validator

      // Step 1: Convert Height from Centimeters (cm) to Meters (m)
      final double heightInMeters = _height! / 100;

      // Step 2: Calculate BMI
      _bmiResult = _weight! / (heightInMeters * heightInMeters);

      // 4.4 Navigation
      if (_bmiResult != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(bmiResult: _bmiResult!),
          ),
        );
      }
    } else {
      // If validation fails (e.g., user leaves a field blank)
      _showErrorSnackBar('Please fix the errors in the input fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // 5.2 Wrap the Column in a Form widget
          child: Form(
            key: _formKey, // Attach the GlobalKey
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Enter your details below to calculate your BMI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // --- Height Input: Now a TextFormField ---
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)', // 5.3 Clear unit label
                    hintText: 'e.g., 175',
                    prefixIcon: Icon(Icons.height),
                  ),
                  // New: Validator function (5.2 Robustness)
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Height is required.';
                    }
                    if (double.tryParse(value) == null ||
                        double.tryParse(value)! <= 0) {
                      return 'Please enter a valid positive number.';
                    }
                    return null; // Return null if input is valid
                  },
                  // New: onSaved takes precedence for final value assignment
                  onSaved: (value) {
                    _height = double.tryParse(value!);
                  },
                ),
                const SizedBox(height: 20), // 5.1 Spacing
                // --- Weight Input: Now a TextFormField ---
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)', // 5.3 Clear unit label
                    hintText: 'e.g., 70.5',
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  // New: Validator function (5.2 Robustness)
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Weight is required.';
                    }
                    if (double.tryParse(value) == null ||
                        double.tryParse(value)! <= 0) {
                      return 'Please enter a valid positive number.';
                    }
                    return null; // Return null if input is valid
                  },
                  // New: onSaved takes precedence for final value assignment
                  onSaved: (value) {
                    _weight = double.tryParse(value!);
                  },
                ),
                const SizedBox(height: 50), // 5.1 Spacing
                // --- Calculate Button ---
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    // calls the updated function which validates the Form
                    onPressed: _calculateBMI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'CALCULATE BMI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
