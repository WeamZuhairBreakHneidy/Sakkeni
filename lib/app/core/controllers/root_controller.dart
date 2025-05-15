import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/services/token_service.dart';
import '../../routes/app_pages.dart';

class RootController extends GetxController {
  final TokenService tokenService = TokenService();
  final GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();

  }


}
