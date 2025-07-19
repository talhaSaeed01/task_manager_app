
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/controller/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late SplashProvider splashProvider;

  @override
  void initState() {
    super.initState();
    splashProvider = Provider.of<SplashProvider>(context, listen: false);
    splashProvider.init(this, context);
  }
  

  @override
  void dispose() {
    splashProvider.disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: splashProvider.blinkController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: splashProvider.backgroundAnimation.value,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/splash_animation.json',
                  height: 220,
                  width: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                Transform.translate(
                  offset: Offset(splashProvider.shakeAnimation.value, 0),
                  child: Text(
                    'Task Manager App',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: splashProvider.textColorAnimation.value,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
