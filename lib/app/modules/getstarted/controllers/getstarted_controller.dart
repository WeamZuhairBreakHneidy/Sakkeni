import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class GetstartedController extends GetxController {

  final count = 0.obs;



  void increment() => count.value++;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offNamed(Routes.AUTH);
  }
}
