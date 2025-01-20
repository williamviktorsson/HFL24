import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthBloc({required this.authRepository, required this.userRepository})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      try {
        switch (event) {
          case Login(:final email, :final password):
            await _onLogin(emit, email, password);
          case Register(:final email, :final password):
            await _onRegister(emit, email, password);

          case Logout():
            await onLogout(emit);
          case AuthUserSubscriptionRequested():
            return emit.onEach(authRepository.signedInAuthId,
                onData: (user) async =>
                    await _handleUserIdStreamEvent(user, emit),
                onError: (e, trace) => AuthFail(message: e.toString()));
          case FinalizeRegistration():
            await _handleFinalizeRegistration(event, emit);
        }
      } on Exception catch (e) {
        emit(AuthFail(message: e.toString()));
      }
    });
  }

  Future<void> _handleUserIdStreamEvent(
      auth.User? user, Emitter<AuthState> emit) async {
    if (user == null) {
      emit(Unauthenticated());
    } else {
      final userInDb = await userRepository.getByAuthId(user.uid);
      if (userInDb == null) {
        emit(AuthenticatedNoUser(authId: user.uid, email: user.email!));
      } else {
        emit(Authenticated(user: userInDb));
      }
    }
  }

  Future<void> _handleFinalizeRegistration(
      FinalizeRegistration event, Emitter<AuthState> emit) async {
        
    emit(AuthenticatedNoUserPending(authId: event.authId, email: event.email));

    final user = await userRepository.create(User(
        authId: event.authId, email: event.email, username: event.username));

    emit(Authenticated(user: user));
  }

  Future<void> _onLogin(
      Emitter<AuthState> emit, String email, String password) async {
    emit(AuthPending());
    await authRepository.login(email: email, password: password);
  }

  Future<void> onLogout(Emitter<AuthState> emit) async {
    await authRepository.logout();
  }

  Future<void> _onRegister(
      Emitter<AuthState> emit, String email, String password) async {
    emit(AuthPending());
    final credential =
        await authRepository.register(email: email, password: password);

    String? authId = credential.user?.uid;

    if (authId == null) {
      emit(AuthFail(message: 'user representation in auth system missing'));
    } else {
      emit(AuthenticatedNoUser(authId: authId, email: email));
    }
  }
}
