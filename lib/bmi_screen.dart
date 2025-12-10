import 'package:flutter/material.dart';

// 1.3 Home Screen Scaffold (StatefulWidget)
class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // 1.4 Input Variables
  // Use 'double?' to indicate that the values can initially be null (no input yet)
  double? _height; // Stored in centimeters (cm)
  double? _weight; // Stored in kilograms (kg)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator'), centerTitle: true),
      // The body is currently empty, ready for Phase 2
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              // This is where we will add the TextFields in Phase 2
              Text(
                'Enter your details below to calculate your BMI.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 40),
              // Placeholder for Height Input (Phase 2)
              // Placeholder for Weight Input (Phase 2)
              // Placeholder for Calculate Button (Phase 2)
            ],
          ),
        ),
      ),
    );
  }
}
