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
  final RxString searchQuery = "".obs;
  final RxList<Workshop> allWorkshops = <Workshop>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  @override
  void onClose() {
    workshops.clear();
    allWorkshops.clear();
    print("RecruiterWorkshopListController disposed");
    super.onClose();
  }

  void refresh() {
    workshopRepository.getByRecruiterId(authRepository.getUserId()!).then((
      value,
    ) {
      workshops.clear();
      workshops.insertAll(0, value);
      allWorkshops.clear();
      allWorkshops.insertAll(0, value);
    });
  }

  void searchWorkshops(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      workshops.assignAll(allWorkshops);
    } else {
      workshops.assignAll(
        allWorkshops
            .where(
              (workshop) =>
                  workshop.title.toLowerCase().contains(query.toLowerCase()) ||
                  workshop.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList(),
      );
    }
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

  String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}

class RecruiterWorkshopListPage extends StatelessWidget {
  RecruiterWorkshopListPage({Key? key}) : super(key: key);

  RecruiterWorkshopListController get controller {
    if (!Get.isRegistered<RecruiterWorkshopListController>()) {
      return Get.put(
        RecruiterWorkshopListController(),
        tag: 'recruiter_workshop_list',
      );
    }
    return Get.find<RecruiterWorkshopListController>();
  }

  final Color kBackgroundColor = const Color(0xFFFFF5F7);
  final Color kPrimaryColor = const Color(0xFFA01355);
  final Color kTextColor = const Color(0xFF1F1F1F);
  final Color kSubtitleColor = const Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => controller.workshops.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              controller.searchQuery.isEmpty
                                  ? "Belum ada workshop"
                                  : "Tidak ada hasil pencarian",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.workshops.length,
                        itemBuilder: (context, index) =>
                            _buildWorkshopCard(controller.workshops[index]),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.newWorkshop,
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Workshop Baru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Workshop",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
              ),
              Text(
                "Kelola workshop Anda",
                style: TextStyle(fontSize: 14, color: kSubtitleColor),
              ),
            ],
          ),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.library_books, color: kPrimaryColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        onChanged: (value) => controller.searchWorkshops(value),
        decoration: InputDecoration(
          hintText: "Cari workshop...",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: kPrimaryColor),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: kPrimaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildWorkshopCard(Workshop workshop) {
    return GestureDetector(
      onTap: () => controller.toDetail(workshop.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Workshop
            if (workshop.imageUrl != null && workshop.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  workshop.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: kPrimaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.image_not_supported,
                        color: kPrimaryColor,
                        size: 50,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      color: kPrimaryColor.withOpacity(0.1),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Konten Workshop
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.school,
                          color: kPrimaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workshop.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: kSubtitleColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller.formatDate(workshop.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kSubtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    workshop.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: kSubtitleColor,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.link, size: 16, color: kPrimaryColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Link Pendaftaran",
                          style: TextStyle(fontSize: 12, color: kSubtitleColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: kSubtitleColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
