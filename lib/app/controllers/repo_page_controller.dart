import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitrepo/app/model/git_repo.dart';
import 'package:gitrepo/app/services/api_communication.dart';

enum ViewType { list, grid }
enum SortBy { date, name, stars }

class RepoPageController extends GetxController {
  final GithubApiService _githubApiService = GithubApiService();

  final RxList<GithubRepoModel> allRepositories = <GithubRepoModel>[].obs;
  final RxList<GithubRepoModel> filteredRepositories = <GithubRepoModel>[].obs;
  final isLoading = false.obs;
  final username = ''.obs;
  final viewType = ViewType.list.obs;
  final sortBy = SortBy.date.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    retrieveUsernameAndFetchRepos();
  }

  void retrieveUsernameAndFetchRepos() {
    try {
      final arguments = Get.arguments;
      debugPrint('Arguments received: $arguments');

      if (arguments != null && arguments is Map) {
        final usernameArg = arguments['username'];
        if (usernameArg != null && usernameArg is String) {
          username.value = usernameArg;
          debugPrint('Username set to: ${username.value}');
          fetchRepositories();
        } else {
          debugPrint('Username is null or not a String');
        }
      } else {
        debugPrint('Arguments is null or not a Map');
        // If no arguments, try with a default username for testing
        username.value = 'littlesarker';
        fetchRepositories();
      }
    } catch (e) {
      debugPrint('Error retrieving username: $e');
      // Fallback to default username
      username.value = 'littlesarker';
      fetchRepositories();
    }
  }

  Future<void> fetchRepositories() async {
    if (username.value.isEmpty) {
      debugPrint('Username is empty');
      return;
    }

    try {
      isLoading.value = true;
      debugPrint('Fetching repositories for: ${username.value}');

      final response = await _githubApiService.fetchUserRepositories(
        username: username.value,
        enableLoading: false,
      );

      debugPrint('Response received: ${response.isSuccessful}');
      debugPrint('Response data: ${response.data}');

      if (response.isSuccessful && response.data != null) {
        allRepositories.value = response.data as List<GithubRepoModel>;
        debugPrint('Repositories loaded: ${allRepositories.length}');

        applyFilters();

        if (allRepositories.isNotEmpty) {
          Get.snackbar(
            'Success',
            '${allRepositories.length} repositories loaded',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 2),
          );
        }
      } else {
        debugPrint('Failed to fetch: ${response.message}');
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to fetch repositories',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint('Error in fetchRepositories: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleViewType() {
    viewType.value = viewType.value == ViewType.list ? ViewType.grid : ViewType.list;
  }

  void changeSortBy(SortBy newSortBy) {
    sortBy.value = newSortBy;
    applyFilters();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    var repos = List<GithubRepoModel>.from(allRepositories);
    debugPrint('Applying filters to ${repos.length} repos');

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      repos = repos.where((repo) {
        return repo.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            (repo.description?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
      }).toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case SortBy.date:
        repos.sort((a, b) => DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));
        break;
      case SortBy.name:
        repos.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortBy.stars:
        repos.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
        break;
    }

    filteredRepositories.value = repos;
    debugPrint('Filtered repositories: ${filteredRepositories.length}');
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()} weeks ago';
      } else if (difference.inDays < 365) {
        return '${(difference.inDays / 30).floor()} months ago';
      } else {
        return '${(difference.inDays / 365).floor()} years ago';
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}