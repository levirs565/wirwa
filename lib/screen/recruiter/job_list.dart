import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/job.dart';
import 'package:wirwa/screen/recruiter/new_job.dart';

class RecruiterJobListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final RxList<JobVacancy> jobs = <JobVacancy>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    jobVacancyRepository
        .getAll(recruiterIdFilter: authRepository.getUserId())
        .then((value) {
          jobs.clear();
          jobs.insertAll(0, value);
        });
  }

  void newJob() async {
    await Get.to(RecruiterNewJobPage());
    refresh();
  }

  Future<void> toDetail(String id) async {
    await Get.to(
      () => RecruiterJobPage(),
      arguments: RecruiterJobPage.createArguments(id),
    );
    refresh();
  }
}

class RecruiterJobListPage extends StatelessWidget {
  final RecruiterJobListController controller = Get.put(
    RecruiterJobListController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recruiter Job List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => controller.jobs.isEmpty ? const Text("Kosong") : _list(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.newJob,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      itemCount: controller.jobs.length,
      itemBuilder: (context, index) =>
          _listItem(context, controller.jobs[index]),
    );
  }

  Widget _listItem(BuildContext context, JobVacancy job) {
    return InkWell(
      onTap: () => controller.toDetail(job.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(job.title),
        ),
      ),
    );
  }
}
