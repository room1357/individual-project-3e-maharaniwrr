import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: const Color.fromARGB(255, 243, 33, 180),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Aplikasi ini dibuat untuk latihan Flutter bab 6.\n'
            'Menampilkan halaman Login, Register, Home, Profile, dan Settings.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}
