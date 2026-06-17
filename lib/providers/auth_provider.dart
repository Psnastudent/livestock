import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

// Riverpod StateProvider to manage the active UserProfile authentication state
final authProvider = StateProvider<UserProfile?>((ref) => null);
