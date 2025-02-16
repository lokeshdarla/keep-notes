import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:notes_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensures everything is ready
  await Hive.initFlutter(); // ✅ Initialize Hive before using it

  await NoteDatabase.initialize(); // ✅ Now it will work

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      home: HomeScreen(),
    );
  }
}
