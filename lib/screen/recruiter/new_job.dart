import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class RecruiterNewJobController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository vacancyRepository = Get.find();
  final Rx<String> title = "".obs;
  final Rx<String?> titleError = Rxn(null);
  final Rx<String> location = "".obs;
  final Rx<String?> locationError = Rxn(null);
  final Rx<String> description = "".obs;
  final Rx<String?> descriptionError = Rxn(null);

  bool get canSubmit =>
      titleError.value == null &&
      locationError.value == null &&
      descriptionError.value == null;

  @override
  void onReady() {
    super.onReady();
    setTitle("");
    setLocation("");
    setDescription("");
  }

  void setTitle(String value) {
    title.value = value;

    if (title.trim().length < 5) {
      titleError.value = "Title must be at least 5 characters";
    } else {
      titleError.value = null;
    }
  }

  void setLocation(String value) {
    location.value = value;

    if (location.trim().isEmpty) {
      locationError.value = "Location must not empty";
    } else {
      locationError.value = null;
    }
  }

  void setDescription(String value) {
    description.value = value;

    if (description.trim().length < 5) {
      descriptionError.value = "Description must be at least 5 characters";
    } else {
      descriptionError.value = null;
    }
  }

  Future<void> onSubmit() async {
    await vacancyRepository.add(
      JobVacancy(
        id: "",
        createdAt: DateTime.now(),
        title: title.value,
        location: location.value,
        description: description.value,
        startDate: DateTime.now(),
        endDate: null,
        recruiterId: authRepository.getUserId()!,
      ),
    );
    Get.back();
  }
}

class RecruiterNewJobPage extends StatelessWidget {
  final controller = Get.put(RecruiterNewJobController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Job")),
      body: Column(
        children: [
          Obx(
            () => TextField(
              onChanged: controller.setTitle,
              decoration: InputDecoration(
                labelText: "Title",
                errorText: controller.titleError.value,
              ),
            ),
          ),
          Obx(
            () => TextField(
              onChanged: controller.setLocation,
              decoration: InputDecoration(
                labelText: "Location",
                errorText: controller.locationError.value,
              ),
            ),
          ),
          Obx(
            () => TextField(
              maxLines: null,
              onChanged: controller.setDescription,
              decoration: InputDecoration(
                labelText: "Description",
                errorText: controller.descriptionError.value,
              ),
            ),
          ),
          Obx(
            () => OutlinedButton(
              onPressed: controller.canSubmit ? controller.onSubmit : null,
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
