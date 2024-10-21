import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xserver/app/data/Backup_Model.dart';

class Project {
  String? projectId;
  String? projectName;
  String? description;
  String? projectType;
  List<String>? technologyStack;
  String? version;
  DateTime? deploymentDate;
  DateTime? lastUpdated;
  BackupStatus? backupStatus;
  String? environment;
  String? owner;
  String? contactInfo;

  Project({
    this.projectId,
    this.projectName,
    this.description,
    this.projectType,
    this.technologyStack,
    this.version,
    this.deploymentDate,
    this.lastUpdated,
    this.backupStatus,
    this.environment,
    this.owner,
    this.contactInfo,
  });

  factory Project.fromMap(Map<String, dynamic> data) {
    return Project(
      projectId: (data['projectId'] != null && data['projectId'].isNotEmpty)
          ? data['projectId']
          : "x",
      projectName:
          (data['project_name'] != null && data['project_name'].isNotEmpty)
              ? data['project_name']
              : "x",
      description:
          (data['description'] != null && data['description'].isNotEmpty)
              ? data['description']
              : "x",
      projectType:
          (data['project_type'] != null && data['project_type'].isNotEmpty)
              ? data['project_type']
              : "x",
      technologyStack: List<String>.from(data['technology_stack'] ?? []),
      version: (data['version'] != null && data['version'].isNotEmpty)
          ? data['version']
          : "x",
      deploymentDate:
          (data['deployment_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUpdated:
          (data['last_updated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      backupStatus: data['backup_status'] != null
          ? BackupStatus.fromMap(data['backup_status'])
          : BackupStatus(lastBackupDate: DateTime.now(), backupFrequency: "x"),
      environment:
          (data['environment'] != null && data['environment'].isNotEmpty)
              ? data['environment']
              : "x",
      owner: (data['owner'] != null && data['owner'].isNotEmpty)
          ? data['owner']
          : "x",
      contactInfo:
          (data['contact_info'] != null && data['contact_info'].isNotEmpty)
              ? data['contact_info']
              : "x",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId!.isNotEmpty ? projectId : "x",
      'project_name': projectName!.isNotEmpty ? projectName : "x",
      'description': description!.isNotEmpty ? description : "x",
      'project_type': projectType!.isNotEmpty ? projectType : "x",
      'technology_stack': technologyStack ?? [],
      'version': version!.isNotEmpty ? version : "x",
      'deployment_date': deploymentDate != null
          ? Timestamp.fromDate(deploymentDate!)
          : Timestamp.now(),
      'last_updated': lastUpdated != null
          ? Timestamp.fromDate(lastUpdated!)
          : Timestamp.now(),
      'backup_status': backupStatus?.toMap() ?? {},
      'environment': environment!.isNotEmpty ? environment : "x",
      'owner': owner!.isNotEmpty ? owner : "x",
      'contact_info': contactInfo!.isNotEmpty ? contactInfo : "x",
    };
  }
}
