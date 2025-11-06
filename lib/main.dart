import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gitrepo/app/controllers/first_page_controller.dart';
import 'package:gitrepo/app/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final FirstPageController firstPageController = Get.put(FirstPageController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}