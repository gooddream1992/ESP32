import 'package:esp_32/auth/shplash_screen.dart';
import 'package:esp_32/screens/navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin/admin_dashboard.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // String stripePublishableKey = "pk_test_51LSHE5LWjPzEwLzKJ0kNGnFrtenT4TtMTwBrlN5SWZI9L5A2jV3XzHkNLFZB8CzaJjaNF78nqU6xX39L6h0BhG4D00xBjADDOd";
 /* Stripe.publishableKey = stripePublishableKey;*/
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        //home: SplashScreen(),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(FirebaseAuth.instance.currentUser!.email == "test123@gmail.com") {
                  return adminDashboard();
                } else {
                  return NavigationScreen();
                }
              } else {
                return SplashScreen();
              }
            }));
  }
}
