part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthPending extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthFail extends AuthState {
  final String message;

  AuthFail({required this.message});

  @override
  List<Object?> get props => [message];
}

// forgoing naming convention for the sake of clarity
class Authenticated extends AuthState {
  final User user;

  Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// forgoing naming convention for the sake of clarity
class AuthenticatedNoUser extends AuthState {
  final String authId;
  final String email;

  AuthenticatedNoUser({required this.authId, required this.email});

  @override
  List<Object?> get props => [authId,email];
}

// forgoing naming convention for the sake of clarity
class AuthenticatedNoUserPending extends AuthState {
  final String authId;
  final String email;

  AuthenticatedNoUserPending({required this.authId, required this.email});

  @override
  List<Object?> get props => [authId,email];
}

// forgoing naming convention for the sake of clarity
class Unauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}
