import 'package:flutter/material.dart';

// Class representing the AI question input sheet:
class AiSheet extends StatefulWidget {
  // Const constructor :
  const AiSheet({super.key});
  // State class for the AI question input sheet:
  @override
  State<AiSheet> createState() => AiSheetState();
} // AiSheetState extends State<AiSheet>:

class AiSheetState extends State<AiSheet> {
  // string variable to hold the user's question:
  String question = '';

  // Build the widget tree for the AI question input sheet:
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Gemini AI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // Text field for user input:
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'הזן שאלה ל-Gemini',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              setState(() {
                question = value;
              });
            },
          ),
          const SizedBox(height: 16),
          if (question.isNotEmpty)
            Text('השאלה שלך: $question', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
