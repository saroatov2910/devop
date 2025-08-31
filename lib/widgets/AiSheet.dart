import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AiSheet extends StatefulWidget {
  const AiSheet({super.key});

  @override
  State<AiSheet> createState() => _AiSheetState();
}

class _AiSheetState extends State<AiSheet> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  bool _isLoading = false;
  final Ai aiService = Ai();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Ask a question",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    final prompt = _controller.text;
                    try {
                      final result = await aiService.askGemini(prompt);
                      setState(() => _response = result);
                    } catch (e) {
                      setState(() => _response = "Error: $e");
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
                  child: const Text("שלח"),
                ),
          const SizedBox(height: 10),
          Expanded(child: SingleChildScrollView(child: Text(_response))),
        ],
      ),
    );
  }
}
