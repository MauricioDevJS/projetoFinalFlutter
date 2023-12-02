import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nuzero/pages/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    ),
  );
}
