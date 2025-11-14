import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class JobSeekerProfileController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final Rx<UserJobSeeker?> profile = Rxn();

  @override
  void onReady() {
    super.onReady();
    userRepository
        .getJobSeekerProfile(authRepository.getUserId()!)
        .then((value) {
          profile.value = value;
    });
  }

  Future<void> logout() async {
    await authRepository.signOut();
  }
}

class JobSeekerProfilePage extends StatelessWidget {
  final JobSeekerProfileController controller = Get.put(JobSeekerProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Seeker Profile")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => Text(controller.profile.value?.name ?? "")),
            OutlinedButton(onPressed: controller.logout, child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
