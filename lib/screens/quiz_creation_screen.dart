import 'package:flutter/material.dart';
import '../widgets/TabBar.dart';
import '../functions/quiz_generation.dart';

class QuizCreationScreen extends StatefulWidget {
  @override
  _QuizCreationScreenState createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  String _quizJson = "Aucun quiz généré.";
  bool _loading = false;
  bool _quizGenerated = false; // Variable pour savoir si le quiz est généré
  String _selectedMode = "Entrainement"; // Valeur initiale pour le mode
  TextEditingController _topicController = TextEditingController();
  int _numberOfQuestions = 5;

  // Liste des modes disponibles
  final List<String> _modes = ["Entrainement", "Challenge", "Contre-la-montre"];

  Future<void> fetchQuiz() async {
    String topic = _topicController.text;
    if (topic.isEmpty) {
      setState(() => _quizJson = "Veuillez entrer un sujet.");
      return;
    }

    setState(() {
      _loading = true;
      _quizJson = "Génération en cours...";
      _quizGenerated = false;
    });

    try {
      List<dynamic> quiz = await QuizGenerator.generateQuiz(topic, _selectedMode, _numberOfQuestions);

      setState(() {
        _quizJson = "Quiz généré avec succès !";
        _quizGenerated = true;
      });
    } catch (e) {
      setState(() => _quizJson = "Erreur : $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> generateRandomTopic() async {
    setState(() => _loading = true);
    String topic = await QuizGenerator.generateRandomTopic();
    setState(() {
      _topicController.text = topic;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Génération"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sujet et génération aléatoire
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      labelText: "Saisir un sujet",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _loading ? null : generateRandomTopic,
                    child: Text(
                      "Générer un Sujet Aléatoire",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Résumé du Quiz
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sujet : ${_topicController.text}",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Nombre de questions : $_numberOfQuestions",
                          style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Slider(
                          min: 5,
                          max: 25,
                          divisions: 20,
                          value: _numberOfQuestions.toDouble(),
                          onChanged: (double newValue) {
                            setState(() {
                              _numberOfQuestions = newValue.toInt();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Dropdown pour sélectionner le mode
                  DropdownButton<String>(
                    value: _selectedMode,
                    onChanged: (String? newMode) {
                      setState(() {
                        _selectedMode = newMode!;
                      });
                    },
                    items: _modes.map((String mode) {
                      return DropdownMenuItem<String>(
                        value: mode,
                        child: Text(mode),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Bouton pour générer ou démarrer le quiz
            ElevatedButton(
              onPressed: _loading ? null : fetchQuiz,
              child: Text(
                _quizGenerated ? "Démarrer le Quiz" : "Générer un Quiz",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentRoute: '/quiz_generation'),
    );
  }
}