import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('NotificationService init error: $e');
  }

  // Initialize Firebase (safely handles when configuration files or network are pending)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully.');
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  runApp(
    const ProviderScope(
      child: LinguaGoApp(),
    ),
  );
}
