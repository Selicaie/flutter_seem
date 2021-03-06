import 'package:firebase_auth/firebase_auth.dart';
import 'package:instructions_app/models/users.dart';

import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(null,null,0,null,null,user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
      //.map((FirebaseUser user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }
  // sign in anon
  Future signInAnon(String username,String name,int id) async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
       await DatabaseService(uid: id.toString()).updateUserData(username,name,id);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // sign out
  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}