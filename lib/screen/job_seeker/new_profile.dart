import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/main.dart';

class JobSeekerNewProfileController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final Rx<String> name = "".obs;
  final Rx<String?> nameError = Rxn(null);
  final Rx<String> domisili = "".obs;
  final Rx<String?> domisiliError = Rxn(null);
  final Rx<String> phoneNumber = "".obs;
  final Rx<String?> phoneNumberError = Rxn(null);

  bool get canSubmit =>
      nameError.value == null &&
      domisiliError.value == null &&
      phoneNumberError.value == null;

  @override
  void onReady() {
    super.onReady();
    setName("");
    setDomisili("");
    setPhoneNumber("");
  }

  void setName(String value) {
    name.value = value;

    if (name.trim().length < 5) {
      nameError.value = "Name must be at least 5 characters";
    } else {
      nameError.value = null;
    }
  }

  void setDomisili(String value) {
    domisili.value = value;

    if (domisili.trim().length < 5) {
      domisiliError.value = "Domisili must be at least 5 characters";
    } else {
      domisiliError.value = null;
    }
  }

  void setPhoneNumber(String value) {
    phoneNumber.value = value;

    if (phoneNumber.trim().length < 5) {
      phoneNumberError.value = "Phone number must be at least 5 characters";
    } else {
      phoneNumberError.value = null;
    }
  }

  Future<void> onSubmit() async {
    await userRepository.setJobSeekerProfile(
      UserJobSeeker(
        id: authRepository.getUserId()!,
        birthDate: DateTime.now(),
        domisili: domisili.value,
        name: name.value,
        phoneNumber: phoneNumber.value,
        pictureUrl: "",
      ),
    );
    Get.off(JobSeekerPage());
  }
}

class JobSeekerNewProfilePage extends StatelessWidget {
  final controller = Get.put(JobSeekerNewProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Account")),
      body: Column(
        children: [
          Obx(
            () => TextField(
              onChanged: controller.setName,
              decoration: InputDecoration(
                labelText: "Nama",
                errorText: controller.nameError.value,
              ),
            ),
          ),
          Obx(
            () => TextField(
              onChanged: controller.setDomisili,
              decoration: InputDecoration(
                labelText: "Domisili",
                errorText: controller.domisiliError.value,
              ),
            ),
          ),
          Obx(
            () => TextField(
              onChanged: controller.setPhoneNumber,
              decoration: InputDecoration(
                labelText: "Nomor HP",
                errorText: controller.phoneNumberError.value,
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
