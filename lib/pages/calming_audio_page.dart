import 'package:flutter/material.dart';

class CalmingAudioPage extends StatelessWidget {
  const CalmingAudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calming Audio'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          'Here you can add calming audio tracks for stress relief.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
