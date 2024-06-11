import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/content/home.dart';
import 'package:flutter_application_1/login/login.dart';
import 'package:flutter_application_1/login/register.dart';
import 'package:flutter_application_1/main/Myticket.dart';
import 'package:flutter_application_1/main/index.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/main/profil_user.dart';
import 'package:flutter_application_1/splash.dart'; // Import the splash screen
// Import Firestore

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => const HomePage(),
        // When navigating to the "/login" route, build the LoginPage widget.
        '/login': (context) => const LoginPage(),
        // When navigating to the "/index" route, build the IndexPage widget.
        '/index': (context) => const IndexPage(),
        '/ticket': (context) => MyTicketPage(),
        // When navigating to the "/register" route, build the RegisterPage widget.
        '/register': (context) => const RegisterPage(),
        '/profil_user': (context) => ProfilePage(
              username: '',
              email: '',
            ),
      }, // Set SplashScreen as the home widget
    );
  }
}
