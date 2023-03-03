import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'dart:async';

class CountDown extends StatelessWidget {
  const CountDown({
    required this.duration,
    this.onDone,
    Key? key,
  }) : super(key: key);

  final Duration duration;

  final void Function()? onDone;

  @override
  Widget build(BuildContext context) {
    return SlideCountdown(
      onDone: onDone,
      duration: duration,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.red[400],
      ),
    );
  }
}

class CountUp extends StatefulWidget {
  const CountUp({
    this.greenLight = 300,
    this.yellowLight = 600,
    Key? key,
  }) : super(key: key);

  final int greenLight;

  final int yellowLight;

  @override
  CountUpState createState() => CountUpState();
}

enum Light { green, yellow, red }

class CountUpState extends State<CountUp> {
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


    /*if (_expired) {
      return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              )),
          child: const Text(
            'Expired',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
          ));
    }*/
