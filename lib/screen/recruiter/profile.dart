import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/login.dart';

class RecruiterProfileController extends GetxController {
  final UserRepository userRepository = Get.find();
  final Rx<UserRecruiter?> profile = Rxn();

  @override
  void onReady() {
    super.onReady();
    userRepository
        .getRecruiterProfile(Supabase.instance.client.auth.currentUser!.id)
        .then((value) {
          profile.value = value;
    });
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    GoogleSignIn.instance.signOut();
    GoogleSignIn.instance.disconnect();
    Get.offAll(LoginPage());
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
