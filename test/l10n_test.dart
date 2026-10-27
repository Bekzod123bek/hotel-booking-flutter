import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/l10n/locale_cubit.dart';
import 'package:hotel_booking/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Set<String> _keys(String file) =>
    (jsonDecode(File('lib/l10n/$file').readAsStringSync())
            as Map<String, dynamic>)
        .keys
        .where((k) => !k.startsWith('@'))
        .toSet();

void main() {
  test('uz and ru translate every English key', () {
    final en = _keys('app_en.arb');
    expect(_keys('app_uz.arb'), en);
    expect(_keys('app_ru.arb'), en);
  });

  test('plural forms follow each language', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final uz = lookupAppLocalizations(const Locale('uz'));
    final ru = lookupAppLocalizations(const Locale('ru'));
    expect(en.nightsCount(1), '1 night');
    expect(en.nightsCount(3), '3 nights');
    expect(uz.nightsCount(3), '3 kecha');
    expect([1, 2, 5, 21].map(ru.nightsCount), [
      '1 ночь',
      '2 ночи',
      '5 ночей',
      '21 ночь',
    ]);
    expect(ru.priceRange(0, 300, '+'), contains(r'$300+'));
  });

  test('falls back to Uzbek for unsupported phone languages', () {
    const supported = AppLocalizations.supportedLocales;
    expect(
      LocaleCubit.resolve(const Locale('ru', 'RU'), supported),
      const Locale('ru'),
    );
    expect(
      LocaleCubit.resolve(const Locale('fr'), supported),
      const Locale('uz'),
    );
  });

  test('LocaleCubit remembers the language', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    expect(LocaleCubit(prefs).state, isNull);
    await LocaleCubit(prefs).select(const Locale('ru'));
    expect(LocaleCubit(prefs).state, const Locale('ru'));
  });
}
