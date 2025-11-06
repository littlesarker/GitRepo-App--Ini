import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:gitrepo/app/controllers/repo_page_controller.dart';
import 'package:gitrepo/app/controllers/theme_controller.dart';
import 'package:gitrepo/app/model/git_repo.dart';

class RepoPageView extends GetView<RepoPageController> {


  final RepoPageController controller = Get.put(RepoPageController());
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
        centerTitle: true,
        actions: [
          // View Toggle
          IconButton(
            icon: Icon(
              controller.viewType.value == ViewType.list
                  ? Icons.grid_view_rounded
                  : Icons.view_list_rounded,
            ),
            onPressed: controller.toggleViewType,
          ),
          // Filter Menu
          PopupMenuButton<SortBy>(
            icon: Icon(Icons.sort_rounded),
            onSelected: controller.changeSortBy,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortBy.date,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20),
                    SizedBox(width: 12),
                    Text('Sort by Date'),
                    if (controller.sortBy.value == SortBy.date)
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.check, size: 20),
                      ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortBy.name,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 20),
                    SizedBox(width: 12),
                    Text('Sort by Name'),
                    if (controller.sortBy.value == SortBy.name)
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.check, size: 20),
                      ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortBy.stars,
                child: Row(
                  children: [
                    Icon(Icons.star, size: 20),
                    SizedBox(width: 12),
                    Text('Sort by Stars'),
                    if (controller.sortBy.value == SortBy.stars)
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.check, size: 20),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeController.isDarkMode.value
                ? [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF880E4F)]
                : [Color(0xFFE3F2FD), Color(0xFFF3E5F5), Color(0xFFFFE0F0)],
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: themeController.isDarkMode.value
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  onChanged: controller.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search repositories...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        controller.updateSearchQuery('');
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ),

            // Repository Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.filteredRepositories.length} ${controller.filteredRepositories.length == 1 ? 'repository' : 'repositories'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: themeController.isDarkMode.value
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                  ),
                  if (controller.sortBy.value != SortBy.date)
                    Chip(
                      label: Text(
                        controller.sortBy.value == SortBy.name
                            ? 'By Name'
                            : 'By Stars',
                        style: TextStyle(fontSize: 12),
                      ),
                      avatar: Icon(
                        controller.sortBy.value == SortBy.name
                            ? Icons.sort_by_alpha
                            : Icons.star,
                        size: 16,
                      ),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Repositories List/Grid
            Expanded(
              child: controller.isLoading.value
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading repositories...',
                      style: TextStyle(
                        color: themeController.isDarkMode.value
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
                  : controller.filteredRepositories.isEmpty
                  ? _buildEmptyState(themeController)
                  : RefreshIndicator(
                onRefresh: controller.fetchRepositories,
                child: controller.viewType.value == ViewType.list
                    ? _buildListView()
                    : _buildGridView(),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.filteredRepositories.length,
      itemBuilder: (context, index) {
        final repo = controller.filteredRepositories[index];
        return _buildRepoListCard(repo);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.filteredRepositories.length,
      itemBuilder: (context, index) {
        final repo = controller.filteredRepositories[index];
        return _buildRepoGridCard(repo);
      },
    );
  }

  Widget _buildRepoListCard(GithubRepoModel repo) {
    final themeController = Get.find<ThemeController>();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: themeController.isDarkMode.value
              ? [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]
              : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to repo details
            Get.toNamed('/repo-details', arguments: {'repo': repo});
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.folder_rounded,
                      color: Colors.blue,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        repo.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    if (repo.private)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Private',
                          style: TextStyle(fontSize: 10, color: Colors.orange),
                        ),
                      ),
                  ],
                ),
                if (repo.description != null && repo.description!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    repo.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: themeController.isDarkMode.value
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                  ),
                ],
                SizedBox(height: 12),
                Row(
                  children: [
                    if (repo.language != null && repo.language!.isNotEmpty) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getLanguageColor(repo.language!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        repo.language!,
                        style: TextStyle(
                          fontSize: 12,
                          color: themeController.isDarkMode.value
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                    Icon(
                      Icons.star_border,
                      size: 16,
                      color: themeController.isDarkMode.value
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${repo.stargazersCount}',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeController.isDarkMode.value
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.account_tree,
                      size: 16,
                      color: themeController.isDarkMode.value
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${repo.forksCount}',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeController.isDarkMode.value
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),
                    Spacer(),
                    Text(
                      controller.formatDate(repo.updatedAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepoGridCard(GithubRepoModel repo) {
    final themeController = Get.find<ThemeController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: themeController.isDarkMode.value
              ? [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]
              : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to repo details
            Get.toNamed('/repo-details', arguments: {'repo': repo});
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.folder_rounded,
                  color: Colors.blue,
                  size: 32,
                ),
                SizedBox(height: 12),
                Text(
                  repo.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (repo.description != null && repo.description!.isNotEmpty) ...[
                  SizedBox(height: 6),
                  Text(
                    repo.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: themeController.isDarkMode.value
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                  ),
                ],
                Spacer(),
                if (repo.language != null && repo.language!.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _getLanguageColor(repo.language!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          repo.language!,
                          style: TextStyle(
                            fontSize: 11,
                            color: themeController.isDarkMode.value
                                ? Colors.white70
                                : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star_border,
                      size: 14,
                      color: themeController.isDarkMode.value
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${repo.stargazersCount}',
                      style: TextStyle(
                        fontSize: 11,
                        color: themeController.isDarkMode.value
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.account_tree,
                      size: 14,
                      color: themeController.isDarkMode.value
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${repo.forksCount}',
                      style: TextStyle(
                        fontSize: 11,
                        color: themeController.isDarkMode.value
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeController themeController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 80,
            color: themeController.isDarkMode.value
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'No repositories match your search'
                : 'No repositories found',
            style: TextStyle(
              fontSize: 18,
              color: themeController.isDarkMode.value
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
          ),
          if (controller.searchQuery.value.isNotEmpty) ...[
            SizedBox(height: 12),
            TextButton(
              onPressed: () => controller.updateSearchQuery(''),
              child: Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }

  Color _getLanguageColor(String language) {
    final colors = {
      'Dart': Colors.blue,
      'JavaScript': Colors.yellow.shade700,
      'TypeScript': Colors.blue.shade700,
      'Python': Colors.blue.shade900,
      'Java': Colors.orange,
      'Kotlin': Colors.purple,
      'Swift': Colors.orange.shade700,
      'Go': Colors.cyan,
      'Rust': Colors.brown,
      'C++': Colors.pink,
      'C': Colors.blue.shade800,
      'Ruby': Colors.red,
      'PHP': Colors.indigo,
      'Makefile': Colors.green,
    };
    return colors[language] ?? Colors.grey;
  }
}

