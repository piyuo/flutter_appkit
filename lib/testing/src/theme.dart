import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF00677E),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFB4EBFF),
  onPrimaryContainer: Color(0xFF001F27),
  secondary: Color(0xFF4C626A),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCEE6F0),
  onSecondaryContainer: Color(0xFF061E25),
  tertiary: Color(0xFF006399),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFCDE5FF),
  onTertiaryContainer: Color(0xFF001D32),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFCFE),
  onBackground: Color(0xFF191C1D),
  surface: Color(0xFFFBFCFE),
  onSurface: Color(0xFF191C1D),
  surfaceVariant: Color(0xFFDBE4E8),
  onSurfaceVariant: Color(0xFF40484B),
  outline: Color(0xFF70787C),
  onInverseSurface: Color(0xFFEFF1F2),
  inverseSurface: Color(0xFF2E3132),
  inversePrimary: Color(0xFF5AD5F9),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF00677E),
  outlineVariant: Color(0xFFBFC8CC),
  scrim: Color(0xFF000000),
);

ThemeData? theme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.withOpacity(.4),
      foregroundColor: Colors.grey.shade800,
      titleTextStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade800, size: 20),
      actionsIconTheme: IconThemeData(color: Colors.grey.shade800),
    ),
  );
}

const dartColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF5AD5F9),
  onPrimary: Color(0xFF003542),
  primaryContainer: Color(0xFF004E5F),
  onPrimaryContainer: Color(0xFFB4EBFF),
  secondary: Color(0xFFB3CAD4),
  onSecondary: Color(0xFF1D333B),
  secondaryContainer: Color(0xFF344A52),
  onSecondaryContainer: Color(0xFFCEE6F0),
  tertiary: Color(0xFF94CCFF),
  onTertiary: Color(0xFF003352),
  tertiaryContainer: Color(0xFF004B74),
  onTertiaryContainer: Color(0xFFCDE5FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF191C1D),
  onBackground: Color(0xFFE1E3E4),
  surface: Color(0xFF191C1D),
  onSurface: Color(0xFFE1E3E4),
  surfaceVariant: Color(0xFF40484B),
  onSurfaceVariant: Color(0xFFBFC8CC),
  outline: Color(0xFF899296),
  onInverseSurface: Color(0xFF191C1D),
  inverseSurface: Color(0xFFE1E3E4),
  inversePrimary: Color(0xFF00677E),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF5AD5F9),
  outlineVariant: Color(0xFF40484B),
  scrim: Color(0xFF000000),
);

ThemeData? darkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: dartColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.withOpacity(.4),
      foregroundColor: Colors.grey.shade200,
      titleTextStyle: TextStyle(fontSize: 14, color: Colors.grey.shade200),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade200, size: 20),
      actionsIconTheme: IconThemeData(color: Colors.grey.shade200),
    ),
  );
}
