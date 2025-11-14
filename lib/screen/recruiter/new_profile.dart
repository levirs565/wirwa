import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/main.dart';

class RecruiterNewProfileController extends GetxController {
  final UserRepository userRepository = Get.find();
  final Rx<UserRecruiterType?> type = Rxn(null);
  final Rx<String?> typeError = Rxn(null);
  final Rx<String> name = "".obs;
  final Rx<String?> nameError = Rxn(null);

  bool get canSubmit => typeError.value == null && nameError.value == null;

  @override
  void onReady() {
    super.onReady();
    setType(null);
    setName("");
  }

  void setName(String value) {
    name.value = value;

    if (name.trim().length < 5) {
      nameError.value = "Name must be at least 5 characters";
    } else {
      nameError.value = null;
    }
  }

  void setType(UserRecruiterType? value) {
    type.value = value;

    if (type.value == null) {
      typeError.value = "Type is required";
    } else {
      typeError.value = null;
    }
  }

  Future<void> onSubmit() async {
    await userRepository.setRecruiterProfile(
      UserRecruiter(
        id: Supabase.instance.client.auth.currentUser?.id ?? "",
        type: type.value!,
        name: name.value,
      ),
    );
    Get.off(RecruiterPage());
  }
}

class RecruiterNewProfilePage extends StatelessWidget {
  final controller = Get.put(RecruiterNewProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Account")),
      body: Column(
        children: [
          Obx(
            () => InputDecorator(
              decoration: InputDecoration(
                labelText: "Jenis",
                errorText: controller.typeError.value,
              ),
              child: DropdownMenu<UserRecruiterType>(
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: UserRecruiterType.COMPANY,
                    label: "Perusahaan",
                  ),
                  DropdownMenuEntry(
                    value: UserRecruiterType.INDIVIDUAL,
                    label: "Perorangan",
                  ),
                ],
                onSelected: controller.setType,
              ),
            ),
          ),
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
