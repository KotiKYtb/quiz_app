import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import '../widgets/TabBar.dart';

class ProfileScreen extends StatelessWidget {
  Future<Map<String, dynamic>?> getGitLabUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final userMetadata = user.userMetadata;

      if (userMetadata != null) {
        return {
          'name': userMetadata['name'],
          'profile_picture_url': userMetadata['avatar_url'],
          'email': user.email,
        };
      }
    }
    return null;
  }

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getGitLabUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }

          final userProfile = snapshot.data;
          if (userProfile == null) {
            return Center(child: Text("Aucun profil trouvé."));
          }

          final photoUrl = userProfile['profile_picture_url'] ??
              'https://www.example.com/default-avatar.png';
          final name = userProfile['name'] ?? 'Nom Inconnu';
          final email = userProfile['email'] ?? 'Email inconnu';

          return Column(
            children: [
              // Partie supérieure : photo de profil, nom et email
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    SizedBox(height: 20),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),

              // Partie centrale : statistiques
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Marge à gauche et à droite
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Statistiques:",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text("Statistiques personnalisées à venir...", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),

              // Bouton de déconnexion en bas
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: Icon(Icons.logout),
                  label: Text("Se déconnecter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(currentRoute: '/profile'),
    );
  }
}