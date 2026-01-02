import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_page.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      setState(() {
        user = currentUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Always start with WelcomePage first
    return const WelcomePage();
  }
}
