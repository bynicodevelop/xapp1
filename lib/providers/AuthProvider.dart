import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isAuthenticated = false;

  Stream<Map<String, dynamic>> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      isAuthenticated = true;

      return {
        'uid': user.uid,
        'email': user.email,
      };
    });
  }

  Future login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      isAuthenticated = true;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  void logout() async {
    await _auth.signOut();

    isAuthenticated = false;
  }
}
