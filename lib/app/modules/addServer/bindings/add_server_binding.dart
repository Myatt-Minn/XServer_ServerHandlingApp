import 'package:get/get.dart';

import '../controllers/add_server_controller.dart';

class AddServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddServerController>(
      () => AddServerController(),
    );
  }
}
