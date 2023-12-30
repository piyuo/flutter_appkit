import 'package:flutter/material.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;

/// ExampleButton is button that will navigate to example builder
class ExampleButton extends StatelessWidget {
  /// ```dart
  /// ExampleButton('example1',builder: testFunc)
  /// ```
  const ExampleButton(
    this.label, {
    required this.builder,
    this.useScaffold = true,
    super.key,
  });

  /// label is button label
  final String label;

  /// builder is function that will be called when button is pressed
  final Widget Function(BuildContext) builder;

  /// useScaffold is true if you want to use scaffold
  final bool useScaffold;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(label),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => useScaffold
                  ? Scaffold(
                      appBar: AppBar(toolbarHeight: apollo.barHeight),
                      body: SingleChildScrollView(
                        child: builder(context),
                      ))
                  : builder(context),
            )));
  }
}

/// ExampleScaffold is scaffold for example showing
class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    required this.builder,
    this.buttons = const [],
    this.appBar,
    super.key,
  });

  /// builder is function that will be called when button is pressed
  final Widget Function(BuildContext) builder;

  /// exampleButtons is list of example buttons
  final List<Widget> buttons;

  /// appBar is app bar for example
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            Expanded(child: builder(context)),
            Container(
              color: colorScheme.primaryContainer,
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 70,
              child: SingleChildScrollView(
                  child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: buttons,
              )),
            ),
          ],
        ));
  }
}
