import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../routes/app_pages.dart';
class BottomNavController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeTabIndex(int index) {
    if (index == 2) return; // لا تفعل شيء عند الضغط على الشعار

    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed(Routes.REGISTER);
        break;
      case 1:
        Get.toNamed(Routes.PropertiesUnifiedView);
        break;
      case 3:
        Get.toNamed(Routes.REGISTER);
        break;
      case 4:
        Get.toNamed(Routes.PROFILE);
        break;
    }
  }
}

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      currentIndex: navController.currentIndex.value,
      onTap: navController.changeTabIndex,
      backgroundColor: AppColors.background1,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white.withOpacity(0.6),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        _buildNavItem(Icons.content_paste_rounded, 0),
        _buildNavItem(Icons.home, 1),
        _buildLogoItem(), // الشعار في المنتصف
        _buildNavItem(Icons.calendar_today, 3),
        _buildNavItem(Icons.person_outline_outlined, 4),
      ],
    ));
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

  BottomNavigationBarItem _buildLogoItem() {
    return BottomNavigationBarItem(
      label: '',
      icon: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Image.asset(
          'assets/Logo1.png',
          height: 46,
        ),
      ),
    );
  }
}

