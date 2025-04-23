import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_nest/authentications/login.dart';
import 'package:daily_nest/homepage.dart';
import 'package:daily_nest/notifications/local_noti.dart';
import 'package:daily_nest/notifications/noti_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyALurSuE5zyMmao-h9oBr_pLl0yiaKNmxk",
            authDomain: "dailynest-fb083.firebaseapp.com",
            projectId: "dailynest-fb083",
            storageBucket: "dailynest-fb083.firebasestorage.app",
            messagingSenderId: "225280984219",
            appId: "1:225280984219:web:7d7e26cf2bed93dd41f23e",
            measurementId: "G-CC4XGN0QLE"));
  } else {
    await Firebase.initializeApp();
  }
  await Future.wait([NotiManager.init(), LocalNotiManager.init()]);

  _addToken();

  runApp(MainApp());
}

void _addToken() async {
  var users = await FirebaseFirestore.instance
      .collection('habits')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();

  for (var user in users.docs) {
    FirebaseFirestore.instance.collection('habits').doc(user.id).set(
        {'tcm_token': await NotiManager.getToken()}, SetOptions(merge: true));
  }
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
          body: user != null && user!.emailVerified ? Homepage() : Login()),
    );
  }
}
