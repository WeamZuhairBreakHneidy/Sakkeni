import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RememberMeCheckbox extends StatelessWidget {
  final RxBool isChecked;
  final Color? activeColor;
const RememberMeCheckbox({super.key, required this.isChecked, this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Obx(() => FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
      
            checkColor: Theme.of(context).primaryColor,
            side: BorderSide(
              color: activeColor ?? Theme.of(context).colorScheme.surface
            ),
            value: isChecked.value,
            onChanged: (value) {
              isChecked.value = value!;
            },
            activeColor: activeColor ?? Theme.of(context).colorScheme.surface,
          ),
          Text('labels_remember_me'.tr,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ));
  }
}
