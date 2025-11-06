import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:gitrepo/app/controllers/first_page_controller.dart';
import 'package:gitrepo/app/controllers/theme_controller.dart';
//

class FirstPageView extends GetView<FirstPageController> {
  final TextEditingController _usernameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(() {
            final themeController = Get.find<ThemeController>();
            return Container(
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    themeController.isDarkMode.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    key: ValueKey(themeController.isDarkMode.value),
                  ),
                ),
                onPressed: controller.toggleTheme,
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final themeController = Get.find<ThemeController>();
        return Container(
          decoration: BoxDecoration(
            gradient: themeController.isDarkMode.value
                ? _darkBackgroundGradient()
                : _lightBackgroundGradient(),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40),

                    // Animated Hero Icon with Glow Effect
                    TweenAnimationBuilder(
                      duration: Duration(milliseconds: 1200),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: themeController.isDarkMode.value
                                    ? [
                                  Colors.purple.shade400,
                                  Colors.blue.shade600,
                                ]
                                    : [
                                  Colors.blue.shade300,
                                  Colors.purple.shade300,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.rocket_launch_outlined,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 30),

                    // Animated Welcome Text
                    TweenAnimationBuilder(
                      duration: Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Welcome',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              letterSpacing: -0.5,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: themeController.isDarkMode.value
                                  ? [
                                Colors.purple.shade300,
                                Colors.blue.shade300,
                              ]
                                  : [
                                Colors.blue.shade600,
                                Colors.purple.shade600,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Check Git with us',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50),

                    // Glassmorphic Username Card
                    TweenAnimationBuilder(
                      duration: Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
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
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Github User Name',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              SizedBox(height: 20),
                              // Obx(() => Container(
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(16),
                              //     color: themeController.isDarkMode.value
                              //         ? Colors.white.withOpacity(0.1)
                              //         : Colors.grey.shade100,
                              //     border: Border.all(
                              //       color: controller
                              //           .usernameError.value.isEmpty
                              //           ? Colors.transparent
                              //           : Colors.red.shade300,
                              //       width: 2,
                              //     ),
                              //   ),
                              //   child: TextField(
                              //     controller: _usernameController,
                              //     style: TextStyle(
                              //       color: themeController.isDarkMode.value
                              //           ? Colors.white
                              //           : Colors.black87,
                              //       fontSize: 16,
                              //     ),
                              //     decoration: InputDecoration(
                              //       labelText: 'Github Username',
                              //       hintText: 'Enter username',
                              //       hintStyle: TextStyle(
                              //         color:
                              //         themeController.isDarkMode.value
                              //             ? Colors.grey.shade400
                              //             : Colors.grey.shade500,
                              //       ),
                              //       prefixIcon: Icon(
                              //         Icons.person_rounded,
                              //         color: Theme.of(context).primaryColor,
                              //       ),
                              //       border: InputBorder.none,
                              //       contentPadding: EdgeInsets.symmetric(
                              //         horizontal: 20,
                              //         vertical: 18,
                              //       ),
                              //       errorText: controller
                              //           .usernameError.value.isEmpty
                              //           ? null
                              //           : controller.usernameError.value,
                              //     ),
                              //     onChanged: controller.updateUsername,
                              //     onSubmitted: (_) =>
                              //         controller.proceedToHome(),
                              //   ),
                              // )),
                              // Obx(() => Container(
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(16),
                              //     color: themeController.isDarkMode.value
                              //         ? Colors.white.withOpacity(0.1)
                              //         : Colors.grey.shade100,
                              //     border: Border.all(
                              //       color: controller.usernameError.value.isEmpty
                              //           ? Colors.transparent
                              //           : Colors.red.shade300,
                              //       width: 2,
                              //     ),
                              //   ),
                              //   child: TextField(
                              //     controller: _usernameController,
                              //     style: TextStyle(
                              //       color: themeController.isDarkMode.value
                              //           ? Colors.white
                              //           : Colors.black87,
                              //       fontSize: 16,
                              //     ),
                              //     decoration: InputDecoration(
                              //       labelText: 'Github Username',
                              //       hintText: 'Enter username',
                              //       hintStyle: TextStyle(
                              //         color: themeController.isDarkMode.value
                              //             ? Colors.grey.shade400
                              //             : Colors.grey.shade500,
                              //       ),
                              //       prefixIcon: Icon(
                              //         Icons.person_rounded,
                              //         color: Theme.of(context).primaryColor,
                              //       ),
                              //       suffixIcon: IconButton(
                              //         icon: Icon(
                              //           Icons.search_rounded,
                              //           color: Theme.of(context).primaryColor,
                              //         ),
                              //         onPressed: () => controller.proceedToHome(),
                              //       ),
                              //       border: InputBorder.none,
                              //       contentPadding: EdgeInsets.symmetric(
                              //         horizontal: 20,
                              //         vertical: 18,
                              //       ),
                              //       errorText: controller.usernameError.value.isEmpty
                              //           ? null
                              //           : controller.usernameError.value,
                              //     ),
                              //     onChanged: controller.updateUsername,
                              //     onSubmitted: (_) => controller.proceedToHome(),
                              //   ),
                              // )),

                              Obx(() => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: themeController.isDarkMode.value
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.grey.shade100,
                                  border: Border.all(
                                    color: controller.usernameError.value.isEmpty
                                        ? Colors.transparent
                                        : Colors.red.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: TextField(
                                  controller: _usernameController,
                                  enabled: !controller.isLoading.value, // Disable during loading
                                  style: TextStyle(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Github Username',
                                    hintText: 'Enter username',
                                    hintStyle: TextStyle(
                                      color: themeController.isDarkMode.value
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade500,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    suffixIcon: controller.isLoading.value
                                        ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    )
                                        : IconButton(
                                      icon: Icon(
                                        Icons.search_rounded,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () => controller.fetchUserData(),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                    errorText: controller.usernameError.value.isEmpty
                                        ? null
                                        : controller.usernameError.value,
                                  ),
                                  onChanged: controller.updateUsername,
                                  onSubmitted: (_) => controller.fetchUserData(),
                                ),
                              )),
                              SizedBox(height: 24),

                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Theme Toggle with Modern Design
                    TweenAnimationBuilder(
                      duration: Duration(milliseconds: 1200),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
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
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.palette_rounded,
                                      color: Theme.of(context).primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Appearance',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          themeController.isDarkMode.value
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        themeController.isDarkMode.value
                                            ? 'Dark Mode'
                                            : 'Light Mode',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color:
                                          themeController.isDarkMode.value
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Obx(() {
                                final themeController =
                                Get.find<ThemeController>();
                                return Transform.scale(
                                  scale: 1.1,
                                  child: Switch(
                                    value: themeController.isDarkMode.value,
                                    onChanged: (value) =>
                                        controller.toggleTheme(),
                                    activeColor: Colors.purple.shade400,
                                    activeTrackColor:
                                    Colors.purple.shade200,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Modern Light theme gradient
  LinearGradient _lightBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFE3F2FD), // Light blue
        Color(0xFFF3E5F5), // Light purple
        Color(0xFFFFE0F0), // Light pink
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }

  // Modern Dark theme gradient
  LinearGradient _darkBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A237E), // Deep blue
        Color(0xFF4A148C), // Deep purple
        Color(0xFF880E4F), // Deep pink
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }
}