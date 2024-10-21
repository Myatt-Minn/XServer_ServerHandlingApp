import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:xserver/app/data/Backup_Model.dart';
import 'package:xserver/app/data/Project_Model.dart';
import 'package:xserver/app/data/Server_Model.dart';
import 'package:xserver/app/data/vars_config.dart';

class AddServerController extends GetxController {
  // Server Fields
  final TextEditingController termiusNameController = TextEditingController();
  final TextEditingController serverNameController = TextEditingController();
  final TextEditingController ipAddressController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController serverTypeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController environmentController = TextEditingController();
  final TextEditingController projectenvironmentController =
      TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController backupFrequencyController =
      TextEditingController();
  // Variable to hold the selected date
  var selectedDeploymentDate = DateTime.now().obs;
  var selectedLastUpdatedDate = DateTime.now().obs;
  var selectedLastBackUpDate = DateTime.now().obs;

  RxString selectedProjectType = ''.obs; // For dropdown selection

  // Project Fields
  RxList<Project> projects = <Project>[].obs;

  // Dropdown items for Project Types
  RxList<String> projectTypes = <String>[].obs; // Load from Firestore
  // List to store the strings
  RxList<String> techList = <String>[].obs;

  // Controller to capture text input
  final TextEditingController techController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProjectTypes(); // Fetch the project types from Firestore
  }

  // Fetch brands from Firestore
  Future<void> fetchProjectTypes() async {
    projectTypes.value = ProjectTypes.values.map((e) => e.name).toList();
  }

  void addProject() {
    var uuid = const Uuid();
    String uuidString = uuid.v4();

    if (projectNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      // Check if controllers are empty and provide a default value or null
      String projectName = projectNameController.text.isNotEmpty
          ? projectNameController.text
          : "x";
      String description = descriptionController.text.isNotEmpty
          ? descriptionController.text
          : "x";
      String version =
          versionController.text.isNotEmpty ? versionController.text : "x";
      String environment = projectenvironmentController.text.isNotEmpty
          ? projectenvironmentController.text
          : "x";
      String owner =
          ownerController.text.isNotEmpty ? ownerController.text : "x";
      String contactInfo = contactInfoController.text.isNotEmpty
          ? contactInfoController.text
          : "x";
      String backupFrequency = backupFrequencyController.text.isNotEmpty
          ? backupFrequencyController.text
          : "x";
      // Create a copy of the current techList to avoid clearing the list later
      List<String> copiedTechList = List.from(techList);
      projects.add(Project(
        projectId: uuidString,
        projectName: projectName,
        description: description,
        projectType: selectedProjectType.value,
        version: version,
        deploymentDate: selectedDeploymentDate.value,
        lastUpdated: selectedLastUpdatedDate.value,
        technologyStack: copiedTechList,
        environment: environment,
        owner: owner,
        contactInfo: contactInfo,
        backupStatus: BackupStatus(
          lastBackupDate: selectedLastBackUpDate.value,
          backupFrequency: backupFrequency,
        ),
      ));

      Get.snackbar('Added', 'Project Added to the Server');
      clearProjectFields();
    } else {
      Get.snackbar('Error', 'Please fill a project name first!');
    }
  }

  void clearProjectFields() {
    projectNameController.clear();
    descriptionController.clear();
    versionController.clear();
    projectenvironmentController.clear();
    contactInfoController.clear();
    ownerController.clear();
    selectedProjectType.value = '';
    selectedDeploymentDate.value = DateTime.now();
    selectedLastUpdatedDate.value = DateTime.now();
    selectedLastBackUpDate.value = DateTime.now();
    backupFrequencyController.clear();
    techController.clear();
    techList.clear();
  }

  // Save the Server to Firestore
  Future<void> saveServer() async {
    var docRef = FirebaseFirestore.instance.collection('servers').doc();
    if (serverNameController.text.isNotEmpty) {
      final server = Server(
          id: docRef.id,
          termiusName: termiusNameController.text,
          serverName: serverNameController.text,
          ipAddress: ipAddressController.text,
          region: regionController.text,
          serverType: serverTypeController.text,
          status: statusController.text,
          environment: environmentController.text,
          projects: projects);

      // Save to Firestore
      docRef.set(server.toMap());
      Get.snackbar('Saved', 'Server has saved to the database');
      // Clear inputs after save
      clearInputs();
    } else {
      Get.snackbar('Error', 'Please fill a server name first!');
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

  // Clear all inputs after saving
  void clearInputs() {
    termiusNameController.clear();
    serverNameController.clear();
    ipAddressController.clear();
    regionController.clear();
    serverTypeController.clear();
    statusController.clear();
    environmentController.clear();
    projects.clear();
  }
}
