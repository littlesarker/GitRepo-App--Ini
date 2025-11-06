import 'color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> showLoader({
  String? status,
  bool? dismissOnTap,
}) async {
  //Customize the Loader
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = PRIMARY_DARK_COLOR
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;

  // Showing the loader
  EasyLoading.show(
    status: status ?? 'Please Wait',
    dismissOnTap: dismissOnTap,
  );
}

dismissLoader() => EasyLoading.dismiss();
