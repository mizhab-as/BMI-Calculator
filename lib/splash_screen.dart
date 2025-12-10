import 'package:flutter/material.dart';
import 'bmi_screen.dart'; // Ensure this file exists
import 'dart:async'; // Needed for Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use a Timer to wait for a few seconds, then navigate
    Timer(const Duration(seconds: 3), () {
      // Navigate to your main BMI calculator screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BMIScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your App Logo or Text
            Text(
              'BMI Calculator',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Optional loading indicator
          ],
        ),
      ),
    );
  }
}
