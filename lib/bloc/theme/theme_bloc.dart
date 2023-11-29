import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maxalert/bloc/theme/theme_event.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  ThemeBloc() : super(ThemeInitialState()) {
    on<ToggleThemeEvent>(
      (event, emit) async {
        String? storageTheme = await storage.read(key: "theme_preference");

        if (storageTheme == "light") {
          emit(ThemeLightState(ThemeData.light()));
        } else if (storageTheme == "dark") {
          emit(ThemeDarkState(ThemeData.dark()));
        } else if (storageTheme == null) {
          emit(ThemeLightState(ThemeData.light()));
        } else {
          final isDarkModeEnabled =
              WidgetsBinding.instance.window.platformBrightness ==
                  Brightness.dark;

          emit(
            isDarkModeEnabled
                ? ThemeDarkState(ThemeData.dark())
                : ThemeLightState(ThemeData.light()),
          );
        }
      },
    );

    on<ToggleLightTheme>(
      (event, emit) async {
        await storage.write(key: 'theme_preference', value: 'light');
        emit(ThemeLightState(ThemeData.light()));
      },
    );

    on<ToggleDarkTheme>((event, emit) async {
      await storage.write(key: 'theme_preference', value: 'dark');
      emit(ThemeDarkState(ThemeData.dark()));
    });

    on<ToggleSystemTheme>((event, emit) async {
      await storage.write(key: 'theme_preference', value: 'system');
      final isDarkModeEnabled =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;

      emit(isDarkModeEnabled
          ? ThemeDarkState(ThemeData.dark())
          : ThemeLightState(ThemeData.light()));
    });
  }
}
