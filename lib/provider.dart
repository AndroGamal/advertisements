import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

enum statmyprovide { unauth, try_auth, auth }

class Myprovider extends ChangeNotifier {
  late FirebaseAuth _outh;
  late User _user;
  statmyprovide _Case = statmyprovide.try_auth;
  String _error = "";
  Myprovider() {
    _outh = FirebaseAuth.instance;
    _outh.authStateChanges().listen((use) {
      if (use == null) {
        _Case = statmyprovide.unauth;
      } else {
        _Case = statmyprovide.auth;
        _user = use;
      }
      notifyListeners();
    });
  }
  User get user => _user;
  statmyprovide get caseMyprovider => _Case;
  String get failure => _error;
  Future<bool> login(String _email, String _pass) async {
    try {
      _Case = statmyprovide.try_auth;
      notifyListeners();
      await _outh.signInWithEmailAndPassword(email: _email, password: _pass);
    } on FirebaseAuthException catch (e) {
      _error = e.code;
      _Case = statmyprovide.unauth;
      notifyListeners();
      return false;
    }
    _Case = statmyprovide.auth;
    notifyListeners();
    return true;
  }

  void logout() async {
    _outh.signOut();
    _Case = statmyprovide.unauth;
    notifyListeners();
  }

  Future<bool> Create_acount(String _email, String _pass) async {
    try {
      await _outh.createUserWithEmailAndPassword(
          email: _email, password: _pass);
      _Case = statmyprovide.try_auth;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _error = e.code;
      _Case = statmyprovide.unauth;
      notifyListeners();
      return false;
    }
    _Case = statmyprovide.auth;
    notifyListeners();
    return true;
  }
}
