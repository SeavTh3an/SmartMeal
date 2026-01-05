import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for fade in effect
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller (1 second duration)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Fade animation from 0 (transparent) to 1 (fully visible)
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the fade in animation
    _controller.forward();

    // Auto navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      //Check if the widget is still in the tree
      if (!mounted) return;

      // Navigate to main screen
      Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  void dispose() {
    // Dispose animation controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFCBF4B1), // Light green
              Color(0xFF608D43), // Dark green
            ],
          ),
        ),
        // Centered content
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/image/logo.png', 
              width: 350,
            ),
          ),
        ),
      ),
    );
  }
}
