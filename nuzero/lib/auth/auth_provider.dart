import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  AuthProvider() {
    _listenToAuthState();
  }

  User? get user => _user;

  void _listenToAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    // Implemente a lógica de login aqui
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
