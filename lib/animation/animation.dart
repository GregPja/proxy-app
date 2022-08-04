import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedClimber extends StatefulWidget {
  const AnimatedClimber({super.key});

  @override
  State<AnimatedClimber> createState() => _AnimatedClimberState();
}

class _AnimatedClimberState extends State<AnimatedClimber> with SingleTickerProviderStateMixin {
  late Animation<double> upDown;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 7), vsync: this)
          ..addListener(() {
            setState(() {});
          });
    final Animation<double> curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    upDown = Tween<double>(begin: 350, end: -300).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addStatusListener((status) => print('$status'));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLogo(animation: upDown);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedLogo extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedLogo({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 150,
            width: 150,
            child: Transform.translate(
                offset: Offset(0, animation.value),
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(
                        (animation.value % 100) > 49 ? math.pi : 0),
                    child: Image.asset("assets/animation_logo.png")))));
  }
}
