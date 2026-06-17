import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant.dart';
import '../models/hospital.dart';

class DatabaseService {
  // Safely get FirebaseFirestore instance without crashing if Firebase failed to initialize
  FirebaseFirestore? get _firestore {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      developer.log('Firebase Firestore is not available: $e');
      return null;
    }
  }

  // Fetch plants with fallback to assets
  Future<List<Plant>> getPlants() async {
    final firestore = _firestore;
    if (firestore != null) {
      try {
        // Query firestore with a 3-second timeout
        final QuerySnapshot snapshot = await firestore
            .collection('plants')
            .get()
            .timeout(const Duration(seconds: 3));

        if (snapshot.docs.isNotEmpty) {
          developer.log('Fetched plants from Firestore successfully.');
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['plantId'] = doc.id;
            return Plant.fromMap(data);
          }).toList();
        }
      } catch (e) {
        developer.log('Firestore plant read failed or timed out: $e. Falling back to local asset.');
      }
    } else {
      developer.log('Firestore is uninitialized. Directing to offline fallback.');
    }

    // Local JSON Fallback
    try {
      final String jsonString = await rootBundle.loadString('assets/data/plants.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      developer.log('Loaded plants from local JSON asset.');
      return jsonList.map((item) => Plant.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error reading local plants asset: $e');
      return [];
    }
  }

  // Fetch hospitals with fallback to assets
  Future<List<Hospital>> getHospitals() async {
    final firestore = _firestore;
    if (firestore != null) {
      try {
        final QuerySnapshot snapshot = await firestore
            .collection('hospitals')
            .get()
            .timeout(const Duration(seconds: 3));

        if (snapshot.docs.isNotEmpty) {
          developer.log('Fetched hospitals from Firestore successfully.');
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Hospital.fromMap(data);
          }).toList();
        }
      } catch (e) {
        developer.log('Firestore hospital read failed or timed out: $e. Falling back to local asset.');
      }
    } else {
      developer.log('Firestore is uninitialized. Directing to offline fallback.');
    }

    // Local JSON Fallback
    try {
      final String jsonString = await rootBundle.loadString('assets/data/hospitals.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      developer.log('Loaded hospitals from local JSON asset.');
      return jsonList.map((item) => Hospital.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error reading local hospitals asset: $e');
      return [];
    }
  }
}
