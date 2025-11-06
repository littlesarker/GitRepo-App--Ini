import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:gitrepo/app/controllers/first_page_controller.dart';

class FirstPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<FirstPageController> (() => FirstPageController());
  }

}