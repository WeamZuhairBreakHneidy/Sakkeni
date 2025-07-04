
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/core/theme/colors.dart';
import 'package:test1/generated/locales.g.dart';
import 'app/core/bindings/app_binding.dart';
import 'app/core/theme/themes.dart';
import 'app/data/services/locale_service.dart';
import 'app/data/services/theme_service.dart';
import 'app/routes/app_pages.dart';

final ThemeController themeController = Get.put(ThemeController());
final LocaleService localeService = Get.put(LocaleService());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: true,
    systemStatusBarContrastEnforced: true,
    statusBarColor: AppColors.primary,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.primary,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarDividerColor: AppColors.primary,
  ));


  runApp(
    ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Application",
          themeMode: themeController.theme,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialBinding: AppBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          translationsKeys: AppTranslation.translations,
          locale: localeService.getLocale(),
          fallbackLocale: const Locale('en', 'US'),

          builder: (context, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                systemNavigationBarContrastEnforced: true,
                systemStatusBarContrastEnforced: true,
                statusBarColor: AppColors.primary,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: AppColors.primary,
                systemNavigationBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
                systemNavigationBarDividerColor: AppColors.primary,
              ),
              child: child!,
            );
          },
        );
      },
    ),
  );
}


//for the dark mode button
//  onTap:() {
//
//             if (Get.isDarkMode) {
//               // Change the theme mode to light mode
//               themeController.changeThemeMode(ThemeMode.light);
//               themeController.saveTheme(false);
//             } else {
//               // Change the theme mode to dark mode
//               themeController.changeThemeMode(ThemeMode.dark);
//               themeController.saveTheme(true);
//             }
//
//         }