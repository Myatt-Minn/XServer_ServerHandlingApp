import 'package:cloud_firestore/cloud_firestore.dart';

class BackupStatus {
  DateTime? lastBackupDate;
  String? backupFrequency;

  BackupStatus({
    this.lastBackupDate,
    this.backupFrequency,
  });

  factory BackupStatus.fromMap(Map<String, dynamic> data) {
    return BackupStatus(
      lastBackupDate:
          (data['last_backup_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      backupFrequency: data['backup_frequency'] ?? "x",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'last_backup_date': lastBackupDate ?? "x",
      'backup_frequency': backupFrequency ?? "x",
    };
  }
}
