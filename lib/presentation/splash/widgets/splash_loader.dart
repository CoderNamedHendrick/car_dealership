import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key, this.color});
  final Color? color;

  @override
  State<SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _exhaust1Animation;
  late final Animation<double> _exhaust2Animation;
  late final Animation<double> _exhaust3Animation;
  late final Animation<double> _exhaust4Animation;
  late final Animation<Offset> _carAnim;

  static final scaleTween = Tween<double>(begin: 0, end: 1);
  late final shapeDecoration = ShapeDecoration(shape: const CircleBorder(), color: widget.color ?? Colors.black);
  static final bounceSequence = [
    TweenSequenceItem(tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)), weight: 30),
    TweenSequenceItem(tween: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero), weight: 20),
    TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 10),
    TweenSequenceItem(tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)), weight: 30),
    TweenSequenceItem(tween: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero), weight: 20),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    _carAnim = TweenSequence([
      ...bounceSequence,
      ...bounceSequence,
      ...bounceSequence,
      ...bounceSequence,
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.ease)));

    _exhaust1Animation = scaleTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.4, curve: Curves.ease),
    ));

    _exhaust2Animation = scaleTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.5, curve: Curves.easeIn),
    ));

    _exhaust3Animation = scaleTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
    ));

    _exhaust4Animation = scaleTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 0.85, curve: Curves.easeIn),
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const alignment = Alignment(0, 0.35);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: AnimatedBuilder(
        animation: _controller,
        child: Transform(
          transform: Matrix4.rotationY(pi),
          alignment: Alignment.center,
          child: FaIcon(
            FontAwesomeIcons.carSide,
            size: 32,
            color: widget.color,
          ),
        ),
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(offset: _carAnim.value, child: child!),
              const SizedBox(width: 2),
              _exhausts(),
            ],
          );
        },
      ),
    );
  }

  Widget _exhausts() {
    final exhaust1Size = _exhaust1Animation.value * 2;
    final exhaust2Size = _exhaust2Animation.value * 4;
    final exhaust3Size = _exhaust3Animation.value * 6;
    final exhaust4Size = _exhaust4Animation.value * 8;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: alignment,
          child: Container(height: exhaust1Size, width: exhaust1Size, decoration: shapeDecoration),
        ),
        Align(
          alignment: alignment,
          child: Container(height: exhaust2Size, width: exhaust2Size, decoration: shapeDecoration),
        ),
        Align(
          alignment: alignment,
          child: Container(height: exhaust3Size, width: exhaust3Size, decoration: shapeDecoration),
        ),
        Align(
          alignment: alignment,
          child: Container(height: exhaust4Size, width: exhaust4Size, decoration: shapeDecoration),
        ),
      ],
    );
  }
}
