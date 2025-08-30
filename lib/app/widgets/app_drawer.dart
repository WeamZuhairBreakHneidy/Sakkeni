import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/data/services/api_endpoints.dart';
import '../core/theme/colors.dart';
import '../modules/auth/controllers/logout_controller.dart';
import '../routes/app_pages.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final LogoutController controller = Get.find<LogoutController>();

  @override
  Widget build(BuildContext context) {
    print('${ApiEndpoints.baseUrl}/${GetStorage().read('imagePath')}');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(

            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h, top: 40.h),
            height: 150.h, // responsive height
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile image (bigger size, responsive)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    "${ApiEndpoints.baseUrl}/${GetStorage().read('imagePath')}",
                    width: 85.w,
                    height: 85.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 85.w,
                        height: 85.w,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      width: 85.w,
                      height: 85.w,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        size: 50.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // User info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name
                      Text(
                        GetStorage().read('userName') ?? "Guest User",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.r,

                        ),
                        maxLines: 2, // restricts to one line
                        overflow: TextOverflow.fade, // shows "..."
                        softWrap: false,

                      ),
                      SizedBox(height: 4.h),
                      // Email
                      Text(
                        GetStorage().read('email') ?? "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 13.sp,
                        ),
                        maxLines: 2, // keep on one line
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          if ( GetStorage().read('isSeller'))
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'My Properties',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Get.toNamed(Routes.MY_PROPERTIES);
              },
            ),


    if ( GetStorage().read('isServiceProvider'))
       ListTile(
            leading: Icon(Icons.work),
            title: Text(
              'My Services',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
            Get.toNamed(Routes.MY_SERVICES);
            },
          ),


            ListTile(
              leading: Icon(Icons.request_quote),
              title: Text(
                'My Requests',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Get.toNamed(Routes.USER_QUOTES);
              },
            ),

          if ( GetStorage().read('isServiceProvider'))
            ListTile(
              leading: Icon(Icons.request_quote_outlined),
              title: Text(
                'Requests to do',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Get.toNamed(Routes.PROVIDER_QUOTES);
              },
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
