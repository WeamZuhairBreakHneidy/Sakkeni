import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/payment_service_provider_controller.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final String? serviceId = Get.arguments as String?;
    final PaymentController controller = Get.put(PaymentController());

    if (serviceId == null) {
      return Scaffold(
        body: Center(
          child: Text("Error: Service ID not found."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Payment"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Obx listens to the isLoading variable and reacts to it
              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      controller.makePayment(serviceId: serviceId);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Pay"),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}