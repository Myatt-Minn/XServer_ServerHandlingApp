import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:xserver/app/data/Backup_Model.dart';
import 'package:xserver/app/data/Project_Model.dart';
import 'package:xserver/app/data/vars_config.dart';

class AddProjectToServerController extends GetxController {
  final TextEditingController projectenvironmentController =
      TextEditingController();
  final TextEditingController projectNameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController backupFrequencyController =
      TextEditingController();
  final TextEditingController techController = TextEditingController();
  var techList = <String>[].obs; // Reactive list for technology stack

  RxString selectedProjectType = ''.obs; // For dropdown selection
  late String serverId;
  // Dropdown items for Project Types
  RxList<String> projectTypes = <String>[].obs; // Load from Firestore
  // Variable to hold the selected date
  var selectedDeploymentDate = DateTime.now().obs;
  var selectedLastUpdatedDate = DateTime.now().obs;
  var selectedLastBackUpDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    serverId = Get.arguments;
    fetchProjectTypes();
    print(serverId);
  }

  // Fetch brands from Firestore
  Future<void> fetchProjectTypes() async {
    projectTypes.value = ProjectTypes.values.map((e) => e.name).toList();
  }

  Future<void> addProject() async {
    // Create a new Project object
    var uuid = const Uuid();
    String uuidString = uuid.v4();
    Project newProject = Project(
      projectId: uuidString,
      projectName: projectNameController.text.isNotEmpty
          ? projectNameController.text
          : "x",
      description: descriptionController.text.isNotEmpty
          ? descriptionController.text
          : "x",
      projectType: selectedProjectType.value,
      version: versionController.text.isNotEmpty ? versionController.text : "x",
      owner: ownerController.text.isNotEmpty ? ownerController.text : "x",
      contactInfo: contactInfoController.text.isNotEmpty
          ? contactInfoController.text
          : "x",
      technologyStack: techList,
      deploymentDate: selectedDeploymentDate.value,
      lastUpdated: selectedLastUpdatedDate.value,
      backupStatus: BackupStatus(
        lastBackupDate: selectedLastBackUpDate.value,
        backupFrequency: backupFrequencyController.text.isNotEmpty
            ? backupFrequencyController.text
            : "x",
      ),
      environment: projectenvironmentController.text.isNotEmpty
          ? projectenvironmentController.text
          : "x",
    );

    if (newProject.projectName!.isNotEmpty &&
        newProject.description!.isNotEmpty) {
      // Update the server document by adding the new project to the projects list
      try {
        await FirebaseFirestore.instance
            .collection('servers')
            .doc(serverId)
            .update({
          'projects': FieldValue.arrayUnion(
              [newProject.toMap()]), // Save project as map
        });

        // Clear the text fields after adding the project
        clearFields();

        Get.snackbar('Success', 'Project added successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to add project: $e');
      }
    } else {
      Get.snackbar('Error', 'Please fill a project first!');
    }
  }

  void clearFields() {
    projectNameController.clear();
    descriptionController.clear();
    selectedProjectType.value = '';
    versionController.clear();
    ownerController.clear();
    contactInfoController.clear();
    projectenvironmentController.clear();
    backupFrequencyController.clear();
    techList.clear(); // Clear technology stack
  }

  @override
  void onClose() {
    projectNameController.dispose();
    descriptionController.dispose();
    selectedProjectType.value = '';
    versionController.dispose();
    ownerController.dispose();
    contactInfoController.dispose();
    super.onClose();
  }

  // Function to open the date picker and update the selected date
  Future<void> selectLastBackUpDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );

    if (pickedDate != null && pickedDate != selectedLastBackUpDate.value) {
      selectedLastBackUpDate.value = pickedDate;
    }
  }

  // Function to open the date picker and update the selected date
  Future<void> selectDeploymentDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );

    if (pickedDate != null && pickedDate != selectedDeploymentDate.value) {
      selectedDeploymentDate.value = pickedDate;
    }
  }

  // Function to open the date picker and update the selected date
  Future<void> selectLastUpdatedDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );

    if (pickedDate != null && pickedDate != selectedLastUpdatedDate.value) {
      selectedLastUpdatedDate.value = pickedDate;
    }
  }

  // Function to add string to the list
  void addStringToList() {
    if (techController.text.isNotEmpty) {
      techList.add(techController.text); // Add input to the list
      techController.clear(); // Clear the input field
    }
  }
}
