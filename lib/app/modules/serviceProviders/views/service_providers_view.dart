import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/service_providers_controller.dart';

class ServiceProvidersView extends GetView<ServiceProvidersController> {
  const ServiceProvidersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ServiceProvidersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ServiceProvidersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
