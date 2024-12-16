import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthEvent { login, logout }

sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}

final class AuthNotAuth extends AuthState {
  AuthNotAuth();
}

final class AuthSuccess extends AuthState {
  final String user;
  AuthSuccess(this.user);
}

final class AuthInProgress extends AuthState {
  AuthInProgress();
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  login() async {
    emit(AuthInProgress());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AuthSuccess('user'));
  }

  logout() {
    emit(AuthNotAuth());
  }
}
