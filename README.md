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
