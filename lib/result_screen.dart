import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double bmiResult;

  const ResultScreen({super.key, required this.bmiResult});

  // Helper function to determine the category
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

  // NEW: Helper function to determine the image asset path
  String get _imagePath {
    if (bmiResult < 18.5) {
      return 'assets/images/under.png';
    } else if (bmiResult >= 18.5 && bmiResult <= 24.9) {
      return 'assets/images/good.png'; // Path for Healthy Image
    } else if (bmiResult >= 25.0 && bmiResult <= 29.9) {
      return 'assets/images/bad.png'; // Path for Overweight Image
    } else {
      return 'assets/images/obese.png';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your BMI Result'),
        centerTitle: true,
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
              // 1. ADD THE IMAGE HERE
              // Check if the image path is valid and display the image
              Image.asset(
                _imagePath, // Uses the helper getter to select the correct image
                height: 150, // Set a fixed height for visual consistency
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),

              // Display the Category
              Text(
                _bmiCategory,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  // Use a distinct color for the category text
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Display the Calculated BMI Value
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(
                    0.1,
                  ), // Subtle background for the number
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  bmiResult.toStringAsFixed(
                    1,
                  ), // Show result with 1 decimal place
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Display the Description
              Text(
                _description,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
