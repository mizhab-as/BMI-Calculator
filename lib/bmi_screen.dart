import 'package:flutter/material.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // Input Variables
  double? _height; // Stored in centimeters (cm)
  double? _weight; // Stored in kilograms (kg)

  // Controllers for the input fields
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    // Crucial: Clean up the controllers
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Placeholder function for Phase 3 (Logic)
  void _calculateBMI() {
    // Current placeholder logic:
    print('Calculate button pressed!');
    print('Height: $_height cm, Weight: $_weight kg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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

              // --- Height Input ---
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  hintText: 'e.g., 175',
                  prefixIcon: Icon(Icons.height),
                ),
                onChanged: (value) {
                  // Update the state variable when the text changes
                  setState(() {
                    _height = double.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 20),

              // --- Weight Input ---
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'e.g., 70.5',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                onChanged: (value) {
                  // Update the state variable when the text changes
                  setState(() {
                    _weight = double.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 50),

              // --- Calculate Button ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _calculateBMI, // Calls the placeholder function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CALCULATE BMI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
