import 'package:talkto/model/user.dart';

abstract class AuthBase {
  Future<Users> currentUser();

  Future<Users> signInAnonymously();

  Future<bool> signOut();

  Future<Users> signInWithGoogle();

  Future<Users> signInWithFacebook();

  Future<Users> signInWithEmailAndPassword(String email, String password);

  Future<Users> createUserWithEmailAndPassword(String email, String password);
}
