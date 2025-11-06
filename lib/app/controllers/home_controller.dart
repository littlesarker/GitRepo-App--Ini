import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitrepo/app/model/git_repo.dart';
import 'package:gitrepo/app/model/github_user_model.dart';
import 'package:gitrepo/app/services/api_communication.dart';

class HomeController extends GetxController {
  final GithubApiService _githubApiService = GithubApiService();

  final Rxn<GithubUserModel> githubUser = Rxn<GithubUserModel>();
  final isLoading = false.obs;
  final username = ''.obs;






  @override
  void onInit() {
    super.onInit();
    retrieveUsernameAndFetchData();


  }

  void retrieveUsernameAndFetchData() {
    try {
      final arguments = Get.arguments;
      if (arguments != null && arguments is String) {
        // Get username directly as String
        username.value = arguments;
        debugPrint('Username retrieved: ${username.value}');

        // Fetch user data from API
        fetchUserDataFromApi();
      } else {
        debugPrint('No username argument found');
        showErrorSnackbar('No username provided');
      }
    } catch (e) {
      debugPrint('Error retrieving username: $e');
      showErrorSnackbar('Failed to retrieve username');
    }
  }

  /// Fetch user data from GitHub API
  Future<void> fetchUserDataFromApi() async {
    if (username.value.isEmpty) {
      showErrorSnackbar('Username is empty');
      return;
    }

    try {
      isLoading.value = true;

      debugPrint('Fetching user data for: ${username.value}');

      // Call GitHub API
      final response = await _githubApiService.fetchGithubUser(
        username: username.value,
        enableLoading: false, // Use our own loading indicator
      );

      if (response.isSuccessful && response.data != null) {
        githubUser.value = response.data as GithubUserModel;
        debugPrint('User data fetched successfully: ${githubUser.value?.login}');

        showSuccessSnackbar('User data loaded successfully!');
      } else {
        debugPrint('Failed to fetch user data: ${response.message}');
        showErrorSnackbar(response.message ?? 'Failed to fetch user data');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      showErrorSnackbar('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    await fetchUserDataFromApi();
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String getJoinedDuration(String createdAt) {
    try {
      final joinDate = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(joinDate);

      if (difference.inDays < 30) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void openGithubProfile() {
    if (githubUser.value?.htmlUrl != null) {
      // You can use url_launcher package to open the URL
      // For now, show snackbar with URL
      Get.snackbar(
        'GitHub Profile',
        'Opening: ${githubUser.value!.htmlUrl}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      );
    }
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      duration: Duration(seconds: 2),
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      duration: Duration(seconds: 3),
      icon: Icon(Icons.error, color: Colors.white),
    );
  }





}





