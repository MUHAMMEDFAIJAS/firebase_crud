import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/controller/image_provider.dart';
import 'package:project/controller/provider.dart';
import 'package:project/firebase_options.dart';
import 'package:project/view/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Projectprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageProviderr(),
        ),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
