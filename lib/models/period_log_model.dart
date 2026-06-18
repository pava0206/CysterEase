import 'package:cloud_firestore/cloud_firestore.dart';

class PeriodLogModel {
  final String? id;
  final DateTime startDate;
  final DateTime? endDate;

  final int cycleLength;
  final int periodDuration;

  final int painLevel;
  final int energyLevel;

  final String flowIntensity;
  final String mood;

  final String notes;
  final List<dynamic> symptoms;

  final DateTime? createdAt;

  PeriodLogModel({
    this.id,
    required this.startDate,
    this.endDate,
    required this.cycleLength,
    required this.periodDuration,
    required this.painLevel,
    required this.energyLevel,
    required this.flowIntensity,
    required this.mood,
    required this.notes,
    required this.symptoms,
    this.createdAt,
  });

  factory PeriodLogModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return PeriodLogModel(
      id: id ?? map['id'],
      startDate: (map['start_date'] as Timestamp).toDate(),
      endDate: map['end_date'] != null
          ? (map['end_date'] as Timestamp).toDate()
          : null,
      cycleLength: map['cycle_length'] ?? 28,
      periodDuration: map['period_duration'] ?? 5,
      painLevel: map['pain_level'] ?? 0,
      energyLevel: map['energy_level'] ?? 0,
      flowIntensity: map['flow_intensity'] ?? '',
      mood: map['mood'] ?? '',
      notes: map['notes'] ?? '',
      symptoms: map['symptoms'] ?? [],
      createdAt: map['created_at'] != null
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_date': Timestamp.fromDate(startDate),
      'end_date': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'cycle_length': cycleLength,
      'period_duration': periodDuration,
      'pain_level': painLevel,
      'energy_level': energyLevel,
      'flow_intensity': flowIntensity,
      'mood': mood,
      'notes': notes,
      'symptoms': symptoms,
    };
  }

  PeriodLogModel copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    int? cycleLength,
    int? periodDuration,
    int? painLevel,
    int? energyLevel,
    String? flowIntensity,
    String? mood,
    String? notes,
    List<dynamic>? symptoms,
  }) {
    return PeriodLogModel(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodDuration: periodDuration ?? this.periodDuration,
      painLevel: painLevel ?? this.painLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
      symptoms: symptoms ?? this.symptoms,
      createdAt: createdAt,
    );
  }

  /// Duration of the period in days (if end date is set)
  int? get durationInDays {
    if (endDate == null) return null;
    return endDate!.difference(startDate).inDays + 1;
  }

  /// Human-readable date string
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${startDate.day} ${months[startDate.month - 1]} ${startDate.year}';
  }

  @override
  String toString() => 'PeriodLogModel(id: $id, startDate: $startDate, flow: $flowIntensity)';
}