import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/types/types.dart' as types;
import 'location.dart';

class LocateTextProvider with ChangeNotifier {
  LocateTextProvider({
    required this.controller,
  }) {
    controller.addListener(onControllerChanged);
  }

  /// controller is text edit field controller
  final TextEditingController controller;

  @override
  void dispose() {
    controller.removeListener(onControllerChanged);
    super.dispose();
  }

  /// _confirmButtonChange trigger when confirm button need show or hide
  onControllerChanged() {
    notifyListeners();
  }
}

/// LocateTextField can show locate me dropdown menu
class LocateTextField extends StatelessWidget {
  const LocateTextField({
    required this.controller,
    required this.focusNode,
    required this.onUseMyLocation,
    required this.onSubmitted,
    this.decoration = const InputDecoration(),
    this.suggestionsBuilder,
    Key? key,
  }) : super(key: key);

  /// focusNode control focus
  final FocusNode focusNode;

  /// controller is text edit field controller
  final TextEditingController controller;

  /// decoration is text edit field decoration
  final InputDecoration decoration;

  /// suggestionsBuilder used when text is not empty, return suggestions
  final AutocompleteOptionsBuilder<String>? suggestionsBuilder;

  /// onUseMyLocation called when user click use my location and pass latlng
  final void Function(types.LatLng value) onUseMyLocation;

  /// onSubmitted call when user submit search text
  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => ChangeNotifierProvider<LocateTextProvider>(
            create: (context) => LocateTextProvider(controller: controller),
            child: Consumer<LocateTextProvider>(
                builder: (context, locateTextProvider, child) => RawAutocomplete<String>(
                      textEditingController: controller,
                      focusNode: focusNode,
                      initialValue: null,
                      fieldViewBuilder:
                          (BuildContext context, TextEditingController c, FocusNode f, VoidCallback onFieldSubmitted) {
                        return TextField(
                          controller: c,
                          focusNode: f,
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.search,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 18),
                          decoration: decoration.copyWith(
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: c.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      focusNode.unfocus();
                                      c.clear();
                                      onSubmitted('');
                                      //onFieldSubmitted(); // do not use onFieldSubmitted, it won't clear text
                                    },
                                  ),
                            label: const Text('Zip or City & State'),
                            hintText: "Search by Zip or City & State",
                          ),
                          onSubmitted: (_) => onFieldSubmitted(),
                          onTapOutside: (_) {
                            if (controller.text.isEmpty) {
                              focusNode.unfocus();
                            }
                          },
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) async {
                        if (textEditingValue.text.isEmpty) {
                          return const [''];
                        }
                        return suggestionsBuilder != null ? suggestionsBuilder!(textEditingValue) : [];
                      },
                      optionsViewBuilder:
                          (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                        return Stack(
                          // put list view inside stack, so we can use Positioned to set width
                          children: [
                            Positioned(
                                top: 1,
                                left: 0,
                                width: constraints.maxWidth,
                                height: (52 * options.length.toDouble()) + 20,
                                child: Material(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    elevation: 4.0,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                                      itemCount: controller.text.isEmpty ? 1 : options.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        if (controller.text.isEmpty) {
                                          return ListTile(
                                            title: const Text('Use my current location'),
                                            leading: const Icon(Icons.near_me),
                                            onTap: () async {
                                              focusNode.unfocus();
                                              final latLng = await deviceLatLng();
                                              if (!latLng.isEmpty) {
                                                onUseMyLocation(latLng);
                                              }
                                            },
                                          );
                                        }

                                        final String option = options.elementAt(index);
                                        return ListTile(
                                          title: Text(option),
                                          onTap: () => onSelected(option),
                                        );
                                      },
                                    )))
                          ],
                        );
                      },
                      onSelected: (result) {
                        focusNode.unfocus();
                        onSubmitted(result);
                      },
                    ))));
  }
}
