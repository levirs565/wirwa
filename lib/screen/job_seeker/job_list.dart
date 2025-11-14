import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class JobSeekerJobListController extends GetxController {
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final RxList<JobVacancy> jobs = <JobVacancy>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    jobVacancyRepository.getAll().then((value) {
      jobs.clear();
      jobs.insertAll(0, value);
    });
  }
}

class JobSeekerJobListPage extends StatelessWidget {
  final JobSeekerJobListController controller = Get.put(
    JobSeekerJobListController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Seeker Job List")),
      body: Obx(
        () => controller.jobs.isEmpty ? const Text("Kosong") : _list(context),
      )
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      itemCount: controller.jobs.length,
      itemBuilder: (context, index) =>
          _listTile(context, controller.jobs[index]),
    );
  }

  Widget _listTile(BuildContext context, JobVacancy job) {
    return InkWell(
      onTap: () => {},
      child: Card(child: Text(job.title)),
    );
  }
}
