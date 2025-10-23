import 'package:flutter/material.dart';
import '../models/user_model.dart'; 

class ProfileScreen extends StatelessWidget {
  final User user; // terima user yang login

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user.username, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(user.email, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}