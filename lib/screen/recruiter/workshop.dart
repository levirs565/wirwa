import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class RecruiterWorkshopController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final WorkshopRepository workshopRepository = Get.find();
  final UserRepository userRepository = Get.find();

  String id = "";
  final Rx<Workshop?> workshop = Rxn();

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments[ARGUMENT_ID];
  }

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  Future<void> refresh() async {
    final workshop = await workshopRepository.getById(id);
    this.workshop.value = workshop;
  }
}

class RecruiterWorkshopPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {RecruiterWorkshopController.ARGUMENT_ID: id};
  }

  final controller = Get.put(RecruiterWorkshopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workshop")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(controller.workshop.value?.title ?? "")),
            Obx(() => Text(controller.workshop.value?.description ?? "")),
            Obx(() => Text(controller.workshop.value?.formUrl ?? "")),
          ],
        ),
      ),
    );
  }
}
