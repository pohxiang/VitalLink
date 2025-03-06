import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth;

  Authentication() : _auth = FirebaseAuth.instance;

  /// Signs in a user with the given [email] and [password].
  ///
  /// Returns the signed in [User] if successful.
  /// Throws a [FirebaseAuthException] with a descriptive error message
  /// if sign in fails.
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password provided.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }
      // Rethrow as a FirebaseAuthException with the updated message
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      // Catch any other errors.
      rethrow; // or throw Exception('Some other error: ${e.toString()}');
    }
  }
}
