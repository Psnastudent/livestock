import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedingService {
  // ── Seed all data to Firestore ─────────────────────────────────────────────
  static Future<void> seedDatabase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 1. Seed Plants
    try {
      final String plantsJson =
          await rootBundle.loadString('assets/data/plants.json');
      final List<dynamic> plantsList =
          json.decode(plantsJson) as List<dynamic>;
      for (var plantData in plantsList) {
        final String plantId = plantData['plantId'] as String;
        await firestore.collection('plants').doc(plantId).set(plantData);
      }
      // ignore: avoid_print
      print('Seeded plants successfully.');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to seed plants: $e');
      rethrow;
    }

    // 2. Seed Hospitals
    try {
      final String hospitalsJson =
          await rootBundle.loadString('assets/data/hospitals.json');
      final List<dynamic> hospitalsList =
          json.decode(hospitalsJson) as List<dynamic>;
      for (var hospitalData in hospitalsList) {
        final String name = hospitalData['name'] as String;
        await firestore.collection('hospitals').doc(name).set(hospitalData);
      }
      // ignore: avoid_print
      print('Seeded hospitals successfully.');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to seed hospitals: $e');
      rethrow;
    }
  }

  // ── Wipe all data from Firestore ───────────────────────────────────────────
  static Future<void> wipeDatabase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Delete all plant documents
    try {
      final plantsSnap = await firestore.collection('plants').get();
      for (final doc in plantsSnap.docs) {
        await doc.reference.delete();
      }
      // ignore: avoid_print
      print('Wiped plants successfully.');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to wipe plants: $e');
      rethrow;
    }

    // Delete all hospital documents
    try {
      final hospitalsSnap = await firestore.collection('hospitals').get();
      for (final doc in hospitalsSnap.docs) {
        await doc.reference.delete();
      }
      // ignore: avoid_print
      print('Wiped hospitals successfully.');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to wipe hospitals: $e');
      rethrow;
    }
  }
}
