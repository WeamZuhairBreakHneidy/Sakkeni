import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.w),
                color: AppColors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              190.horizontalSpace,
                    Text(
                      "View History",
                      style: Theme.of(context).textTheme.labelSmall,

                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.history,
                        color: AppColors.background1,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(left: 16.0.w, right: 16.0.w),
                child: Divider(height: 1.h, thickness: 1, color: Colors.grey),
              ),

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
                    );                  }

                  final profile = controller.profileModel.value?.data;

                  if (profile == null) {
                    return const Center(child: Text("No profile data"));
                  }

                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage:
                              profile.profilePicturePath != null
                                  ? NetworkImage(profile.profilePicturePath)
                                  : const AssetImage(
                                        "assets/backgrounds/default.png",
                                      )
                                      as ImageProvider,
                        ),
                        SizedBox(height: 30.h),
                        ProfileInfoTile(
                          icon: Icons.person,
                          text: '${profile.firstName} ${profile.lastName}',
                        ),
                        ProfileInfoTile(
                          icon: Icons.phone,
                          text: profile.phoneNumber ?? 'No Phone',
                        ),
                        ProfileInfoTile(icon: Icons.email, text: profile.email),
                        ProfileInfoTile(
                          icon: Icons.location_on,
                          text: profile.address ?? 'No Address',
                        ),
                        ProfileInfoTile(
                          icon: Icons.business,
                          text: "Personal or Company",
                        ),
                        95.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // تحريك الأزرار لليمين
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Edit Profile",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            TextButton(
                              onPressed: () {},
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
