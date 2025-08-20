import 'package:get/get.dart';
import '../../../data/models/subscription_plan_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class SubscriptionPlanController extends GetxController {
  var isLoading = false.obs;

  var subscriptionPlanModel =
      SubscriptionPlanModel(status: false, message: "", data: []).obs;

  var selectedPlan = Rxn<Datum>();

  final tokenService = TokenService();

  @override
  void onInit() {
    fetchSubscriptionPlans();
    super.onInit();
  }

  Future<void> fetchSubscriptionPlans() async {
    isLoading.value = true;

    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: ApiEndpoints.viewSubscriptionPlan,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        subscriptionPlanModel.value = SubscriptionPlanModel.fromJson(
          response.body,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load subscription plans. (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print("Exception in fetchSubscriptionPlans: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a subscription plan
  void selectPlan(Datum? plan) {
    selectedPlan.value = plan;
  }
}
