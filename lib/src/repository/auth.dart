typedef UserUID = String;

abstract class Auth {

  Stream<String?> get onAuthStateChanged;

  Future<void> signOut();

}