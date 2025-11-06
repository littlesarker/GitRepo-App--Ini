import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// controllers/first_page_controller.dart
import 'package:get/get.dart';
import 'package:gitrepo/app/controllers/theme_controller.dart';
import 'package:gitrepo/app/model/github_user_model.dart';
import 'package:gitrepo/app/pages/home_page.dart';
import 'package:gitrepo/app/services/api_communication.dart';

class FirstPageController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();

  // Reactive variable for username
  var username = ''.obs;

  // Error message for validation
  var usernameError = RxString('');

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }


  final GithubApiService _githubApiService = GithubApiService();


  final isLoading = false.obs;
  final Rxn<GithubUserModel> githubUser = Rxn<GithubUserModel>();

  /// Update username and clear error
  void updateUsername(String value) {
    username.value = value;
    if (usernameError.value.isNotEmpty) {
      usernameError.value = '';
    }
  }

  /// Validate username
  bool _validateUsername() {
    if (username.value.isEmpty) {
      usernameError.value = 'Please enter a username';
      return false;
    }
    if (username.value.length < 3) {
      usernameError.value = 'Username must be at least 3 characters';
      return false;
    }
    usernameError.value = '';
    return true;
  }

  /// Fetch GitHub user data
  Future<void> fetchUserData() async {
    // Validate username first
    if (!_validateUsername()) {
      return;
    }

    try {
      isLoading.value = true;

      // Call API to fetch user data
      final response = await _githubApiService.fetchGithubUser(
        username: username.value,
        enableLoading: true,
      );

      if (response.isSuccessful && response.data != null) {
        // Store user data
        githubUser.value = response.data as GithubUserModel;

        // Show success message
        Get.snackbar(
          'Success',
          'User ${githubUser.value!.login} found!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );

        // Navigate to home page with user data
        proceedToHome();
      } else {
        // Show error message
        usernameError.value = 'User not found';
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to fetch user data',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Error in fetchUserData: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }



  /// Toggle theme
  void toggleTheme() {
    final themeController = Get.find<ThemeController>();
    themeController.toggleTheme();
  }




  // Validate username
  bool validateUsername(String value) {
    if (value.isEmpty) {
      usernameError.value = 'Username cannot be empty';
      return false;
    } else if (value.length < 3) {
      usernameError.value = 'Username must be at least 3 characters';
      return false;
    } else {
      usernameError.value = '';
      return true;
    }
  }

  // Update username
  // void updateUsername(String value) {
  //   username.value = value;
  //   // Clear error when user starts typing
  //   if (usernameError.isNotEmpty) {
  //     validateUsername(value);
  //   }
  // }

  // Proceed to home page
  void proceedToHome() {
    if (validateUsername(username.value)) {
      // Save username and navigate to home
      Get.to(() => HomePage(), arguments: username.value);
    }
  }

  // // Theme toggle method
  // void toggleTheme() {
  //   themeController.toggleTheme();
  // }
}