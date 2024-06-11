import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _username;

  User? get user => _user;
  String? get username => _username;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  UserProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (_user != null) {
      await _fetchUserData();
    }
    notifyListeners();
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      DatabaseReference userRef =
          _database.ref().child('users').child(_user!.uid);
      DatabaseEvent userData = await userRef.once();
      if (userData.snapshot.value != null) {
        final data = userData.snapshot.value as Map;
        _username = data['username'];
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void signInWithEmailAndPassword(String s, String t) {}
}
