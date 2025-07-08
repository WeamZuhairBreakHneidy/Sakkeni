import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddpropertyController extends GetxController {
  final location = TextEditingController();
  final selectedDirections = <String>[].obs;


  void toggleDirection(String direction) {
    if (selectedDirections.contains(direction)) {
      selectedDirections.remove(direction);
    } else {
      selectedDirections.add(direction);
    }
  }

  final count = 0.obs;



  void increment() => count.value++;
}
