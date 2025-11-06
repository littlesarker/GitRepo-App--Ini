import 'package:get/get.dart';
import 'package:gitrepo/app/bindings/first_page_binding.dart';
import 'package:gitrepo/app/bindings/home_binding.dart';
import 'package:gitrepo/app/bindings/repo_page_binding.dart';
import 'package:gitrepo/app/pages/first_page.dart';
import 'package:gitrepo/app/pages/home_page.dart';
import 'package:gitrepo/app/pages/repo_page.dart';

abstract class AppPages {
  static const INITIAL = '/firstpage';

  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: '/firstpage',
      page: () => FirstPageView(),
      binding: FirstPageBinding(),
    ),

    GetPage(
      name: '/repoPage',
      page: () => RepoPageView(),
      binding: RepoBinding(),
    ),

  ];
}