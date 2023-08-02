import 'package:flutter/material.dart';
import 'package:social_login/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen()),
            );
          },
          icon: const Icon(Icons.login_rounded),
        ),
      ),
    );
  }
}
