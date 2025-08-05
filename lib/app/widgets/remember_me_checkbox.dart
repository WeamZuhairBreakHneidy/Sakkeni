import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RememberMeCheckbox extends StatelessWidget {
  final RxBool isChecked;
  final Color? activeColor;

  const RememberMeCheckbox({
    super.key,
    required this.isChecked,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => FittedBox(
        child: Row(
          children: [
            Checkbox(
              value: isChecked.value,
              onChanged: (value) {
                if (value != null) isChecked.value = value;
              },
              checkColor: Theme.of(context).primaryColor,
              activeColor: activeColor ?? Theme.of(context).colorScheme.surface,
              side: BorderSide(
                color: activeColor ?? Theme.of(context).colorScheme.surface,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            SizedBox(width: 4),
            Text(
              'labels_remember_me'.tr,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
