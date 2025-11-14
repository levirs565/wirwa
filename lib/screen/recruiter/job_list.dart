import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/new_job.dart';

class RecruiterJobListController extends GetxController {
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final RxList<JobVacancy> jobs = <JobVacancy>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    jobVacancyRepository
        .getAll(
          recruiterIdFilter:
              Supabase.instance.client.auth.currentUser?.id ?? "",
        )
        .then((value) {
          jobs.clear();
          jobs.insertAll(0, value);
        });
  }

  void newJob() async {
    await Get.to(RecruiterNewJobPage());
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
      body: Obx(
        () => controller.jobs.isEmpty ? const Text("Kosong") : _list(context),
      ),
      floatingActionButton: FloatingActionButton(onPressed: controller.newJob),
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
