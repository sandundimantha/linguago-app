import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global theme mode provider for toggling between Light and Dark themes.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

