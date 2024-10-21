import 'package:xserver/app/data/Project_Model.dart';

class Server {
  String? id;
  String? termiusName;
  String? serverName;
  String? ipAddress;
  String? region;
  String? serverType;
  String? status;
  String? environment;
  List<Project>? projects;

  Server({
    this.id,
    this.termiusName,
    this.serverName,
    this.ipAddress,
    this.region,
    this.serverType,
    this.status,
    this.environment,
    this.projects,
  });

  factory Server.fromMap(Map<String, dynamic> data) {
    return Server(
      id: data['id'],
      termiusName:
          (data['termius_name']?.isEmpty ?? true) ? "x" : data['termius_name'],
      serverName:
          (data['server_name']?.isEmpty ?? true) ? "x" : data['server_name'],
      ipAddress:
          (data['ip_address']?.isEmpty ?? true) ? "x" : data['ip_address'],
      region: (data['region']?.isEmpty ?? true) ? "x" : data['region'],
      serverType:
          (data['server_type']?.isEmpty ?? true) ? "x" : data['server_type'],
      status: (data['status']?.isEmpty ?? true) ? "x" : data['status'],
      environment:
          (data['environment']?.isEmpty ?? true) ? "x" : data['environment'],
      projects: (data['projects'] as List<dynamic>?)
              ?.map((project) => Project.fromMap(project))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'termius_name': termiusName?.isNotEmpty == true ? termiusName : "x",
      'server_name': serverName?.isNotEmpty == true ? serverName : "x",
      'ip_address': ipAddress?.isNotEmpty == true ? ipAddress : "x",
      'region': region?.isNotEmpty == true ? region : "x",
      'server_type': serverType?.isNotEmpty == true ? serverType : "x",
      'status': status?.isNotEmpty == true ? status : "x",
      'environment': environment?.isNotEmpty == true ? environment : "x",
      'projects': projects?.map((project) => project.toMap()).toList() ?? [],
    };
  }
}
