import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth_repository.dart';

/// Demo authentication: nothing is sent anywhere. Any valid email and a
/// password of 6+ characters sign the user in, and the profile is kept in
/// [SharedPreferences]. Passwords are never stored.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(
    this._prefs, {
    this.delay = const Duration(milliseconds: 700),
  });

  static const _onboardingKey = 'onboarding_done';
  static const _loggedInKey = 'logged_in';
  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';

  final SharedPreferences _prefs;
  final Duration delay;

  @override
  bool get isCloud => false;

  @override
  bool get onboardingDone => _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> completeOnboarding() => _prefs.setBool(_onboardingKey, true);

  @override
  AppUser? get currentUser {
    if (!(_prefs.getBool(_loggedInKey) ?? false)) return null;
    return AppUser(
      name: _prefs.getString(_nameKey) ?? 'Guest',
      email: _prefs.getString(_emailKey) ?? '',
    );
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    final savedEmail = _prefs.getString(_emailKey);
    final name = savedEmail == email
        ? (_prefs.getString(_nameKey) ?? _nameFromEmail(email))
        : _nameFromEmail(email);
    return _save(AppUser(name: name, email: email));
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    return _save(AppUser(name: name.trim(), email: email));
  }

  @override
  Future<void> logout() => _prefs.setBool(_loggedInKey, false);

  Future<AppUser> _save(AppUser user) async {
    await _prefs.setString(_nameKey, user.name);
    await _prefs.setString(_emailKey, user.email);
    await _prefs.setBool(_loggedInKey, true);
    return user;
  }

  static String _nameFromEmail(String email) {
    final local = email.split('@').first.replaceAll(RegExp(r'[._\-]+'), ' ');
    return local
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }
}
