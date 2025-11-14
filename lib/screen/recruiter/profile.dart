import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class RecruiterProfileController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final Rx<UserRecruiter?> profile = Rxn();

  @override
  void onReady() {
    super.onReady();
    userRepository
        .getRecruiterProfile(authRepository.getUserId()!)
        .then((value) {
          profile.value = value;
    });
  }

  Future<void> logout() async {
    await authRepository.signOut();
  }
}

class RecruiterProfilePage extends StatelessWidget {
  final RecruiterProfileController controller = Get.put(RecruiterProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recruiter Job List")),
      body: Column(
        children: [
          Obx(() => Text(controller.profile.value?.name ?? "")),
          OutlinedButton(onPressed: controller.logout, child: Text("Logout"))
        ],
      ),
    );
  }
}
