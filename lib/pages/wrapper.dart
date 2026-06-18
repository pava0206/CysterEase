import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dashboard_page.dart';
import 'welcome_page.dart';

/// Checks auth state on launch and routes to Dashboard or Welcome.
/// No artificial delay — uses a FutureBuilder so it feels instant.
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<User?> _getVerifiedUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    // Reload to get latest emailVerified status from Firebase
    await user.reload();
    final refreshed = FirebaseAuth.instance.currentUser;

    if (refreshed == null || !refreshed.emailVerified) {
      // Sign out silently so they go through login next time
      await FirebaseAuth.instance.signOut();
      return null;
    }

    return refreshed;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getVerifiedUser(),
      builder: (context, snapshot) {
        // Show branded splash while checking auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashView();
        }

        if (snapshot.data != null) {
          return const DashboardPage();
        }

        return const WelcomePage();
      },
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 120),
            const SizedBox(height: 24),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}