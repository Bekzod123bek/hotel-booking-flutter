import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth_repository.dart';

/// Email and password accounts in Firebase Authentication. The profile is also
/// saved in `users/{uid}`, next to the user's favorites and bookings.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth, this._db, this._prefs);

  static const _onboardingKey = 'onboarding_done';

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final SharedPreferences _prefs;

  @override
  bool get isCloud => true;

  @override
  bool get onboardingDone => _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> completeOnboarding() => _prefs.setBool(_onboardingKey, true);

  @override
  AppUser? get currentUser => _toUser(_auth.currentUser);

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) =>
      _guard(() async {
        final result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return _toUser(result.user)!;
      });

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) =>
      _guard(() async {
        final result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = result.user!;
        await user.updateDisplayName(name.trim());
        await _db.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return AppUser(name: name.trim(), email: email);
      });

  @override
  Future<void> logout() => _auth.signOut();

  static AppUser? _toUser(User? user) {
    if (user == null) return null;
    final email = user.email ?? '';
    final name = user.displayName;
    return AppUser(
      name: (name == null || name.trim().isEmpty)
          ? email.split('@').first
          : name,
      email: email,
    );
  }

  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthException(mapAuthCode(e.code));
    } on FirebaseException catch (e) {
      throw AuthException(mapAuthCode(e.code));
    }
  }
}

/// Maps a Firebase error code to a reason the UI can translate.
AuthError mapAuthCode(String code) => switch (code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-email' ||
      'user-disabled' =>
        AuthError.invalidCredentials,
      'email-already-in-use' => AuthError.emailInUse,
      'weak-password' => AuthError.weakPassword,
      'network-request-failed' || 'unavailable' => AuthError.network,
      'too-many-requests' => AuthError.tooManyRequests,
      _ => AuthError.unknown,
    };
