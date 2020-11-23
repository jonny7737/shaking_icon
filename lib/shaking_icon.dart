library shaking_icon;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ShakingIcon extends StatefulWidget {
  ///
  /// Icon to shake - This can be either an IconData object
  /// or a String assetName for an AssetImage.
  final dynamic icon;

  /// Size parameter passed to Icon constructor
  final double size;

  /// Function to determine shake flag from outside this class
  /// This function takes precedence over shake flag
  final Function shakeIt;

  /// Enable / Disable shake flag to support dynamic UI
  /// Default is true
  final bool shake;

  /// Color parameter passed to Icon constructor
  final Color color;

  /// Horizontal shake.  Default to Horizontal shake
  final bool horizontalShake;

  /// Diagonal shake if horizontalShake && verticalShake = true

  /// Vertical shake.  Default to Horizontal shake
  final bool verticalShake;

  /// Frequency to repeat the shake in seconds
  final int secondsToRepeat;

  /// Example usages:
  /// ```dart
  ///     ShakingIcon(Icons.verified_user, size: 32,
  ///                 shakeIt: (bool shake){
  ///                   if(shake) return true;
  ///                   return false;
  ///                 }),
  ///     ShakingIcon('assets/003-pointer.png', color: Colors.black,
  ///                 horizontalShake: false, shake: false),
  /// ```
  ///
  ShakingIcon(
    this.icon, {
    this.size = 36,
    this.shakeIt,
    this.shake = true,
    this.color,
    this.horizontalShake = true,
    this.verticalShake = false,
    this.secondsToRepeat,
  });

  @override
  _ShakingIconState createState() => _ShakingIconState();
}

class _ShakingIconState extends State<ShakingIcon> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Timer timer;
  final Random rng = Random();
  dynamic child;

  @override
  Widget build(BuildContext context) {
    if (widget.icon.runtimeType == IconData)
      child = Icon(widget.icon, size: widget.size, color: widget.color);
    else if (widget.icon.runtimeType == String) {
      child = ImageIcon(AssetImage(widget.icon), size: widget.size, color: widget.color);
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (_, child) {
        return Transform(
          transform: Matrix4.translation(_shake()),
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    if (shakeIt()) likeAPolaroidCamera();
  }

  int nextRndInt({int min = 0, @required int max}) => min + rng.nextInt(max - min);

  bool shakeIt() {
    if (widget.shakeIt != null) return widget.shakeIt(widget.shake);
    return widget.shake;
  }

  void likeAPolaroidCamera() {
    if (shakeIt()) {
      waitForIt();
      if (widget.secondsToRepeat != null)
        timer = Timer.periodic(Duration(seconds: widget.secondsToRepeat), (_) {
          if (shakeIt()) waitForIt();
        });
    }
  }

  void waitForIt() {
    /// Random delay between 0.5 and 5 seconds.
    Future.delayed(Duration(milliseconds: nextRndInt(min: 1, max: 10) * 500)).then((_) {
      if (!mounted) return;
      animationController.reset();
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Vector3 _shake() {
    /// 10.0 is the number of oscillations (how many wiggles)
    ///  8.0 is how wide is your wiggle
    final double offset = sin(animationController.value * pi * 10.0) * 8;
    final double xOffset = widget.horizontalShake ? offset : 0.0;
    final double yOffset = widget.verticalShake ? offset : 0.0;
    return Vector3(xOffset, yOffset, 0.0);
  }
}
