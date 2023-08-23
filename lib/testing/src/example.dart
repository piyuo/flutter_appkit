import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// ExampleButton is button that will navigate to example builder
/// ```dart
/// ExampleButton(
///  label: 'example1',
///  builder: ()=>Container(),
///  )
/// ```
class ExampleButton extends StatelessWidget {
  /// ExampleButton is button that will navigate to example builder
  /// ```dart
  /// ExampleButton(
  ///  label: 'example1',
  ///  builder: ()=>Container(),
  ///  )
  /// ```
  const ExampleButton({
    Key? key,
    required this.label,
    required this.builder,
    this.useScaffold = true,
  }) : super(key: key);

  /// label is button label
  final String label;

  /// builder is function that will be called when button is pressed
  final Widget Function() builder;

  /// useScaffold is true if you want to use scaffold
  final bool useScaffold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
          child: Text(label),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => useScaffold
                    ? Scaffold(
                        body: delta.ResponsiveBarView(
                          barBuilder: () => delta.responsiveBar(context),
                          slivers: [
                            SliverToBoxAdapter(child: builder()),
                          ],
                        ),
                      )
                    : builder(),
              ))),
    );
  }
}
