import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/job.dart';

class JobSeekerApplicationListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();
  final RxList<JobApplicationWithVacancy> jobs =
      <JobApplicationWithVacancy>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    jobApplicationRepository
        .getAllWithVacancy(authRepository.getUserId()!)
        .then((value) {
          jobs.clear();
          jobs.insertAll(0, value);
        });
  }

  void toDetail(String id) {
    Get.to(
      () => JobSeekerJobPage(),
      arguments: JobSeekerJobPage.createArguments(id),
    );
  }
}

class JobSeekerApplicationListPage extends StatelessWidget {
  final JobSeekerApplicationListController controller = Get.put(
    JobSeekerApplicationListController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Seeker Job List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => controller.jobs.isEmpty ? const Text("Kosong") : _list(context),
        ),
      ),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      itemCount: controller.jobs.length,
      itemBuilder: (context, index) =>
          _listTile(context, controller.jobs[index]),
    );
  }

  Widget _listTile(BuildContext context, JobApplicationWithVacancy job) {
    return InkWell(
      onTap: () => controller.toDetail(job.vacancy.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.vacancy.title),
              Text(job.application.status.toString())
            ],
          ),
        ),
      ),
    );
  }
}
