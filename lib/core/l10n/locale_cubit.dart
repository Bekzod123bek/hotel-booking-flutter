import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/generated/app_localizations.dart';

/// The language chosen in the profile. `null` means "follow the phone"; if
/// the phone language is not supported the app falls back to Uzbek.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit(this._prefs) : super(_read(_prefs));

  static const _key = 'app_locale';

  final SharedPreferences _prefs;

  static Locale? _read(SharedPreferences prefs) {
    final code = prefs.getString(_key);
    if (code == null) return null;
    return AppLocalizations.supportedLocales
        .where((l) => l.languageCode == code)
        .firstOrNull;
  }

  Future<void> select(Locale locale) async {
    emit(locale);
    await _prefs.setString(_key, locale.languageCode);
  }

  /// Used by [MaterialApp.localeResolutionCallback].
  static Locale resolve(Locale? device, Iterable<Locale> supported) {
    for (final l in supported) {
      if (l.languageCode == device?.languageCode) return l;
    }
    return const Locale('uz');
  }
}
