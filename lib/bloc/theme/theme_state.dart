import 'package:flutter/material.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeInitialState extends ThemeState {
  // final FlutterSecureStorage storage;

  // ThemeInitialState({required this.storage});
}

class ThemeLightState extends ThemeState {
  final ThemeData themeData;

  ThemeLightState(this.themeData);
}

class ThemeDarkState extends ThemeState {
  final ThemeData themeData;

  ThemeDarkState(this.themeData);
}

class ThemeSystemState extends ThemeState {
  final ThemeData themeData;

  ThemeSystemState(this.themeData);
}
