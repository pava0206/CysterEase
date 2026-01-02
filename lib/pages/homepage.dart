import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const WelcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () => signOut(context))
        ],
      ),
      body: Center(
        child: Text('Welcome, ${user?.email ?? 'User'}',
            style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}