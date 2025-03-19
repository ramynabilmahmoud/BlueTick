import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SplashScreen({super.key, required this.onAnimationComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _controller.forward().then((_) {
      // Wait a bit after animation completes
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onAnimationComplete();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with fade-in and scale animation
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SvgPicture.asset(
                      'assets/images/app_logo.svg',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // App name with fade-in animation
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Text(
                    'BlueTick',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Animated loader
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white.withAlpha(200),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
