import 'package:shamsi_date/shamsi_date.dart';

class BloodSugarEntry {
  final int? id;
  final int year;
  final int month;
  final int day;
  final double bloodSugar;
  final bool isFasting;
  final DateTime timestamp;

  BloodSugarEntry({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.bloodSugar,
    required this.isFasting,
    required this.timestamp,
  });

  // Create from current Persian date
  factory BloodSugarEntry.fromToday({
    required double bloodSugar,
    required bool isFasting,
  }) {
    final now = DateTime.now();
    final jalali = Jalali.fromDateTime(now);
    return BloodSugarEntry(
      year: jalali.year,
      month: jalali.month,
      day: jalali.day,
      bloodSugar: bloodSugar,
      isFasting: isFasting,
      timestamp: now,
    );
  }

  // Convert to map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'blood_sugar': bloodSugar,
      'is_fasting': isFasting ? 1 : 0,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Create from database map
  factory BloodSugarEntry.fromMap(Map<String, dynamic> map) {
    return BloodSugarEntry(
      id: map['id'] as int?,
      year: map['year'] as int,
      month: map['month'] as int,
      day: map['day'] as int,
      bloodSugar: map['blood_sugar'] as double,
      isFasting: map['is_fasting'] == 1,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  // Get formatted Persian date
  String getFormattedDate() {
    return '$year/$month/$day';
  }

  // Get Jalali date object
  Jalali getJalaliDate() {
    return Jalali(year, month, day);
  }
}
