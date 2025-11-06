import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color.dart';

void showSnackkbar({required String titile, required String message}) {
  Get.snackbar(
    titile,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: PRIMARY_COLOR,
    colorText: Colors.white,
    duration: Duration(seconds: 2),
  );
}

void showSuccessSnackkbar({String? titile, required String message}) {
  Get.snackbar(
    titile ?? 'SUCCESS!',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: Duration(seconds: 2),
  );
}

void showWarningSnackkbar({String? titile, required String message}) {
  Get.snackbar(
    titile ?? 'WARNING!',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.yellow,
    colorText: Colors.black,
    duration: Duration(seconds: 2),
  );
}

void showErrorSnackkbar({String? titile, required String message}) {
  Get.snackbar(
    titile ?? 'ERROR!',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: Duration(seconds: 2),
  );
}
