import 'dart:async';

import 'package:flutter/material.dart';

import '../main/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _opacity;

  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _scale = Tween(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    Timer(
      const Duration(seconds: 2),
          () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration:
            const Duration(milliseconds: 600),
            settings: const RouteSettings(
              name: "/",
            ),
            pageBuilder:
                (_, animation, __) =>
                FadeTransition(
                  opacity: animation,
                  child: const MainPage(),
                ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xff0B0B0F),

      body: SizedBox.expand(
        child: FadeTransition(
          opacity: _opacity,
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset(
              'lib/assets/image/startup.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}