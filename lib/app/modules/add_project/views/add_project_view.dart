import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_project_controller.dart';

class AddProjectToServerView extends GetView<AddProjectToServerController> {
  const AddProjectToServerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.offNamed('home'),
        ),
        title: const Text(
          'Add Project to Server',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF2E2F5B),
          padding: const EdgeInsets.all(16.0),
          child: // Project Information Section
              Obx(() => Column(
                    children: [
                      const Center(
                          child: Text('Project Information',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white))),
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: controller.projectNameController,
                                decoration: const InputDecoration(
                                    labelText: 'Project Name'),
                              ),
                              TextField(
                                controller: controller.descriptionController,
                                decoration: const InputDecoration(
                                    labelText: 'Project Description'),
                              ),
                              // Dropdown for Brand

                              DropdownButtonFormField<String>(
                                value: controller
                                        .selectedProjectType.value.isNotEmpty
                                    ? controller.selectedProjectType.value
                                    : null,
                                hint: const Text('Select Project Type'),
                                items: controller.projectTypes.map((brand) {
                                  return DropdownMenuItem<String>(
                                    value: brand,
                                    child: Text(brand),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectedProjectType.value = value!;
                                },
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a project Type';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),
                              TextField(
                                controller:
                                    controller.projectenvironmentController,
                                decoration: const InputDecoration(
                                    labelText: 'Environment'),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextField(
                                    controller: controller.techController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter a Technology',
                                      hintText: 'Flutter',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: controller.addStringToList,
                                    child: const Text('Add to Tech List'),
                                  ),
                                ],
                              ),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.techList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            16.0), // Add horizontal padding to control width
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(controller.techList[index]),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              TextField(
                                controller: controller.versionController,
                                decoration:
                                    const InputDecoration(labelText: 'Version'),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    controller.selectDeploymentDate(context),
                                child: const Text('Select Deployment Date'),
                              ),
                              Card(
                                child: Text(controller
                                    .selectedDeploymentDate.value
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]),
                              ),
                              TextField(
                                controller: controller.ownerController,
                                decoration:
                                    const InputDecoration(labelText: 'Owner'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    controller.selectLastUpdatedDate(context),
                                child: const Text('Select Last Updated Date'),
                              ),
                              Card(
                                child: Text(controller
                                    .selectedLastUpdatedDate.value
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]),
                              ),
                              TextField(
                                controller: controller.contactInfoController,
                                decoration: const InputDecoration(
                                    labelText: 'Contact Info'),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller:
                                    controller.backupFrequencyController,
                                decoration: const InputDecoration(
                                    labelText: 'BackUp Frequency'),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    controller.selectLastBackUpDate(context),
                                child: const Text('Select Last BackUp Date'),
                              ),
                              Card(
                                child: Text(controller
                                    .selectedLastBackUpDate.value
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Add Project Button
                      ElevatedButton(
                        onPressed: controller.addProject,
                        child: const Text('Add Project'),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
