import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitrepo/app/controllers/theme_controller.dart';
import 'package:gitrepo/app/model/git_repo.dart';
import 'package:gitrepo/app/pages/repo_page.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'GitHub Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Refresh button
          Obx(() => IconButton(
            icon: controller.isLoading.value
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Icon(Icons.refresh_rounded),
            onPressed: controller.isLoading.value
                ? null
                : controller.refreshUserData,
          )),
        ],
      ),
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value && controller.githubUser.value == null) {
          return _buildLoadingState();
        }

        final user = controller.githubUser.value;

        // Show error state if no user data
        if (user == null) {
          return _buildErrorState();
        }

        final themeController = Get.find<ThemeController>();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeController.isDarkMode.value
                  ? [
                Color(0xFF1A237E),
                Color(0xFF4A148C),
                Color(0xFF880E4F),
              ]
                  : [
                Color(0xFFE3F2FD),
                Color(0xFFF3E5F5),
                Color(0xFFFFE0F0),
              ],
            ),
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.refreshUserData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TweenAnimationBuilder(
                        duration: Duration(milliseconds: 800),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.shade400,
                                    Colors.blue.shade600,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(4),
                              child: ClipOval(
                                child: Image.network(
                                  user.avatarUrl,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      // Name and Username
                      Text(
                        user.name ?? user.login,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8),

                      Text(
                        '@${user.login}',
                        style: TextStyle(
                          fontSize: 16,
                          color: themeController.isDarkMode.value
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),

                      if (user.bio != null) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode.value
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.bio!,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],

                      SizedBox(height: 30),


                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                             Get.to(() => RepoPageView() );
                            },
                            child: Expanded(
                              child: _buildStatCard(
                                context: context,
                                icon: Icons.folder_outlined,
                                label: 'Repositories',
                                value: user.publicRepos.toString(),
                                isDark: themeController.isDarkMode.value,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context: context,
                              icon: Icons.people_outline,
                              label: 'Followers',
                              value: user.followers.toString(),
                              isDark: themeController.isDarkMode.value,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context: context,
                              icon: Icons.person_add_outlined,
                              label: 'Following',
                              value: user.following.toString(),
                              isDark: themeController.isDarkMode.value,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Info Card
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: themeController.isDarkMode.value
                                ? [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ]
                                : [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              SizedBox(height: 20),

                              if (user.company != null)
                                _buildInfoRow(
                                  icon: Icons.business_rounded,
                                  label: 'Company',
                                  value: user.company!,
                                  isDark: themeController.isDarkMode.value,
                                ),

                              if (user.location != null)
                                _buildInfoRow(
                                  icon: Icons.location_on_rounded,
                                  label: 'Location',
                                  value: user.location!,
                                  isDark: themeController.isDarkMode.value,
                                ),

                              if (user.email != null)
                                _buildInfoRow(
                                  icon: Icons.email_rounded,
                                  label: 'Email',
                                  value: user.email!,
                                  isDark: themeController.isDarkMode.value,
                                ),

                              if (user.blog != null && user.blog!.isNotEmpty)
                                _buildInfoRow(
                                  icon: Icons.link_rounded,
                                  label: 'Website',
                                  value: user.blog!,
                                  isDark: themeController.isDarkMode.value,
                                ),

                              if (user.twitterUsername != null)
                                _buildInfoRow(
                                  icon: Icons.alternate_email_rounded,
                                  label: 'Twitter',
                                  value: '@${user.twitterUsername!}',
                                  isDark: themeController.isDarkMode.value,
                                ),

                              _buildInfoRow(
                                icon: Icons.code_rounded,
                                label: 'Public Gists',
                                value: user.publicGists.toString(),
                                isDark: themeController.isDarkMode.value,
                              ),

                              _buildInfoRow(
                                icon: Icons.calendar_today_rounded,
                                label: 'Joined',
                                value: controller.getJoinedDuration(user.createdAt),
                                isDark: themeController.isDarkMode.value,
                              ),

                              _buildInfoRow(
                                icon: Icons.update_rounded,
                                label: 'Last Updated',
                                value: controller.formatDate(user.updatedAt),
                                isDark: themeController.isDarkMode.value,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height:50),


                      // repos list







                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Loading user data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Failed to load user data',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: controller.refreshUserData,
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back),
                label: Text('Go Back'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ]
              : [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.blue.shade600,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
