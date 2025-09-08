import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  print('🔥 Firebase: Initializing Firebase...');
  await Firebase.initializeApp();
  print('✅ Firebase: Firebase initialized successfully!');
  print('🔥 Firebase: Default app name: ${Firebase.app().name}');
  print(
    '🔥 Firebase: Default app options: ${Firebase.app().options.projectId}',
  );

  // Initialize Hive
  await Hive.initFlutter();
  await LocalStorage.init();

  runApp(const ProviderScope(child: ShunnoPrangonApp()));
}
