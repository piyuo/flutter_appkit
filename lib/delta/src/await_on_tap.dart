import 'package:flutter/material.dart';

/// AwaitOnTap use await to execute on tap function and prevent other tap
class AwaitOnTap extends StatefulWidget {
  const AwaitOnTap({
    Key? key,
    required this.child,
    required this.onAwaitTap,
  }) : super(key: key);
  final Widget child;
  final Future Function() onAwaitTap;

  @override
  AwaitOnTapState createState() => AwaitOnTapState();
}

class AwaitOnTapState extends State<AwaitOnTap> {
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (_running) {
            return;
          }
          setState(() {
            _running = true;
          });

          try {
            await widget.onAwaitTap();
          } finally {
            setState(() {
              _running = false;
            });
          }
        },
        child: _running
            ? Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: const IconThemeData(
                    color: Colors.grey,
                  ),
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.grey),
                  child: widget.child,
                ),
              )
            : widget.child);
  }
}
