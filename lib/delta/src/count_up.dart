import 'dart:async';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CountUp extends StatefulWidget {
  const CountUp({
    this.greenLight = 300,
    this.yellowLight = 600,
    Key? key,
  }) : super(key: key);

  final int greenLight;

  final int yellowLight;

  @override
  _CountUpState createState() => _CountUpState();
}

enum Light { green, yellow, red }

class _CountUpState extends State<CountUp> {
  @override
  void initState() {
    begin = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), _check);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  late Timer timer;

  late DateTime begin;

  Light light = Light.green;

  void _check(Timer timer) {
    final now = DateTime.now();
    final diff = now.difference(begin);
    if (diff.inSeconds <= widget.greenLight) {
      setState(() {
        light = Light.green;
      });
      return;
    }
    if (diff.inSeconds <= widget.yellowLight) {
      setState(() {
        light = Light.yellow;
      });
      return;
    }
    setState(() {
      light = Light.red;
    });
  }

  Color _getColor() {
    switch (light) {
      case Light.green:
        return Colors.green.shade400;
      case Light.yellow:
        return Colors.yellow.shade700;
      case Light.red:
        return Colors.red.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideCountdown(
      countUp: true,
      infinityCountUp: true,
      duration: Duration.zero,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: _getColor(),
      ),
    );
  }
}
