import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp({required String email, required String pass}) async {
    try {
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      currentFirebaseUser = newAccount.user;
      print('Auth登録完了');
      return newAccount;
    } on FirebaseAuthException catch (e) {
      print('Auth登録エラー$e');
      return false;
    }
  }

  static Future<dynamic> emailSignIn({required String email, required String pass}) async {
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      currentFirebaseUser = _result.user;
      print('サインイン完了');
      return true;
    } on FirebaseAuthException catch (e) {
      print('Authサインインエラー$e');
      return false;
    }
  }
}