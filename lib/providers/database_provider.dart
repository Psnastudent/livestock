import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/plant.dart';
import '../models/hospital.dart';
import '../services/database_service.dart';

// Provides DatabaseService instance
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

// Asynchronously provides list of plants
final plantsProvider = FutureProvider<List<Plant>>((ref) async {
  final service = ref.watch(databaseServiceProvider);
  return service.getPlants();
});

// Asynchronously provides list of hospitals
final hospitalsProvider = FutureProvider<List<Hospital>>((ref) async {
  final service = ref.watch(databaseServiceProvider);
  return service.getHospitals();
});
