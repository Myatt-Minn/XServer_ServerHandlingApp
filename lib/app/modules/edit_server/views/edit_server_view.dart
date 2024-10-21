import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_server_controller.dart';

class EditServerView extends GetView<EditServerController> {
  const EditServerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        title: const Text(
          'Edit Server',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.offNamed('home'),
        ),
        actions: [
          GestureDetector(
              onTap: () =>
                  Get.offAndToNamed('add-project', arguments: Get.arguments.id),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Add Project',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ))
        ],
      ),
      resizeToAvoidBottomInset: true, // Allows resizing when keyboard is open
      body: Container(
        color: const Color(0xFF2E2F5B),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16), // Padding around the form
          child: Card(
            color: Colors.purple[100],
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text('Server Information',
                          style: TextStyle(fontSize: 20))),
                  TextField(
                    controller: controller.termiusNameController,
                    decoration:
                        const InputDecoration(labelText: 'Termius Name'),
                  ),
                  TextField(
                    controller: controller.serverNameController,
                    decoration: const InputDecoration(labelText: 'Server Name'),
                  ),
                  TextField(
                    controller: controller.ipAddressController,
                    decoration: const InputDecoration(labelText: 'IP Address'),
                  ),
                  TextField(
                    controller: controller.regionController,
                    decoration: const InputDecoration(labelText: 'Region'),
                  ),
                  TextField(
                    controller: controller.serverTypeController,
                    decoration: const InputDecoration(labelText: 'Server Type'),
                  ),
                  TextField(
                    controller: controller.statusController,
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  TextField(
                    controller: controller.environmentController,
                    decoration: const InputDecoration(labelText: 'Environment'),
                  ),
                  const SizedBox(height: 16),

                  // Project Information Section
                  Obx(() => Column(
                        children: [
                          const Center(
                              child: Text('Project Information',
                                  style: TextStyle(fontSize: 18))),
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Dropdown to select a project for editing
                                    DropdownButton<int>(
                                      value: controller
                                                  .selectedProjectIndex.value !=
                                              -1
                                          ? controller
                                              .selectedProjectIndex.value
                                          : null,
                                      hint:
                                          const Text('Select Project to Edit'),
                                      items: List.generate(
                                        controller.projects.length,
                                        (index) {
                                          return DropdownMenuItem<int>(
                                            value: index,
                                            child: Text(controller
                                                .projects[index].projectName!),
                                          );
                                        },
                                      ),
                                      onChanged: (newIndex) {
                                        controller.selectedProjectIndex.value =
                                            newIndex!;
                                        // Load the selected project's data into text fields
                                        controller.loadProjectData(newIndex);
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // Display project details for editing
                                    if (controller.selectedProjectIndex.value !=
                                        -1) ...[
                                      TextFormField(
                                        controller:
                                            controller.projectNameController,
                                        decoration: const InputDecoration(
                                            labelText: 'Project Name'),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller:
                                            controller.projectDescController,
                                        decoration: const InputDecoration(
                                            labelText: 'Project Description'),
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: controller.selectedProjectType
                                                .value.isNotEmpty
                                            ? controller
                                                .selectedProjectType.value
                                            : null,
                                        hint: const Text('Select Project Type'),
                                        items:
                                            controller.projectTypes.map((type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          controller.selectedProjectType.value =
                                              value!;
                                        },
                                        isExpanded: true,
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: controller
                                            .projectenvironmentController,
                                        decoration: const InputDecoration(
                                            labelText: 'Environment'),
                                      ),
                                      const SizedBox(height: 16),
                                      // Button to update size
                                      TextFormField(
                                        controller: controller.techController,
                                        decoration: const InputDecoration(
                                          labelText: 'Technology',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),

                                      const SizedBox(width: 8),
                                      Obx(
                                        () => ElevatedButton(
                                          onPressed: () {
                                            if (controller
                                                .isEditingSize.value) {
                                              controller.updateTech(controller
                                                  .techController.text);
                                            } else {
                                              controller.addTech(controller
                                                  .techController.text);
                                            }
                                          },
                                          child: Text(
                                              controller.isEditingSize.value
                                                  ? 'Update Tech'
                                                  : 'Add Tech'),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Display the list of added sizes
                                      Obx(() => ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                controller.techList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .setSizeForEditing(index);
                                                },
                                                child: ListTile(
                                                  title: Text(controller
                                                      .techList[index]),
                                                  trailing: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      controller
                                                          .deleteSize(index);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          )),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller:
                                            controller.versionController,
                                        decoration: const InputDecoration(
                                            labelText: 'Version'),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () => controller
                                            .selectDeploymentDate(context),
                                        child: const Text(
                                            'Select Deployment Date'),
                                      ),
                                      TextField(
                                        controller: controller.ownerController,
                                        decoration: const InputDecoration(
                                            labelText: 'Owner'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => controller
                                            .selectLastUpdatedDate(context),
                                        child: const Text(
                                            'Select Last Updated Date'),
                                      ),
                                      TextField(
                                        controller:
                                            controller.contactInfoController,
                                        decoration: const InputDecoration(
                                            labelText: 'Contact Info'),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: controller
                                            .backupFrequencyController,
                                        decoration: const InputDecoration(
                                            labelText: 'Backup Frequency'),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () => controller
                                            .selectLastBackUpDate(context),
                                        child: const Text(
                                            'Select Last Backup Date'),
                                      ),
                                    ],
                                  ]),
                            ),
                          ),

                          // Edit Project Button
                          ElevatedButton(
                            onPressed: () {
                              int selectedIndex =
                                  controller.selectedProjectIndex.value;
                              if (selectedIndex != -1) {
                                controller.editProject(selectedIndex);
                              }
                            },
                            child: const Text('Update Project'),
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),

                  // Update button
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: controller.updateServer,
                      child: const Text('Update Server'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
