import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class JobSeekerJobController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();

  String id = "";
  Rx<JobVacancy?> job = Rxn();
  Rx<UserRecruiter?> recruiter = Rxn();
  Rx<JobApplication?> application = Rxn();

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
    final job = await jobVacancyRepository.getById(id);
    if (job == null) return;
    final recruiter = await userRepository.getRecruiterProfile(job.recruiterId);
    if (recruiter == null) return;
    final application = await jobApplicationRepository.get(
      id,
      authRepository.getUserId()!,
    );

    this.application.value = application;
    this.recruiter.value = recruiter;
    this.job.value = job;
  }

  Future<void> apply() async {
    await jobApplicationRepository.add(
      JobApplication(
        id: "",
        createdAt: DateTime.now(),
        status: JobApplicationStatus.PENDING,
        jobVacancyId: id,
        jobSeekerId: authRepository.getUserId()!,
      ),
    );
    await refresh();
  }
}

class JobSeekerJobPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {JobSeekerJobController.ARGUMENT_ID: id};
  }

  final JobSeekerJobController controller = Get.put(JobSeekerJobController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => controller.job.value == null
              ? Center(child: CircularProgressIndicator())
              : _content(context),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(controller.job.value!.title),
        Text(controller.job.value!.description),
        Text(controller.job.value!.location),
        Text("Company:${controller.recruiter.value?.name ?? ""}"),
        Text(
          controller.application.value == null
              ? "Belum Dilamar"
              : "Status ${controller.application.value!.status.toString()}",
        ),
        controller.application.value == null
            ? OutlinedButton(
                onPressed: controller.apply,
                child: const Text("Lamar"),
              )
            : Center(),
      ],
    );
  }
}
