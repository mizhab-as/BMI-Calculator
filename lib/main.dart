import 'package:flutter/material.dart';
import 'bmi_screen.dart'; // We will create this file next

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // --- Black & White Theme ---
        brightness: Brightness.dark, // Default to a dark background
        primaryColor: Colors.grey.shade900, // Very dark gray/black
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.dark(
          primary: Colors.white, // Used for active elements like labels
          secondary:
              Colors.tealAccent, // A subtle accent for buttons (optional)
          surface: Colors.grey.shade800, // Background for Cards/Containers
        ),
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade900, // Dark AppBar
          elevation: 0, // Flat design
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // --- Input Field Styling ---
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        // --- Text Color ---
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          // Set a default style for the entire app body
        ),
      ),
      home: const BMIScreen(),
    );
  }
}
