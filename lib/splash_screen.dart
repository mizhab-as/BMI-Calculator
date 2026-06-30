import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trial1/bmi_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set up pulse animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.15).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();

    // Loop the pulse effect subtly after initial entry
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat(reverse: true);
      }
    });

    // Wait for 3 seconds then navigate
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const BMIScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: isDark
                ? [
                    const Color(0xFF1E293B), // Soft slate blue center
                    const Color(0xFF090D16), // Dark background edges
                  ]
                : [
                    const Color(0xFFE2F1F0), // Soft teal center
                    const Color(0xFFF1F5F9), // Light background edges
                  ],
            radius: 1.2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Glowing Pulse Icon
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                blurRadius: 40 * _animationController.value,
                                spreadRadius: 10 * _animationController.value,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 65,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // App Title
                Text(
                  'SMART BMI',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.black,
                    letterSpacing: 3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                // Tagline
                Text(
                  'YOUR WELLNESS ECOSYSTEM',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 60),

                // Premium thin loading spinner
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom brand label
            Positioned(
              bottom: 30,
              child: Text(
                'TRACK • ANALYZE • IMPROVE',
                style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.5,
                  color: isDark ? Colors.white30 : Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
