import 'package:flutter/material.dart';

//  Brochure  Screen
class Brochure extends StatelessWidget {
  const Brochure({super.key});
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Brochure')),
    body: const Center(child: Text('Brochure Content Here')),
  );
}
