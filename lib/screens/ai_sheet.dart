import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/products/product.dart';

// AiSheet widget allows the user to ask questions to Gemini AI about their products.
class AiSheet extends StatefulWidget {
  final List<Product> products; // List of products to provide context for AI

  const AiSheet({super.key, required this.products});

  @override
  State<AiSheet> createState() => AiSheetState();
}

class AiSheetState extends State<AiSheet> {
  String question = ''; // Stores the user's question
  String answer = ''; // Stores the AI's answer
  bool loading = false; // Indicates if the AI is processing

  // Sends the user's question to Gemini AI and updates the answer
  Future<void> askGemini(String userQuestion) async {
    setState(() {
      loading = true;
      answer = '';
      question = userQuestion;
    });
    try {
      // Prepare the prompt with product names and user question
      String productsText = widget.products.map((p) => p.name).join(', ');
      String prompt = 'המצרכים שלי: $productsText. השאלה שלי: $userQuestion';
      final ai = Ai();
      final result = await ai.askGemini(prompt);
      setState(() => answer = result);
    } catch (e) {
      setState(() => answer = 'שגיאה: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title for the AI sheet
          const Text(
            'Gemini AI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Text field for user to enter a question
          TextField(
            decoration: const InputDecoration(
              labelText: 'הזן שאלה ל-Gemini',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              askGemini(value);
            },
          ),
          const SizedBox(height: 16),
          // Display the user's question if available
          if (question.isNotEmpty)
            Text('השאלה שלך: $question', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          // Show loading indicator while waiting for AI response
          if (loading) const CircularProgressIndicator(),
          // Display the AI's answer if available
          if (answer.isNotEmpty)
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Text(
                  'תשובת Gemini: $answer',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
