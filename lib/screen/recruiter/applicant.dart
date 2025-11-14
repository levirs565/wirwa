import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class RecruiterApplicantController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final JobApplicationRepository jobApplicationRepository = Get.find();
  final UserRepository userRepository = Get.find();

  String id = "";
  final Rx<JobApplication?> application = Rxn();
  final Rx<UserJobSeeker?> seeker = Rxn();

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
    final application = await jobApplicationRepository.getById(id);
    if (application == null) return;
    final profile = await userRepository.getJobSeekerProfile(application.jobSeekerId);

    this.application.value = application;
    this.seeker.value = profile;
  }

  Future<void> setState(JobApplicationStatus state) async {
    await jobApplicationRepository.setState(id, state);
    application.value = application.value?.copyWith(status: state);
  }

  Future<void> accept() async {
    await setState(JobApplicationStatus.ACCEPTED);
  }

  Future<void> reject() async {
    await setState(JobApplicationStatus.REJECTED);
  }
}

class RecruiterApplicantPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {RecruiterApplicantController.ARGUMENT_ID: id};
  }

  final RecruiterApplicantController controller = Get.put(RecruiterApplicantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Applicant")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(controller.seeker.value?.name ?? "")),
            Obx(() => Text(controller.seeker.value?.domisili ?? "")),
            Obx(() => Text(controller.seeker.value?.phoneNumber ?? "")),
            Obx(() => Text(controller.application.value?.status.toString() ?? "")),
            OutlinedButton(onPressed: controller.accept, child: Text("Terima")),
            OutlinedButton(onPressed: controller.reject, child: Text("Tolak")),
          ],
        ),
      ),
    );
  }
}
