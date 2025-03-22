import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:test1/app/data/services/validator_service.dart';


import '../../../core/theme/colors.dart';
import '../../../core/theme/themes.dart';

import '../../../widgets/custom_divider.dart';
import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/responsive_buttun.dart';
import '../controllers/register_controller.dart';


class RegisterView extends GetView<RegisterController> {
 RegisterView({super.key});


  GlobalKey<FormState> registerFormKey=GlobalKey<FormState>();



 @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove the shadow of the app bar
        automaticallyImplyLeading: false,

      ),
      body: ListView(
        children: [
          Form(

            key: registerFormKey,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20).w,
                  child: Text(
                    'labels_register'.tr,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20).w,
                  child: Text(
                    'labels_register_to_continue_using_the_app'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),



                50.verticalSpace,

                //Name
                InputTextFormField(



                  labelTextAboveTextField: Text(
                    'labels_user_name'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: Icon(Icons.person, color: AppColors.primary),
                  obsecure: false,
                  hintText: 'hint_text_enter_your_user_name'.tr,
                  helper: Text(''),
                  validatorType: ValidatorType.Name,
                  textEditingController: controller.nameController,
                ),

                10.verticalSpace,
                //Email
                InputTextFormField(


                  labelTextAboveTextField: Text(
                    'labels_email'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: Icon(Icons.mail, color: AppColors.primary),
                  obsecure: false,
                  hintText: 'hint_text_enter_your_email'.tr,
                  helper: Text(''),
                  validatorType: ValidatorType.Email,
                  textEditingController: controller.emailController,

                ),
                10.verticalSpace,

                //Password
                Obx(
                      () => InputTextFormField(

                    labelTextAboveTextField: Text(
                      'labels_password'.tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
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
                    counter: Text(
                      'labels_forgot_password'.tr,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    helper: Text(''),
                        validatorType: ValidatorType.Password,
                        textEditingController: controller.passwordController,
                  ),
                ),


                20.verticalSpace,

                //Button
                ResponsiveButton(
                  onPressed: () {

                    if(registerFormKey.currentState!.validate()){
                      controller.signup(controller.nameController.text,controller.emailController.text,controller.passwordController.text);
                    }
                  },
                  clickable: true,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  buttonStyle: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 10.r),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.r)),
                      ),
                    ),
                  ),
                  buttonWidth: Get.width,
                  child: Text('buttons_register'.tr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white,)),
                ),
                20.verticalSpace,

                //OR Divider
                CustomDivider(
                  backgroundColor: Colors.white,
                  height: 20.h,
                  text: 'OR',
                  fontSize: 16.r,
                  fontFamily: AppTheme.primaryFont,
                  textColor: Theme.of(context).primaryColor,
                  thickness: 2,
                  indent: 20.w,
                  endIndent: 20.w,


                ),
                20.verticalSpace,
                //Google Login
                ResponsiveButton(
                  onPressed: () {

                  },
                  clickable: true,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  buttonStyle: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.surface),
                    overlayColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 10.r),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.r)),
                      ),
                    ),
                  ),
                  buttonWidth: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('labels_register_with_Google'.tr, style: Theme.of(context).textTheme.bodyMedium,),
                      10.horizontalSpace,
                      Image.asset(
                        'assets/google.png',
                        width: 20,
                        height: 20,
                      ),

                    ],
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
