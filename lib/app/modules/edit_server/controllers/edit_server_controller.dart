import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xserver/app/data/Backup_Model.dart';
import 'package:xserver/app/data/Project_Model.dart';
import 'package:xserver/app/data/Server_Model.dart';
import 'package:xserver/app/data/vars_config.dart';

class EditServerController extends GetxController {
// Server Fields (initialized with existing server data)
  final TextEditingController termiusNameController = TextEditingController();
  final TextEditingController serverNameController = TextEditingController();
  final TextEditingController ipAddressController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController serverTypeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController environmentController = TextEditingController();
  final TextEditingController projectenvironmentController =
      TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController backupFrequencyController =
      TextEditingController();

  var currentEditIndex = -1.obs;
  Server server = Get.arguments;
  RxString selectedProjectType = ''.obs;
  RxList<Project> projects = <Project>[].obs;
  RxList<String> techList = <String>[].obs;
  RxList<String> projectTypes = <String>[].obs;
  var selectedDeploymentDate = DateTime.now().obs;
  var selectedLastUpdatedDate = DateTime.now().obs;
  var selectedLastBackUpDate = DateTime.now().obs;
  final TextEditingController techController = TextEditingController();
  var selectedProjectIndex = (-1).obs;
  var isEditingSize = false.obs;
  String projectId = "";
  @override
  void onInit() {
    super.onInit();

    // Populate fields with existing server data
    termiusNameController.text = server.termiusName!;
    serverNameController.text = server.serverName!;
    ipAddressController.text = server.ipAddress!;
    regionController.text = server.region!;
    serverTypeController.text = server.serverType!;
    statusController.text = server.status!;
    environmentController.text = server.environment!;

    projects.value = server.projects!;

    fetchProjectTypes(); // Load project types
  }

  // Fetch project types from Firestore
  Future<void> fetchProjectTypes() async {
    projectTypes.value = ProjectTypes.values.map((e) => e.name).toList();
  }

  // Load project data into text fields for editing
  void loadProjectData(int index) {
    Project project = projects[index];
    projectId = project.projectId!;
    projectNameController.text = project.projectName!;
    projectDescController.text = project.description!;
    versionController.text = project.version!;
    backupFrequencyController.text = project.backupStatus!.backupFrequency!;
    ownerController.text = project.owner!;
    contactInfoController.text = project.contactInfo!;
    selectedProjectType.value = project.projectType!;
    selectedDeploymentDate.value = project.deploymentDate!;
    selectedLastUpdatedDate.value = project.lastUpdated!;
    selectedLastBackUpDate.value = project.backupStatus!.lastBackupDate!;
    projectenvironmentController.text = project.environment!;
    techList.value = project.technologyStack!;
    selectedDeploymentDate.value = project.deploymentDate!;
    selectedLastUpdatedDate.value = project.lastUpdated!;
    selectedLastBackUpDate.value = project.backupStatus!.lastBackupDate!;
  }

  // Edit an existing project
  void editProject(int index) {
    Project editedProject = projects[index];

    editedProject = Project(
      projectId: projectId,
      projectName: projectNameController.text,
      description: projectDescController.text,
      projectType: selectedProjectType.value,
      technologyStack: techList,
      version: versionController.text,
      deploymentDate: selectedDeploymentDate.value,
      lastUpdated: selectedLastUpdatedDate.value,
      environment: projectenvironmentController.text,
      owner: ownerController.text,
      contactInfo: contactInfoController.text,
      backupStatus: BackupStatus(
        backupFrequency: backupFrequencyController.text,
        lastBackupDate: selectedLastBackUpDate.value,
      ),
    );

    // Update the project in the list
    projects[index] = editedProject;

    Get.snackbar('Updated', 'Project has been updated successfully');
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
    techList.clear();
    projects.clear();
    backupFrequencyController.clear();
    ownerController.clear();
    contactInfoController.clear();
    projectenvironmentController.clear();
    projectNameController.clear();
    projectDescController.clear();
    versionController.clear();
    selectedProjectType.value = '';
    selectedDeploymentDate.value = DateTime.now();
    selectedLastUpdatedDate.value = DateTime.now();
    selectedLastBackUpDate.value = DateTime.now();
  }

  // Save the updated server data
  Future<void> updateServer() async {
    var docRef =
        FirebaseFirestore.instance.collection('servers').doc(server.id);
    final updatedServer = Server(
      id: server.id,
      termiusName: termiusNameController.text,
      serverName: serverNameController.text,
      ipAddress: ipAddressController.text,
      region: regionController.text,
      serverType: serverTypeController.text,
      status: statusController.text,
      environment: environmentController.text,
      projects: projects,
    );

    await docRef.set(updatedServer.toMap());
    clearInputs();
    Get.snackbar('Updated', 'Server has been updated');
  }

  Future<void> selectLastUpdatedDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedLastUpdatedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedLastUpdatedDate.value = pickedDate;
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

  Future<void> selectLastBackUpDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedLastBackUpDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedLastBackUpDate.value = pickedDate;
    }
  }

  // Method to add size data
  void addTech(String text) {
    try {
      techList.add(text);
      techController.clear();
    } catch (e) {
      Get.snackbar("Error", "Please fill the input fields first!",
          backgroundColor: Colors.red);
    }
  }

//Update existing size
  void updateTech(String text) {
    try {
      if (currentEditIndex >= 0) {
        techList[currentEditIndex] = text;
        isEditingSize.value = false;
        currentEditIndex = -1;
        techController.clear();
      } else {
        Get.snackbar("Error", "Please select size first!",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Please select size first!",
          backgroundColor: Colors.red);
    }
  }

  // Set size for editing
  void setSizeForEditing(int index) {
    final techData = techList[index];
    techController.text = techData;

    isEditingSize.value = true;
    currentEditIndex = index;
  }

  // Delete size
  void deleteSize(int index) {
    techList.remove(techList[index]);
  }

  void addStringToList() {
    if (techController.text.isNotEmpty) {
      techList.add(techController.text);
      techController.clear();
    }
  }
}
