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
      ref: v2.0.0
```

## Quick Start

Replace your existing `runApp()` call with `run()`:

```dart
import 'package:libcli/libcli.dart';

void main() {
  run(() => MyApp());
}
```

## 🧰 Tech Stack

- **Flutter (Stable Channel, e.g., 3.x.x):**: Core UI framework for cross-platform mobile, web, and desktop development.
- **Riverpod / Provider**: For simple and scalable state management, we use provider in our old code but we are replacing provider to riverpod.
- **mockito**:LFor creating mock objects in tests.
- **flutter_lints**:Recommended set of lints for Flutter projects to enforce best practices and code consistency.
- **Firebase**:A comprehensive mobile and web application development platform by Google.
  - **Crashlytics**:For real-time crash reporting and insightful analytics to help prioritize and fix stability issues.
  - **Cloud Messaging (FCM)**:FFor sending notifications across platforms.

## 🛠️ Development Tools

These tools are used to support local development, collaboration, and testing:

- Visual Studio Code – Recommended code editor with official Next.js and Tailwind CSS extensions.
- Flutter SDK - The software development kit itself, including the Dart SDK, Flutter framework, command-line tools (flutter doctor, flutter run, flutter build), and engine for compiling and running applications across platforms.
- Git – Version control for managing source code.
- GitHub CLI (gh) – Streamlines GitHub workflows (issues, pull requests, etc.).
- Android Studio – Used for advanced Android-specific debugging, emulators, and device management. .
- Xcode –  Essential for iOS development, simulators, device provisioning, and debugging on Apple platforms.
- Postman –  For API testing and development, crucial when interacting with backend services.

## ✅ Best Practices to Follow

These practices guide our development to ensure code quality, maintainability, performance, and scalability.

- We are **migrating from Provider to Riverpod** for improved scalability and testability.
- **Follow the Effective Dart Style Guide:** Adhere to Dart's official style guide for consistent formatting, naming conventions (e.g., `UpperCamelCase` for classes, `lowerCamelCase` for variables), and code structure. This is enforced via `flutter_lints` and `dart format`.
- **Embrace Widget Composition over Inheritance:** Favor composing smaller, reusable widgets to build complex UIs. This leads to cleaner code, better performance, and easier testing compared to deep inheritance hierarchies.
- **Optimize Widget Rebuilds:**
  - **Use `const` constructors whenever possible:** For immutable widgets, using `const` allows Flutter to perform significant optimizations by reusing widget instances and preventing unnecessary rebuilds.
  - **Keep `build` methods pure and lean:** Avoid complex logic, heavy computations, or network calls directly within `build` methods, as they can run frequently. Delegate such operations to state management solutions or lifecycle methods.
  - **Minimize `setState()` scope:** Use `setState()` sparingly and only for the smallest possible widget subtree that needs to update. Prefer robust state management solutions (like Provider, BLoC, Riverpod) for broader or more complex state changes.
- **Provider:** Utilize `Provider` (or your chosen state management solution) for managing application state, ensuring clear separation of concerns between UI and business logic.
  - **Keep state as low as possible:** Place `ChangeNotifier`s or other state objects at the lowest common ancestor in the widget tree to limit the scope of rebuilds.
- **Proper Resource Management:**
  - **Dispose of controllers and streams:** Always `dispose()` of `TextEditingController`, `ScrollController`, `AnimationController`, `StreamSubscription`s, and similar resources when the corresponding `StatefulWidget` is unmounted (`@override void dispose() { super.dispose(); }`). This prevents memory leaks.
  - **Handle asynchronous operations safely:** Always check `mounted` before calling `setState()` after an `await` to prevent errors if the widget is unmounted while the operation is pending.
- **Implement Robust Error Handling:**
  - Use `try-catch` blocks for asynchronous operations (e.g., network requests, file operations).
  - Consider using custom `Exception` classes for application-specific error types.
  - Utilize `libcli`'s error handling capabilities for consistent error reporting and user feedback.
- **Write Comprehensive Tests:**
  - **Unit Tests:** For business logic, utilities, and individual functions.
  - **Widget Tests:** To verify UI components behave as expected and render correctly.
  - **Integration Tests:** To test interactions between multiple widgets or entire features, simulating user flows.
  - **Strive for good test coverage:** Focus on critical functionalities and edge cases.
- **Implement Responsive and Adaptive UI:** Design UIs that gracefully adapt to different screen sizes, orientations, and device types (mobile, tablet, web, desktop). Leverage `MediaQuery`, `LayoutBuilder`, and `Sliver` widgets.
- **Use `Material Design` (or `Cupertino`):** Adhere to established design guidelines for a consistent and high-quality user experience.
- **Prioritize Performance:**
  - Optimize image assets (e.g., compress, use `CachedNetworkImage` for network images).
  - Employ lazy loading for lists (e.g., `ListView.builder`).
  - Use `SizedBox` or `Sliver` widgets for spacing and layout over overly complex `Container`s when simple sizing is needed.
- **Maintain Clean Code Structure:** Organize code logically into feature-based directories, clearly separating UI, business logic, services, and models.

---

## 🚫 What to Avoid

These are common pitfalls and anti-patterns that can lead to performance issues, bugs, and maintainability challenges.

- **Avoid using the old Provider package**; we are standardizing on Riverpod going forward.
- **Avoid Over-reliance on `setState()`:** Do not use `setState()` for global state or for changes that affect large parts of the widget tree. This leads to unnecessary rebuilds and poor performance.
- **Never Block the UI Thread:** Avoid performing heavy computations, large file I/O, or synchronous network requests directly on the main UI thread. Use `async/await`, `Isolates`, or background services to offload work.
- **Do Not Hardcode Sensitive Information:** API keys, sensitive credentials, or environment-specific configurations should *never* be hardcoded into the source code. Utilize environment variables (as discussed previously) or secure configuration methods.
- **Avoid Excessive Nesting (Widget Tree Depth):** While composition is good, overly deep or convoluted widget trees can become hard to read and debug. Break down complex widgets into smaller, named components.
- **Do Not Initialize Controllers/Resources in `build()`:** Avoid creating `AnimationController`, `TextEditingController`, `StreamController`, etc., directly within `build` methods. These should be initialized once in `initState()` and disposed in `dispose()`.
- **Avoid Using `print()` for Production Logging:** `print()` calls can be inefficient and stripped in release builds. Use `debugPrint()` for local debugging or integrate a dedicated logging package (like `logger`) for structured logging that can be controlled by build configurations.
- **Do Not Ignore `Future`s or `Stream`s:** Ensure all `Future`s are `await`ed or handled with `.then().catchError()`. Similarly, `StreamSubscription`s must be `cancel()`ed. Unhandled futures or streams can lead to unexpected behavior or memory leaks.
- **Avoid Global Variables for State:** While `GetIt` is a service locator, avoid using simple global variables (`static`) for mutable application state. This makes state harder to track, test, and manage, and can lead to unexpected side effects.
- **Don't Ship Unused Code/Assets:** Remove commented-out code, unused imports, and unreferenced assets to keep the bundle size small and the codebase clean.
- **Avoid `as` casts without `is` checks:** Use the `is` operator before casting with `as` to prevent runtime exceptions (e.g., `if (object is MyType) { (object as MyType).doSomething(); }`).

## 📦 Adding a New Module

To keep the project modular and maintainable, each feature or domain should be added as a self-contained module under the `/lib` directory.

### 🛠️ How to Add a Module

1. **Create a new folder** under `/lib` with the module name:

   ```bash
   /lib
     /your_module_name
       /src
         your_module_impl.dart
       your_module_name.dart
   ```

2. **Put internal implementation files** in the `src/` folder.

3. **Expose only the public interface** in `your_module_name.dart`:

   ```dart
   export 'src/your_module_impl.dart';
   ```

4. **Import the module using the public API**:

   ```dart
   import 'package:your_package_name/your_module_name/your_module_name.dart' as yourModule;
   ```

### ✅ Example

```bash
/lib
  /search
    /src
      search_impl.dart
    search.dart
```

In `search.dart`:

```dart
export 'src/search_impl.dart';
```

Usage:

```dart
import 'package:libcli/search/search.dart' as search;
```

### 📌 Why This Matters

- Keeps internal logic hidden and promotes clean public APIs.
- Makes modules easier to test, document, and maintain.
- AI agents and contributors can safely use the public files without depending on internal implementation details.
