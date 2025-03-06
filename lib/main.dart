import 'package:flutter/material.dart';
import 'package:vitallinkv2/screens/intropage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    //run intropage
    home: Intropage(),
  ));
}
