import 'package:get/get.dart';

import '../controllers/edit_server_controller.dart';

class EditServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditServerController>(
      () => EditServerController(),
    );
  }
}
