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
            // todo: perhaps return
            emit.onEach(authRepository.userStream, onData: (authUser) async {
              if (authUser == null) {
                emit(Unauthenticated());
              } else {
                // user is authenticated in firebase auth, does user exist in db?
                User? user = await userRepository.getByAuthId(authUser.uid);
                if (user == null) {
                  emit(AuthenticatedNoUser(
                      authId: authUser.uid, email: authUser.email!));
                } else {
                  emit(Authenticated(user: user));
                }
              }
            });

          case FinalizeRegistration(
              :final authId,
              :final username,
              :final email
            ):
            await _handleFinalizeRegistration(authId, email, username, emit);
        }
      } on Exception catch (e) {
        emit(AuthFail(message: e.toString()));
      }
    });
  }

  Future<void> _handleFinalizeRegistration(String authId, String email,
      String username, Emitter<AuthState> emit) async {
    emit(AuthenticatedNoUserPending(authId: authId, email: email));
    final user = await userRepository
        .create(User(email: email, authId: authId, username: username));
    // this operation does not trigger a change on the auth stream.
    emit(Authenticated(user: user));
  }

  Future<void> _onLogin(
      Emitter<AuthState> emit, String email, String password) async {
    emit(AuthPending());
    await authRepository.login(email: email, password: password);
  }

  Future<void> onLogout(Emitter<AuthState> emit) async {
    await authRepository.logout();
    // no reason to emit state here because this triggers a change on the authStateChanges stream
    // the stream handler will emit the appropriate state
  }

  Future<void> _onRegister(
      Emitter<AuthState> emit, String email, String password) async {
    emit(AuthPending());
    await authRepository.register(email: email, password: password);
  }
}
