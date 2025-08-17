import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/colors.dart';
import '../modules/auth/controllers/logout_controller.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final LogoutController controller = Get.put<LogoutController>(LogoutController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              'Sakkeni',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(
              'Language: ${Get.locale?.languageCode.toUpperCase() ?? 'EN'}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Get.updateLocale(
                Get.locale?.languageCode == 'en'
                    ? const Locale('ar')
                    : const Locale('en'),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Get.back();
            },
          ),

          ListTile(
            leading: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: Text('Dark Mode'),
            trailing: Switch(
              value: Get.isDarkMode,
              onChanged: (value) {
                Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
          ),

          Divider(),

          Obx(() {
            return ListTile(
              leading: Icon(Icons.logout),
              title:
                  controller.isLoading.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      )
                      : Text(
                        'Logout',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
              onTap:
                  controller.isLoading.value ? null : () => controller.logout(),
            );
          }),
        ],
      ),
    );
  }
}
