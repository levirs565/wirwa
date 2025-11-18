import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/new_workshop.dart';
import 'package:wirwa/screen/recruiter/workshop.dart';

class RecruiterWorkshopListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final WorkshopRepository workshopRepository = Get.find();
  final RxList<Workshop> workshops = <Workshop>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    workshopRepository
        .getByRecruiterId(authRepository.getUserId()!)
        .then((value) {
          workshops.clear();
          workshops.insertAll(0, value);
        });
  }

  void newWorkshop() async {
    await Get.to(RecruiterNewWorkshopPage());
    refresh();
  }

  Future<void> toDetail(String id) async {
    await Get.to(
      () => RecruiterWorkshopPage(),
      arguments: RecruiterWorkshopPage.createArguments(id),
    );
    refresh();
  }
}

class RecruiterWorkshopListPage extends StatelessWidget {
  final controller = Get.put(RecruiterWorkshopListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recruiter Workshop List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => controller.workshops.isEmpty ? const Text("Kosong") : _list(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.newWorkshop,
        child: Icon(Icons.add),
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

  Widget _listItem(BuildContext context, Workshop workshop) {
    return InkWell(
      onTap: () => controller.toDetail(workshop.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(workshop.title),
        ),
      ),
    );
  }
}
