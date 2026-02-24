import 'package:flutter/material.dart';

class FingerprintScanPage extends StatelessWidget {
  final String successText;

  const FingerprintScanPage({super.key, required this.successText});

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(text: successText),
        ),
      );
    });

    return const Scaffold(
      backgroundColor: mainGreen,
      body: Center(
        child: Icon(Icons.fingerprint, size: 150, color: Colors.white),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  final String text;

  const SuccessPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);

    return Scaffold(
      backgroundColor: mainGreen,
      body: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}