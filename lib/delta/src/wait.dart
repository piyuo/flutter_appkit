import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// Wait future to complete, show busy if it takes long time
///
class Wait<T> extends StatelessWidget {
  const Wait({
    Key? key,
    required this.waitFor,
    required this.builder,
  }) : super(key: key);

  final Future<T?> Function() waitFor;

  /// builder to create result
  final Widget Function(BuildContext context, T? value) builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_WaitProvider<T>>(
        create: (context) => _WaitProvider<T>(waitFor),
        child: Consumer<_WaitProvider<T>>(
            builder: (context, provide, child) => FutureBuilder(
                future: provide.future, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<T?> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: Icon(
                        Icons.access_time,
                        size: 128,
                        color: context.themeColor(
                          light: Colors.grey.shade300,
                          dark: Colors.grey.shade800,
                        ),
                      ),
                    );
                  } else if (provide.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 120,
                        ),
                        const SizedBox(height: 10),
                        AutoSizeText(
                          context.i18n.errorTitle,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AutoSizeText(
                          '${provide.error}',
                          maxLines: 5,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 40,
                            ),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(
                                  color: Colors.red,
                                )),
                          ),
                          onPressed: () => provide.reload(),
                          child: Text(context.i18n.tapToRetryButtonText,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    );
                  }
                  return builder(context, snapshot.data);
                })));
  }
}

class _WaitProvider<T> with ChangeNotifier {
  _WaitProvider(this.func) {
    reload();
  }

  final Future<T?> Function() func;

  Future<T?>? future;

  dynamic error;

  /// hasError return true if error is not null
  bool get hasError => error != null;

  void reload() {
    error = null;
    future = () async {
      try {
        return await func();
      } catch (e) {
        // don't throw error, FutureBuilder not handle it correctly, it failed at second try
        error = e;
      }
    }();
    notifyListeners();
  }
}
