import 'dart:js';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recipes/pages/home.dart';
import 'package:recipes/pages/describe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: "1:891400290113:android:8884fa8211bca06525abc0",
        apiKey: "AIzaSyBCxw4R2hLoWeWgPP0zV-4MBXcldVPmOjc",
        projectId: "recipes-348dc",
        messagingSenderId: "891400290113",
      ),
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.amber,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/desc': (context) => describes(),
    },
  ));
}