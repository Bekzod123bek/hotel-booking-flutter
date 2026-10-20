import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_read(_prefs));

  static const _key = 'theme_dark';

  final SharedPreferences _prefs;

  static ThemeMode _read(SharedPreferences prefs) {
    final dark = prefs.getBool(_key);
    if (dark == null) return ThemeMode.system;
    return dark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDark(bool dark) async {
    emit(dark ? ThemeMode.dark : ThemeMode.light);
    await _prefs.setBool(_key, dark);
  }
}
