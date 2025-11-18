import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

import 'workshop.dart';

class JobSeekerWorkshopListController extends GetxController {
  final WorkshopRepository workshopRepository = Get.find();
  final RxList<WorkshopWithRecruiter> workshops = <WorkshopWithRecruiter>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    workshopRepository
        .getAll()
        .then((value) {
          workshops.clear();
          workshops.insertAll(0, value);
        });
  }

  Future<void> toDetail(String id) async {
    await Get.to(
      () => JobSeekerWorkshopPage(),
      arguments: JobSeekerWorkshopPage.createArguments(id),
    );
    refresh();
  }
}

class JobSeekerWorkshopListPage extends StatelessWidget {
  final controller = Get.put(JobSeekerWorkshopListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Seeker Workshop List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => controller.workshops.isEmpty ? const Text("Kosong") : _list(context),
        ),
      ),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      itemCount: controller.workshops.length,
      itemBuilder: (context, index) =>
          _listItem(context, controller.workshops[index]),
    );
  }

  Widget _listItem(BuildContext context, WorkshopWithRecruiter data) {
    return InkWell(
      onTap: () => controller.toDetail(data.workshop.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data.workshop.title),
        ),
      ),
    );
  }
}
