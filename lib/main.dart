import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- ajout pour .env
import 'firebase_options.dart';
import 'pages/splash_screen.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement depuis le fichier .env
  await dotenv.load(fileName: ".env");

  // Initialiser Firebase avec les options selon la plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
