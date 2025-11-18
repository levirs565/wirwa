import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'job_list.dart';
import 'profile.dart';
import 'workshop_list.dart';

class RecruiterController extends GetxController {
  final RxInt activePage = 0.obs;
}

class RecruiterPage extends StatelessWidget {
  final RecruiterController controller = Get.put(RecruiterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.activePage.value,
          children: [
            RecruiterJobListPage(),
            RecruiterWorkshopListPage(),
            RecruiterProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Jobs'),
            NavigationDestination(icon: Icon(Icons.pending), label: 'Workshop'),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
          selectedIndex: controller.activePage.value,
          onDestinationSelected: (index) => controller.activePage.value = index,
        ),
      ),
    );
  }
}
