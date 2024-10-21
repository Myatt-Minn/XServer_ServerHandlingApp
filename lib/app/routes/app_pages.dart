import 'package:get/get.dart';

import '../modules/addServer/bindings/add_server_binding.dart';
import '../modules/addServer/views/add_server_view.dart';
import '../modules/add_project/bindings/add_project_binding.dart';
import '../modules/add_project/views/add_project_view.dart';
import '../modules/edit_server/bindings/edit_server_binding.dart';
import '../modules/edit_server/views/edit_server_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SERVER,
      page: () => const AddServerView(),
      binding: AddServerBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_SERVER,
      page: () => const EditServerView(),
      binding: EditServerBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PROJECT,
      page: () => const AddProjectToServerView(),
      binding: AddProjectBinding(),
    ),
  ];
}
