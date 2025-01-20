part of 'auth_bloc.dart';

sealed class AuthEvent {}

// forgoing naming convention for the sake of clarity

// start streaming auth events, login, logout, register, etc

class AuthUserSubscriptionRequested extends AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

class Register extends AuthEvent {
  final String email;
  final String password;

  Register({required this.email, required this.password});
}

class Logout extends AuthEvent {}

class FinalizeRegistration extends AuthEvent {
  
  final String authId;
  final String email;
  final String username;

  FinalizeRegistration( {required this.username, required this.authId, required this.email});

}