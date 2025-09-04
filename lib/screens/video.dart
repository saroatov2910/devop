import 'package:flutter/material.dart';

// Video Screen
class Video extends StatelessWidget {
  const Video({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video')),
      body: const Center(child: Text('Video Content Here')),
    );
  }
}
