// splash_provider.dart

import 'package:flutter/material.dart';
import 'package:task_manager_app/view/home_screen.dart';

class SplashProvider extends ChangeNotifier {
  late AnimationController shakeController;
  late AnimationController blinkController;

  late Animation<double> shakeAnimation;
  late Animation<Color?> backgroundAnimation;
  late Animation<Color?> textColorAnimation;

  void init(TickerProvider vsync, BuildContext context) {
    shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: shakeController, curve: Curves.elasticIn),
    );
    shakeController.repeat(reverse: true);

    blinkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    backgroundAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.grey[700],
    ).animate(CurvedAnimation(parent: blinkController, curve: Curves.easeInOut));

    textColorAnimation = ColorTween(
      begin: Colors.indigo,
      end: Colors.orangeAccent,
    ).animate(CurvedAnimation(parent: blinkController, curve: Curves.easeInOut));

    blinkController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 6), () {
      shakeController.stop();
      blinkController.stop();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  void disposeAnimations() {
    shakeController.dispose();
    blinkController.dispose();
  }
}
