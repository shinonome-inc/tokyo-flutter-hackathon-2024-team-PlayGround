import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mobile/constants/prompts.dart';

class GeminiClient {
  GeminiClient._();

  static final GeminiClient instance = GeminiClient._();

  static final _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
  );

  Future<String> generateDashMessage({required String inputText}) async {
    final content = [
      Content.text(Prompts.dash),
      Content.text(inputText),
    ];
    final response = await _model.generateContent(content);
    return response.text ?? '';
  }
}
