import 'package:get/get.dart';
import 'package:gitrepo/app/controllers/repo_page_controller.dart';

class RepoBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<RepoPageController> ( () => RepoPageController());
  }

}