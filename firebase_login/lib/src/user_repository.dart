import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'services/logger.dart';

/// Repository handling the user authentication / login
class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final _log = getLogger();

  /// Initializer taking authentication methods from the outside for testing
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  /// Method for signing in with Google auth provider
  Future<FirebaseUser> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    _log.d('Signed-in user '
        '${(await _firebaseAuth.currentUser()).email} with Google');
    return _firebaseAuth.currentUser();
  }

  /// Sign user in with username and password
  Future<void> signInWithCredentials({String email, String password}) {
    _log.d('Signed-in user $email with email and password');
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Method for creating a new account
  Future<void> signUp({String email, String password}) async {
    _log.d('Created new account for user $email with email and password');
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Method for signing out of the app
  Future<void> signOut() async {
    _log.d('Signed user out of the app');
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Check if user is signed in
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    _log.d('User ${currentUser.email} is '
        '${currentUser != null?'signed in':'not signed in'}');
    return currentUser != null;
  }

  /// Get information about current user
  Future<String> getUser() async {
    _log.d('Current user is ${(await _firebaseAuth.currentUser()).email}');
    return (await _firebaseAuth.currentUser()).email;
  }
}