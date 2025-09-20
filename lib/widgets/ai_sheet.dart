import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/products/product.dart';
// AiSheet :

class AiSheet extends StatefulWidget {
  final List<Product> products;

  const AiSheet({super.key, required this.products});

  @override
  State<AiSheet> createState() => AiSheetState();
}

//AiSheetState is have a 3 paramptr:
class AiSheetState extends State<AiSheet> {
  String question = '';
  String answer = '';
  bool loading = false;

  Future<void> askGemini(String userQuestion) async {
    setState(() {
      loading = true;
      answer = '';
      question = userQuestion;
    });
    try {
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
          const Text(
            'Gemini AI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
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
          //
          if (question.isNotEmpty)
            Text('השאלה שלך: $question', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          if (loading) const CircularProgressIndicator(),
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
