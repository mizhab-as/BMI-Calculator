import 'package:flutter/material.dart';
import 'package:trial1/splash_screen.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  // Define your brand color (used to generate a harmonious scheme)
  static const MaterialColor primaryBrandColor =
      Colors.teal; // A calming, health-related color

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,

      // Use ThemeMode.system so it respects the device's setting (Light/Dark)
      themeMode: ThemeMode.system,

      // 1. Light Theme Definition (Best Practice to include for system mode)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBrandColor,
          brightness: Brightness.light,
        ),
        // Define input field styling for the light theme
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: primaryBrandColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Add rounded corners
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryBrandColor, width: 2),
          ),
        ),
      ),

      // 2. Dark Theme Definition (The one you initially focused on)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // Use the same seed color to ensure consistency, but set brightness to dark
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBrandColor,
          brightness: Brightness.dark,
          // You can override specific colors for extra contrast in Dark Mode:
          surface: Colors.grey.shade900,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor:
            Colors.black, // Pure black background for high contrast

        appBarTheme: const AppBarTheme(
          color: Colors.black, // App bar matches scaffold background
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Define input field styling for the dark theme
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: primaryBrandColor.shade200),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ), // Consistent rounded corners
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryBrandColor, width: 2),
          ),
        ),

        // Button style for a modern look
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                primaryBrandColor, // Use the primary color for buttons
            foregroundColor: Colors.white, // White text on primary button
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
