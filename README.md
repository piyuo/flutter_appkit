# LibCLI

A robust Flutter foundation library that provides essential application infrastructure including error handling, global context management, logging, and internationalization support.

## Features

- **Error Handling**: Comprehensive error catching and reporting mechanism
- **Global Context**: Centralized application context management
- **Logging**: Built-in logging system for debugging and monitoring
- **Internationalization**: Language file support for multi-language applications
- **Zero Configuration**: Drop-in replacement for Flutter's `runApp()`

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  libcli:
    git:
      url: https://github.com/piyuo/libcli.git
```

## Quick Start

Replace your existing `runApp()` call with `run()`:

```dart
import 'package:libcli/libcli.dart';

void main() {
  run(() => MyApp());
}
```

### With Custom Error Handling

```dart
void main() {
  run(
    () => MyApp(),
    alertUser: (error) {
      // Custom error handling logic
      // Return true to show default alert, false to handle silently
      return true;
    },
  );
}
```

## API Reference

### `run(Function suspect, {bool Function(dynamic)? alertUser})`

Initializes and runs your Flutter application with enhanced error handling and global context support.

**Parameters:**
- `suspect`: Function that returns your app widget (typically `() => MyApp()`)
- `alertUser`: Optional callback for custom error handling. Returns `bool` to indicate whether to show default error alert.

## Requirements

- Flutter SDK 3.0+
- Dart 3.0+

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please use the [GitHub Issues](https://github.com/piyuo/libcli/issues) page.