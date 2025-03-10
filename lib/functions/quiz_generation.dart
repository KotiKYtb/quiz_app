import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:diacritic/diacritic.dart';

class QuizGenerator {
  static const String apiKey = "VizP5DLfd2KkgQVpTLrwHeVx5uXefl0f";
  static const String apiUrl = "https://api.mistral.ai/v1/chat/completions";

  static String cleanText(String text) {
    print("Texte brut avant nettoyage : $text");
    return utf8.decode(latin1.encode(removeDiacritics(text)));
  }

  static Future<List<dynamic>> generateQuiz(String topic, String mode, int numberOfQuestions) async {
    try {
      print("Début de la génération du quiz pour le sujet : $topic");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "mistral-medium",
          "messages": [
            {"role": "system", "content": "Tu es un créateur de quiz. Réponds uniquement en JSON."},
            {"role": "user", "content": "Crée un quiz sur '$topic' en $numberOfQuestions questions."},
          ],
          "max_tokens": 10000,
        }),
      );

      print("Réponse reçue: ${response.body}");

      if (response.statusCode == 200) {
        var rawContent = jsonDecode(utf8.decode(response.bodyBytes))['choices'][0]['message']['content'];
        rawContent = cleanText(rawContent.trim());

        Map<String, dynamic> quizData = jsonDecode(rawContent);
        List<dynamic> questions = quizData['quiz']['questions'];

        print("Quiz généré: $questions");

        Map<String, dynamic> finalQuizData = {
          "topic": topic,
          "created_at": DateTime.now().toIso8601String(),
          "mode": mode,
          "number_of_questions": numberOfQuestions,
          "questions": questions
        };

        await saveQuizToFile(finalQuizData);
        print("Quiz sauvegardé dans le fichier.");
        return questions;
      } else {
        throw Exception('Failed to generate quiz');
      }
    } catch (e) {
      print("Erreur lors de la génération du quiz: $e");
      return [];
    }
  }

  static Future<void> saveQuizToFile(Map<String, dynamic> quizData) async {
    var status = await Permission.storage.request();
    if (!status.isGranted) return;

    try {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        final file = File('${directory.path}/quiz_data.json');
        await file.writeAsString(jsonEncode(quizData));
        print("Quiz sauvegardé dans le fichier.");
      }
    } catch (e) {
      print("Erreur d'enregistrement : $e");
    }
  }

  static Future<String> generateRandomTopic() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "mistral-medium",
          "messages": [
            {"role": "system", "content": "Tu es un générateur de sujets aléatoires simple et pas trop long, 3 mots maximum. Tu as interdiction de me donner une note explicative du sujet !"},
            {"role": "user", "content": "Donne-moi un sujet aléatoire pas trop compliqué."},
          ],
          "max_tokens": 50,
        }),
      );

      if (response.statusCode == 200) {
        String rawContent = jsonDecode(utf8.decode(response.bodyBytes))['choices'][0]['message']['content'].trim();
        print("Texte brut avant nettoyage : $rawContent");

        List<String> topics = rawContent.split(RegExp(r'[\n\r]+')).map((topic) => topic.trim()).toList();

        String cleanedTopic = cleanText(topics.isNotEmpty ? topics.first : 'Erreur');

        return cleanedTopic;
      } else {
        throw Exception('Failed to generate random topic');
      }
    } catch (e) {
      print("Erreur lors de la génération du sujet aléatoire: $e");
      return 'Erreur';
    }
  }
}