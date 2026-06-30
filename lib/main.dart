import 'package:flutter/material.dart';
import 'package:trial1/splash_screen.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // "Old Money" Luxury Color Scheme: Antique Gold, Forest Green, Ivory & AMOLED Black
    const primaryGold = Color(0xFFC5A880);      // Antique Gold
    const secondaryGreen = Color(0xFF1B4D3E);   // British Racing Green
    const amoledBg = Color(0xFF000000);         // Pure AMOLED Black
    const luxuryCardBg = Color(0xFF0C0E12);     // Soft metallic charcoal surface
    const luxuryBorder = Color(0xFF1F242D);     // Subtle bronze-grey border
    const ivoryWhite = Color(0xFFF9F6F0);       // Warm Ivory Text

    return MaterialApp(
      title: 'Smart BMI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Respect system settings

      // 1. Light Theme (Old Money Editorial Vibe)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: secondaryGreen,
          brightness: Brightness.light,
          primary: secondaryGreen,
          secondary: primaryGold,
          surface: const Color(0xFFFAF9F6), // Ivory paper
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F1EA), // Linen paper background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF1B241D),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1B241D)),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFFFAF9F6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5DFD3), width: 1.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFAF9F6),
          labelStyle: const TextStyle(color: secondaryGreen, fontWeight: FontWeight.w600),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDED6C4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: secondaryGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: secondaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      // 2. Dark Theme (AMOLED Quiet Luxury Vibe)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGold,
          brightness: Brightness.dark,
          primary: primaryGold,
          secondary: secondaryGreen,
          surface: luxuryCardBg,
          onSurface: ivoryWhite,
          outline: luxuryBorder,
        ),
        scaffoldBackgroundColor: amoledBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: ivoryWhite,
            fontSize: 22,
            fontWeight: FontWeight.w850,
            letterSpacing: 1.0,
          ),
          iconTheme: IconThemeData(color: ivoryWhite),
        ),
        cardTheme: CardTheme(
          color: luxuryCardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: luxuryBorder, width: 1.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF050608),
          labelStyle: const TextStyle(color: primaryGold, fontWeight: FontWeight.w600),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: luxuryBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryGold, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryGold,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
