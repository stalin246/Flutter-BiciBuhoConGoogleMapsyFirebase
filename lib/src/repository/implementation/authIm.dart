import 'package:firebase_auth/firebase_auth.dart';

import '../auth.dart';

class AuthImp extends Auth{
final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<UserUID?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}