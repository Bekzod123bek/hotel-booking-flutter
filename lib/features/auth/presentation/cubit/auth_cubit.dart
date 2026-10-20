import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/auth_repository.dart';

enum AuthStatus { onboarding, unauthenticated, authenticated }

class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.busy = false});

  final AuthStatus status;
  final AppUser? user;
  final bool busy;

  AuthState copyWith({AuthStatus? status, AppUser? user, bool? busy}) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        busy: busy ?? this.busy,
      );

  @override
  List<Object?> get props => [status, user, busy];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(_initial(_repository));

  final AuthRepository _repository;

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
    emit(state.copyWith(busy: true));
    final user = await _repository.login(email: email, password: password);
    emit(AuthState(status: AuthStatus.authenticated, user: user));
  }

  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(busy: true));
    final user = await _repository.register(
      name: name,
      email: email,
      password: password,
    );
    emit(AuthState(status: AuthStatus.authenticated, user: user));
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
