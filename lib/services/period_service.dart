import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeriodService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get user => auth.currentUser;

  /// Save a new period log to Firestore
  Future<void> savePeriodLog({
    required DateTime startDate,
    DateTime? endDate,
    required int cycleLength,
    required int periodDuration,
    required int painLevel,
    required int energyLevel,
    required String flowIntensity,
    required String mood,
    required String notes,
    required List<String> symptoms,
  }) async {
    if (user == null) throw Exception('User not logged in');

    await firestore
        .collection('users')
        .doc(user!.uid)
        .collection('period_logs')
        .add({
      'start_date': Timestamp.fromDate(startDate),
      'end_date': endDate != null ? Timestamp.fromDate(endDate) : null,
      'cycle_length': cycleLength,
      'period_duration': periodDuration,
      'pain_level': painLevel,
      'energy_level': energyLevel,
      'flow_intensity': flowIntensity,
      'mood': mood,
      'notes': notes,
      'symptoms': symptoms,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Fetch all period logs ordered by start date descending
  Future<QuerySnapshot> fetchLogs() async {
    if (user == null) throw Exception('User not logged in');

    return firestore
        .collection('users')
        .doc(user!.uid)
        .collection('period_logs')
        .orderBy('start_date', descending: true)
        .get();
  }

  /// Delete a specific period log by document ID
  Future<void> deleteLog(String logId) async {
    if (user == null) throw Exception('User not logged in');

    await firestore
        .collection('users')
        .doc(user!.uid)
        .collection('period_logs')
        .doc(logId)
        .delete();
  }

  /// Update an existing period log
  Future<void> updateLog({
    required String logId,
    required Map<String, dynamic> data,
  }) async {
    if (user == null) throw Exception('User not logged in');

    await firestore
        .collection('users')
        .doc(user!.uid)
        .collection('period_logs')
        .doc(logId)
        .update({
      ...data,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}