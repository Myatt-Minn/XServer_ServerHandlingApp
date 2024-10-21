import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xserver/app/data/Project_Model.dart';
import 'package:xserver/app/data/Server_Model.dart';

class HomeController extends GetxController {
  RxList<Server> servers = RxList<Server>();

  var filteredServers = <Server>[].obs; // To store filtered results
  var searchText = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchServers();
    // Listen to changes in the searchText and filter the servers accordingly
    ever(searchText, (_) => filterServers());
  }

  void fetchServers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('servers').get();
      List<Server> fetchedServers = querySnapshot.docs.map((doc) {
        return Server.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      servers.assignAll(fetchedServers);
      filteredServers.value = servers; // Initially, show all servers
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch server data");
    }
  }

  void filterServers() {
    if (searchText.value.isEmpty) {
      filteredServers.value = servers; // No search, show all servers
    } else {
      filteredServers.value = servers.where((server) {
        // Check if serverName or termiusName contains the search text
        bool serverNameMatch = (server.serverName
                    ?.toLowerCase()
                    .contains(searchText.value.toLowerCase()) ??
                false) ||
            (server.termiusName
                    ?.toLowerCase()
                    .contains(searchText.value.toLowerCase()) ??
                false);

        // Check if any projectName in the projects list contains the search text
        bool projectNameMatch = server.projects?.any((project) =>
                project.projectName
                    ?.toLowerCase()
                    .contains(searchText.value.toLowerCase()) ??
                false) ??
            false;

        return serverNameMatch || projectNameMatch;
      }).toList();
    }
  }

  Future<void> deleteServer(String serverId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('servers')
          .doc(serverId)
          .delete();
      fetchServers();

      Get.snackbar(
        'Success',
        'payment deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar(
        'Error',
        'Failed to delete payment: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void deleteProject(String serverId, Project project) async {
    try {
      // Get the server's document from Firestore
      DocumentReference serverRef =
          FirebaseFirestore.instance.collection('servers').doc(serverId);

      // Remove the project from the projects field
      await serverRef.update({
        'projects': FieldValue.arrayRemove([project.toMap()])
      });

      // Optionally update the local list of servers
      servers.value = servers.map((server) {
        if (server.id == serverId) {
          server.projects!.remove(project);
        }
        return server;
      }).toList();

      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete project: $e");
    }
  }
}
