class PeriodLogModel {
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

  PeriodLogModel({
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
  });

  factory PeriodLogModel.fromMap(Map<String, dynamic> map) {
    return PeriodLogModel(
      startDate: map['start_date'].toDate(),
      endDate: map['end_date'] != null
          ? map['end_date'].toDate()
          : null,
      cycleLength: map['cycle_length'] ?? 28,
      periodDuration: map['period_duration'] ?? 5,
      painLevel: map['pain_level'] ?? 0,
      energyLevel: map['energy_level'] ?? 0,
      flowIntensity: map['flow_intensity'] ?? '',
      mood: map['mood'] ?? '',
      notes: map['notes'] ?? '',
      symptoms: map['symptoms'] ?? [],
    );
  }
}