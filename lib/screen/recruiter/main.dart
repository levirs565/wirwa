import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/screen/recruiter/job_list.dart';
import 'package:wirwa/screen/recruiter/profile.dart';

class RecruiterController extends GetxController {
  final RxInt activePage = 0.obs;
}

class RecruiterPage extends StatelessWidget {
  final RecruiterController controller = Get.put(RecruiterController());

  RecruiterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List halaman tidak boleh const karena RecruiterJobListPage punya logic
    final List<Widget> pages = [
      RecruiterJobListPage(),
      const Scaffold(body: Center(child: Text("Halaman Chat"))),
      RecruiterProfilePage(),
    ];

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
              _buildNavItem(Icons.home_filled, Icons.home_outlined, 'Beranda', 0),
              _buildNavItem(Icons.chat_bubble, Icons.chat_bubble_outline, 'Chat', 1),
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
        color: isSelected ? const Color(0xFFA01355) : Colors.grey,
        size: 26,
      ),
      label: label,
    );
  }
}