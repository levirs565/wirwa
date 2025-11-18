import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/utils/validator.dart';

class RecruiterNewWorkshopController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final WorkshopRepository workshopRepository = Get.find();
  final Rx<String> title = "".obs;
  final Rx<String?> titleError = Rxn(null);
  final Rx<String> description = "".obs;
  final Rx<String?> descriptionError = Rxn(null);
  final Rx<String> formUrl = "".obs;
  final Rx<String?> formUrlError = Rxn(null);

  bool get canSubmit =>
      titleError.value == null &&
      descriptionError.value == null &&
      formUrlError.value == null;

  @override
  void onReady() {
    super.onReady();
    setTitle("");
    setDescription("");
    setFormUrl("");
  }

  void setTitle(String value) {
    title.value = value;

    if (title.trim().length < 5) {
      titleError.value = "Title must be at least 5 characters";
    } else {
      titleError.value = null;
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

  void setFormUrl(String value) {
    formUrl.value = value;

    if (!validateIsLink(formUrl.value)) {
      formUrlError.value = "Form url must be link";
    } else {
      formUrlError.value = null;
    }
  }

  Future<void> onSubmit() async {
    await workshopRepository.add(
      Workshop(
        id: "",
        createdAt: DateTime.now(),
        title: title.value,
        description: description.value,
        formUrl: formUrl.value,
        recruiterId: authRepository.getUserId()!,
      ),
    );
    Get.back();
  }
}

class RecruiterNewWorkshopPage extends StatelessWidget {
  final controller = Get.put(RecruiterNewWorkshopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Workshop")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                maxLines: null,
                onChanged: controller.setDescription,
                decoration: InputDecoration(
                  labelText: "Description",
                  errorText: controller.descriptionError.value,
                ),
              ),
            ),
            Obx(
              () => TextField(
                onChanged: controller.setFormUrl,
                decoration: InputDecoration(
                  labelText: "Form URL",
                  errorText: controller.formUrlError.value,
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
      ),
    );
  }
}
