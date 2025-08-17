import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../routes/app_pages.dart';

class BottomNavController extends GetxController {
  RxInt currentIndex = 2.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offNamed(Routes.FAVORITE);
        break;
      case 1:
        Get.offNamed(Routes.PropertiesUnifiedView);
        break;
      case 2:
        Get.offNamed(Routes.HOME);
     
        break;
      case 3:
        Get.offNamed(Routes.SERVICE_PROVIDERS);
        break;
      case 4:
        Get.offNamed(Routes.PROFILE);
        break;
    }
  }
}

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final BottomNavController navController = Get.put(BottomNavController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: navController.currentIndex.value,
        onTap: navController.changeTabIndex,
        backgroundColor: AppColors.background,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.unselectedItemColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          _buildNavItem(Icons.content_paste_rounded, 0),
          _buildNavItem(Icons.home_work_sharp, 1),
          _buildLogoNavItem(),
          _buildNavItem(Icons.work, 3),
          _buildNavItem(Icons.person_outline_outlined, 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      label: '',
      icon: Obx(() {
        final isSelected = navController.currentIndex.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      }),
    );
  }

  BottomNavigationBarItem _buildLogoNavItem() {
    return BottomNavigationBarItem(
      label: '',
      icon: Obx(() {
        final isSelected = navController.currentIndex.value == 2;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Image.asset('assets/Logo1.png', height: 46),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// BottomNavigationBarItem _buildLogoNavItem() {
//   return BottomNavigationBarItem(
//     label: '',
//     icon: Obx(() {
//       final isSelected = navController.currentIndex.value == 2;
//       return ColorFiltered(
//         colorFilter: ColorFilter.mode(
//           // تغيير لون الشعار بناءً على حالة التحديد
//           isSelected ? AppColors.white : AppColors.unselectedItemColor,
//           BlendMode.srcIn,
//         ),
//         child: Image.asset(
//           'assets/Logo1.png',
//           height: 46,
//         ),
//       );
//     }),
//   );
// }
// }
