import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/auth_repository.dart';

enum AuthStatus { onboarding, unauthenticated, authenticated }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.busy = false,
    this.error,
  });

  final AuthStatus status;
  final AppUser? user;
  final bool busy;

  /// Why the last sign-in or sign-up failed; cleared on the next attempt.
  final AuthError? error;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    bool? busy,
    AuthError? Function()? error,
  }) => AuthState(
    status: status ?? this.status,
    user: user ?? this.user,
    busy: busy ?? this.busy,
    error: error != null ? error() : this.error,
  );

  @override
  List<Object?> get props => [status, user, busy, error];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(_initial(_repository));

  final AuthRepository _repository;

  bool get isCloud => _repository.isCloud;

  static AuthState _initial(AuthRepository repo) {
    if (!repo.onboardingDone) {
      return const AuthState(status: AuthStatus.onboarding);
    }
    final user = repo.currentUser;
    return user == null
        ? const AuthState(status: AuthStatus.unauthenticated)
        : AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<void> completeOnboarding() async {
    await _repository.completeOnboarding();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> login(String email, String password) async {
    await _run(() => _repository.login(email: email, password: password));
  }

  Future<void> register(String name, String email, String password) async {
    await _run(
      () => _repository.register(name: name, email: email, password: password),
    );
  }

  Future<void> _run(Future<AppUser> Function() action) async {
    emit(state.copyWith(busy: true, error: () => null));
    try {
      final user = await action();
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(busy: false, error: () => e.error));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
