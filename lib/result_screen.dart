import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  // 4.1 Accept the calculated BMI as a required parameter
  final double bmiResult;

  const ResultScreen({super.key, required this.bmiResult});

  // Helper function to determine the category and description (4.2 Category Logic)
  String get _bmiCategory {
    if (bmiResult < 18.5) {
      return 'Underweight';
    } else if (bmiResult >= 18.5 && bmiResult <= 24.9) {
      return 'Healthy Weight';
    } else if (bmiResult >= 25.0 && bmiResult <= 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  // Helper function to provide a description
  String get _description {
    if (bmiResult < 18.5) {
      return 'You are in the Underweight range. It may be beneficial to consult a healthcare provider.';
    } else if (bmiResult >= 18.5 && bmiResult <= 24.9) {
      return 'You are in the Healthy Weight range. Great job!';
    } else if (bmiResult >= 25.0 && bmiResult <= 29.9) {
      return 'You are in the Overweight range. Consider incorporating more physical activity.';
    } else {
      return 'You are in the Obese range. Consulting a healthcare provider is recommended.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4.3 Result UI Design
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your BMI Result'),
        centerTitle: true,
        // Add a back button for easy navigation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the Category
              Text(
                _bmiCategory,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary, // Uses the accent color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Display the Calculated BMI Value
              Text(
                bmiResult.toStringAsFixed(
                  1,
                ), // Show result with 1 decimal place
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Display the Description
              Text(
                _description,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
