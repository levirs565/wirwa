import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/applicant.dart';

class RecruiterJobController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();

  String id = "";
  Rx<JobVacancy?> job = Rxn();
  RxList<JobApplicationWithSeeker> applications =
      <JobApplicationWithSeeker>[].obs;

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
    this.job.value = job;

    final applications = await jobApplicationRepository.getAllWithSeeker(id);
    this.applications.value = applications;
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

  Future<void> toDetail(String id) async {
    await Get.to(() => RecruiterApplicantPage(), arguments: RecruiterApplicantPage.createArguments(id));
    await refresh();
  }
}

class RecruiterJobPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {RecruiterJobController.ARGUMENT_ID: id};
  }

  final RecruiterJobController controller = Get.put(RecruiterJobController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Obx(
                  () => controller.job.value == null
                      ? Center(child: CircularProgressIndicator())
                      : _content(context),
                ),
              ),
            ),
            Text("Applicant"),
            Expanded(child: _applicationList(context)),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.job.value!.title),
          Text(controller.job.value!.description),
          Text(controller.job.value!.location),
        ],
      ),
    );
  }

  Widget _applicationList(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.applications.length,
        itemBuilder: (context, index) =>
            _applicationItem(context, controller.applications[index]),
      ),
    );
  }

  Widget _applicationItem(BuildContext context, JobApplicationWithSeeker data) {
    return InkWell(
      onTap: () => controller.toDetail(data.application.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.seeker.name),
              Text(data.application.status.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
