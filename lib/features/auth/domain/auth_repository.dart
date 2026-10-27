import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({required this.name, required this.email});

  final String name;
  final String email;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  List<Object?> get props => [name, email];
}

enum AuthError {
  invalidCredentials,
  emailInUse,
  weakPassword,
  network,
  tooManyRequests,
  unknown,
}

/// Thrown by [AuthRepository] with a reason the UI can translate.
class AuthException implements Exception {
  const AuthException(this.error);

  final AuthError error;

  @override
  String toString() => 'AuthException($error)';
}

abstract class AuthRepository {
  bool get onboardingDone;
  Future<void> completeOnboarding();

  AppUser? get currentUser;

  /// Whether accounts are stored in the cloud (as opposed to demo mode).
  bool get isCloud;

  Future<AppUser> login({required String email, required String password});
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
}
