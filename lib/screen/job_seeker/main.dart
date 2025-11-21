import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobSeekerController extends GetxController {
  final RxInt activePage = 0.obs;
}

// NAMA CLASS DIBETULKAN: JobSeekerPage
class JobSeekerPage extends StatelessWidget {
  final JobSeekerController controller = Get.put(JobSeekerController());

  final List<Widget> pages = [
    const Scaffold(body: Center(child: Text("Home Job Seeker"))),
    const Scaffold(body: Center(child: Text("Lamaran Saya"))),
    const Scaffold(body: Center(child: Text("Profil Job Seeker"))),
  ];

  JobSeekerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.activePage.value]),
      bottomNavigationBar: Obx(
            () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            height: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            indicatorColor: Colors.transparent,
            selectedIndex: controller.activePage.value,
            onDestinationSelected: (index) => controller.activePage.value = index,
            destinations: [
              _buildNavItem(Icons.work, Icons.work_outline, 'Lowongan', 0),
              _buildNavItem(Icons.description, Icons.description_outlined, 'Lamaran', 1),
              _buildNavItem(Icons.person, Icons.person_outline, 'Profil', 2),
            ],
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildNavItem(IconData activeIcon, IconData icon, String label, int index) {
    final isSelected = controller.activePage.value == index;
    return NavigationDestination(
      icon: Icon(
        isSelected ? activeIcon : icon,
        // Warna ungu untuk Job Seeker (pembeda)
        color: isSelected ? Colors.deepPurple : Colors.grey,
        size: 26,
      ),
      label: label,
    );
  }
}