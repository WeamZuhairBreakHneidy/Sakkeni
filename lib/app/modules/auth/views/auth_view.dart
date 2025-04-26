import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';


import '../../../core/theme/colors.dart';
import '../../../core/theme/themes.dart';
import '../../../core/util/device_utils.dart';
import '../../../data/services/validator_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/RememberMeCheckbox.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/responsive_buttun.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
   AuthView({super.key});
  GlobalKey<FormState> loginFormKey=GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,


      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0, // Remove the shadow of the app bar
      //   automaticallyImplyLeading: false,
      //   leading: TextButton(
      //     onPressed: () {
      //       if (Get.locale?.languageCode == 'en') {
      //         Get.updateLocale(Locale('ar', 'SY'));
      //       } else {
      //         Get.updateLocale(Locale('en', 'US'));
      //       }
      //     },
      //     child: Text(
      //       '${Get.locale?.languageCode}',
      //       style: Theme.of(context).textTheme.bodyLarge,
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  DeviceUtils.isPhone()
                      ? 'assets/backgrounds/phone_background.jpeg'
                      : 'assets/backgrounds/tablet_background.jpeg',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          // Opacity Layer
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),

          ListView(

            children: [

              Form(
                key:loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      alignment: Alignment.center,
                      height: 36.h,
                      margin: EdgeInsets.only(top: 86, left: 134, right: 123).r,

                      child: Text(
                        'labels_welcome_to'.tr,

                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    13.verticalSpace,
                    //Logo
                    Container(
                      alignment: Alignment.center,
                      height: 124.h,
                      margin: EdgeInsets.only(  left: 76,right: 75.61).r,
                      child: Image.asset(
                        'assets/Logo.png',

                      ),

                    ),
                    129.verticalSpace,



                    //Email
                    InputTextFormField(


                      errorStyle: TextStyle(height: 0, color: Theme.of(context).colorScheme.error),
                      labelTextAboveTextField: Text(
                        'labels_email'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 48).w,
                      suffixIcon: Icon(Icons.mail, color: AppColors.primary),
                      obsecure: false,
                      hintText: 'hint_text_enter_your_email'.tr,
                      helper: Text(''),
                      validatorType: ValidatorType.Email,

                    ),
                    10.verticalSpace,

                    //Password
                    Obx(
                      () => InputTextFormField(

                        errorStyle: const TextStyle(height: -1, color: Colors.transparent),

                        labelTextAboveTextField: Text(
                          'labels_password'.tr,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 48).w,
                        obsecure: controller.isPasswordHidden.value,
                        hintText: 'hint_text_enter_your_password'.tr,
                        suffixIcon: IconButton(
                          icon: Icon(
                            (controller.isPasswordHidden.value)
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            controller.isPasswordHidden.value =
                                !controller.isPasswordHidden.value;
                          },
                        ),


                        validatorType: ValidatorType.LoginPassword,

                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 48).w,
                      child: Row(
                         mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me Checkbox
                          Flexible(flex: 1,child: RememberMeCheckbox(isChecked: RxBool(false))),


                          // Forgot Password Button
                          Flexible(
                            flex: 1,
                            child: TextButton(
                              onPressed: () {
                                // Forgot Password logic
                              },
                              child: Text(
                                'labels_forgot'.tr,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    20.verticalSpace,

                    //Button
                    ResponsiveButton(
                      onPressed: () {
                        if(loginFormKey.currentState!.validate()){

                          controller.login(controller.emailController.text,controller.passwordController.text);
                        }
                      },
                      clickable: true,
                      margin: EdgeInsets.symmetric(horizontal: 48).w,
                      buttonStyle: ButtonStyle(


                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          ),
                        ),
                      ),
                      buttonWidth: Get.width,
                      child: Text('labels_login'.tr, style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    40.verticalSpace,

                    // //OR Divider
                    // CustomDivider(
                    //
                    //   height: 20.h,
                    //   text: 'OR',
                    //   fontSize: 16.r,
                    //   fontFamily: AppTheme.primaryFont,
                    //
                    //   thickness: 2,
                    //   indent: 20.w,
                    //   endIndent: 20.w,
                    //
                    //
                    // ),
                    // 20.verticalSpace,
                    // //Google Login
                    // ResponsiveButton(
                    //   onPressed: () {},
                    //   clickable: true,
                    //   margin: EdgeInsets.symmetric(horizontal: 48).w,
                    //   buttonStyle: ButtonStyle(
                    //     backgroundColor: WidgetStatePropertyAll(AppColors.surface),
                    //     overlayColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                    //     padding: WidgetStatePropertyAll(
                    //       EdgeInsets.symmetric(vertical: 10.r),
                    //     ),
                    //     shape: WidgetStatePropertyAll(
                    //       RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(50.r)),
                    //       ),
                    //     ),
                    //   ),
                    //   buttonWidth: Get.width,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text('labels_login_with_Google'.tr, style: Theme.of(context).textTheme.bodyMedium,),
                    //       10.horizontalSpace,
                    //       Image.asset(
                    //         'assets/google.png',
                    //         width: 20,
                    //         height: 20,
                    //       ),
                    //
                    //     ],
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "labels_dont_have_an_account".tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                      ],
                    ),

                    20.verticalSpace,
                    ResponsiveButton(
                      onPressed: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      clickable: true,
                      margin: EdgeInsets.symmetric(horizontal: 48).w,
                      buttonStyle: ButtonStyle(


                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          ),
                        ),
                      ),
                      buttonWidth: Get.width,
                      child: Text('labels_register'.tr, style: Theme.of(context).textTheme.bodyMedium),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
