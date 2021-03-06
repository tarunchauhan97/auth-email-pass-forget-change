import 'package:flutter/material.dart';
import 'package:flutter_fb_auth_emailpass/pages/user/user_main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final storage = new FlutterSecureStorage();
  Future<bool> checkLoginStatus() async {
    String? value = await storage.read(key: 'uid');
    if (value == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return MaterialApp(
            title: 'Flutter Firebase Email Password Auth',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
            home: FutureBuilder(
              future: checkLoginStatus(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data == false) {
                  return Login();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return userMain();
              },
            ),
          );
        });
  }
}
