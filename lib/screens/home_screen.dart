import 'package:flutter/material.dart';
import '../widgets/TabBar.dart'; // Assure-toi d'importer ta classe CustomBottomNavBar

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool quizQuotidienFait = false;
    int dernierScore = 85;
    String dernierQuiz = "Quiz sur Flutter";

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quiz Quotidien
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Quiz Quotidien",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    quizQuotidienFait
                        ? "✅ Quiz validé aujourd'hui !"
                        : "❌ Vous n'avez pas encore fait le quiz.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: quizQuotidienFait ? null : () {
                      // Logique pour démarrer le quiz quotidien
                    },
                    child: Text(
                      "Lancer le Quiz Quotidien",
                      style: TextStyle(color: Colors.black), // Texte noir
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Bouton Démarrer un Quiz
            ElevatedButton(
              onPressed: () {
                // Navigue vers la page de création du quiz
                Navigator.pushNamed(context, '/quiz_creation');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Démarrer un Quiz",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Texte noir
                ),
              ),
            ),
            SizedBox(height: 20),

            // Dernier Quiz Joué
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Dernier Quiz : $dernierQuiz",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Meilleur Score : $dernierScore%",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour rejouer le dernier quiz
                    },
                    child: Text(
                      "Rejouer le Dernier Quiz",
                      style: TextStyle(color: Colors.black), // Texte noir
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentRoute: '/home'),
    );
  }
}