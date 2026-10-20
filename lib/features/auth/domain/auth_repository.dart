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

abstract class AuthRepository {
  bool get onboardingDone;
  Future<void> completeOnboarding();

  AppUser? get currentUser;
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
}
