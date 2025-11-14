import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/screen/job_seeker/job_list.dart';
import 'package:wirwa/screen/job_seeker/profile.dart';

class JobSeekerController extends GetxController {
  final RxInt activePage = 0.obs;
}


class JobSeekerPage extends StatelessWidget {
  final JobSeekerController controller = Get.put(JobSeekerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: controller.activePage.value,
          children: [
            JobSeekerJobListPage(),
            JobSeekerProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
          selectedIndex: controller.activePage.value,
          onDestinationSelected: (index) => controller.activePage.value = index,
        ),
      ),
    );
  }
}
