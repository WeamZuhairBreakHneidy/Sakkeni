// lib/app/modules/property_details/views/property_details_view.dart
import 'package:flutter/material.dart';
import '../../../data/models/properties-model.dart';

class PropertyDetailsView extends StatelessWidget {
  final Datum property;

  const PropertyDetailsView({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل العقار')),

    );
  }
}
