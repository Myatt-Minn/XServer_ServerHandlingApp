import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:xserver/app/data/Server_Model.dart';
import 'package:xserver/app/modules/home/views/serverdetails_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2E2F5B), // Background color
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Logo and Title
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 10),
                const Text(
                  'XServer',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (query) => controller.searchText(query),
                decoration: InputDecoration(
                  hintText: 'Search Servers...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Server List
            Expanded(
              child: Obx(() => controller.filteredServers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.filteredServers.length,
                      itemBuilder: (context, index) {
                        final server = controller.filteredServers[index];
                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            extentRatio: 0.3, // Reveal part of the action pane
                            children: [
                              SlidableAction(
                                onPressed: (context) => Get.offAndToNamed(
                                    '/edit-server',
                                    arguments: server),
                                backgroundColor: const Color(0xFF8E2DE2),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            extentRatio: 0.3,
                            children: [
                              SlidableAction(
                                onPressed: (context) =>
                                    _showDeleteConfirmation(context, server),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.purple[100],
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                  server.termiusName ?? 'Unknown Server',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${server.serverName} (${server.ipAddress})',
                                  style: const TextStyle(fontSize: 14)),
                              trailing: const Icon(Icons.arrow_forward,
                                  color: Colors.black),
                              onTap: () {
                                Get.to(() => ServerDetailView(),
                                    arguments: server);
                              },
                            ),
                          ),
                        );
                      },
                    )),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            // Handle adding a new server
            Get.offAndToNamed('add-server');
          },
          backgroundColor: Colors.purple,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Server server) {
    Get.defaultDialog(
      title: "Delete Item",
      middleText: "Are you sure you want to delete this item?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteServer(server.id!);
        Get.back();
      },
      onCancel: () {},
    );
  }
}
