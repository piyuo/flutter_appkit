import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slide_countdown/slide_countdown.dart';

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
