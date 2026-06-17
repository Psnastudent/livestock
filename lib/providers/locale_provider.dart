import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple StateProvider to manage the active language code ('en' or 'ta')
final localeProvider = StateProvider<String>((ref) => 'en');
