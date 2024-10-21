import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xserver/app/data/Project_Model.dart';
import 'package:xserver/app/data/Server_Model.dart';
import 'package:xserver/app/modules/home/controllers/home_controller.dart';

class ServerDetailView extends StatelessWidget {
  final Server server = Get.arguments;

  ServerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(server.termiusName ?? 'Server Details',
            style: const TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Container(
        color: const Color(0xFF2E2F5B),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildDetailTile('Server Name', server.serverName),
            _buildDetailTile('IP Address', server.ipAddress),
            _buildDetailTile('Region', server.region),
            _buildDetailTile('Status', server.status),
            _buildDetailTile('Environment', server.environment),
            _buildDetailTile('Server Type', server.serverType),
            const SizedBox(height: 16),
            ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Text(
                'Projects (${server.projects?.length ?? 0})',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              children: server.projects?.map((project) {
                    return _buildProjectTile(project, context);
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildDetailTile(String title, String? value) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontSize: 18, color: Colors.white)),
      subtitle: Text(value ?? 'N/A',
          style: const TextStyle(fontSize: 16, color: Colors.white70)),
    );
  }

  Widget _buildProjectTile(Project project, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(project.projectName!,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            IconButton(
              onPressed: () => _showDeleteProjectDialog(context, project),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${project.description}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text(
                'Project Type: ${project.projectType.toString().split('.').last}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text('Version: ${project.version}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text(
                'Deployment Date: ${project.deploymentDate?.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text(
                'Last Updated: ${project.lastUpdated?.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text('Technology Stack: ${project.technologyStack?.join(', ')}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text('Environment: ${project.environment}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text('Owner: ${project.owner}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text('Contact Info: ${project.contactInfo}',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text(
                'Last Backup: ${project.backupStatus?.lastBackupDate?.toLocal().toString().split(' ')[0]} (Frequency: ${project.backupStatus?.backupFrequency})',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showDeleteProjectDialog(BuildContext context, Project project) {
    Get.defaultDialog(
      title: "Delete Project",
      middleText: "Are you sure you want to delete this project?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Call the controller to delete the project
        final controller = Get.find<HomeController>();
        controller.deleteProject(server.id!, project);
        Get.back(); // Close the dialog
      },
      onCancel: () {},
    );
  }
}
