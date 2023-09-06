import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

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

/// ExampleScaffold is scaffold for example showing
class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    required this.builder,
    this.buttons = const [],
    this.title = 'Example',
    super.key,
  });

  /// title is example title
  final String title;

  /// builder is function that will be called when button is pressed
  final Widget Function() builder;

  /// exampleButtons is list of example buttons
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: delta.ResponsiveBarView(
        barBuilder: () => delta.responsiveBar(context, title: Text(title)),
        slivers: [
          SliverFillRemaining(child: builder()),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: SingleChildScrollView(
                  child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: buttons,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
