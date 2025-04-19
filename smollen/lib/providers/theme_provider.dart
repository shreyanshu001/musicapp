import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_lightTheme);

  static final _lightTheme = ThemeData.light();
  static final _darkTheme = ThemeData.dark();

  void toggleTheme() {
    state = state.brightness == Brightness.dark ? _lightTheme : _darkTheme;
  }
}
