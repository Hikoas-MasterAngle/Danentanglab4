import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'controllers/auth_services.dart';
import 'views/login_page.dart';
import 'views/home.dart';
import 'views/sign_up_page.dart';
import 'views/add_contact_page.dart';
import 'firebase_options.dart';

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
      routes: {
        "/": (context) => CheckUser(),
        "/login": (context) => LoginPage(),
        "/signup": (context) => SignUpPage(),
        "/home": (context) => HomePage(),
        "/add": (context) => AddContactPage(),
      },
    );
  }
}

// check login
class CheckUser extends StatefulWidget {
  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    super.initState();
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}