import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/upgrade-to-seller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());
  final box = GetStorage(); // ✅ initialize GetStorage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: Theme.of(context).colorScheme.background,
                child: Row(
                  children: [
                    Text(
                      "Profile",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "View History",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    IconButton(
                      icon: Icon(Icons.history),
                      onPressed: () {
                        final isSeller = box.read('isSeller') ?? false;

                        if (isSeller) {
                          Get.toNamed(Routes.ADDPROPERTY);
                        } else {
                          showUpgradeToSellerDialog();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Divider(height: 1, color: Colors.grey),
              ),
              30.verticalSpace,
              // BODY
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: SizedBox(
                        width: 75,
                        height: 75,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineSpinFadeLoader,
                          colors: [AppColors.primary],
                          strokeWidth: 1,
                        ),
                      ),
                    );
                  }

                  final profile = controller.profileModel.value?.data;

                  if (profile == null) {
                    return const Center(child: Text("No profile data"));
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 75.r,
                          backgroundImage: profile.profilePicturePath != null
                              ? NetworkImage(
                            '${ApiService().baseUrl}/${profile.profilePicturePath}',
                          )
                              : AssetImage(
                            Theme.of(context).brightness ==
                                Brightness.dark
                                ? "assets/backgrounds/default_black.png"
                                : "assets/backgrounds/default.png",
                          ) as ImageProvider,
                        ),
                        50.verticalSpace,
                        ProfileInfoTile(
                          icon: Icons.person,
                          text: '${profile.firstName} ${profile.lastName}',
                        ),
                        _buildDivider(),
                        ProfileInfoTile(
                          icon: Icons.phone,
                          text: profile.phoneNumber ?? 'No Phone',
                        ),
                        _buildDivider(),
                        ProfileInfoTile(
                            icon: Icons.email, text: profile.email),
                        _buildDivider(),
                        ProfileInfoTile(
                          icon: Icons.location_on,
                          text: profile.address ?? 'No Address',
                        ),
                        _buildDivider(),

                        if (profile.seller != null) ...[
                          ProfileInfoTile(
                            icon: Icons.store,
                            text: "Seller Account",
                          ),
                          _buildDivider(),
                        ],

                        50.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed(Routes.UPDATEPROFILE),
                              child: Text(
                                "Edit Profile",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed(Routes.RESETPASSWORD),
                              child: Text(
                                "Reset Password",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildDivider() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Divider(thickness: 1, color: Colors.grey[300], height: 5.h),
  );
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
