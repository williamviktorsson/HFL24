import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final authService = FirebaseAuth.instance;

  Future<UserCredential> register(
      {required String email, required String password}) {
    return authService.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> login({required String email, required String password}) {
    // as per documentation, this method throws an exception if login fails
    // as per documentaiton, successful login updates authStateChanges stream
    return authService.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> logout() async {
    await authService.signOut();
  }


  Stream<User?> get signedInAuthId {
    return authService.authStateChanges();
  }
}
