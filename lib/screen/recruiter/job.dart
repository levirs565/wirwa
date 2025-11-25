import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/applicant_list.dart';

class RecruiterJobController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();

  String id = "";
  Rx<JobVacancy?> job = Rxn();
  RxList<JobApplicationWithSeeker> applications =
      <JobApplicationWithSeeker>[].obs;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments[ARGUMENT_ID];
  }

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  Future<void> refresh() async {
    final job = await jobVacancyRepository.getById(id);
    this.job.value = job;

    final applications = await jobApplicationRepository.getAllWithSeeker(id);
    this.applications.value = applications;
  }

  Future<void> goToApplicantList() async {
    await Get.to(
      () => RecruiterApplicantListPage(),
      arguments: RecruiterApplicantListPage.createArguments(id),
    );
    await refresh();
  }
}

class RecruiterJobPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {RecruiterJobController.ARGUMENT_ID: id};
  }

  final RecruiterJobController controller = Get.put(RecruiterJobController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background konten bawah putih
      body: Obx(() {
        if (controller.job.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final job = controller.job.value!;
        // Use fields directly from model
        final salary = job.salary ?? "-";
        final type = job.jobType ?? "-";
        final location = job.workPolicy ?? job.location;

        return Stack(
          children: [
            // 1. Background Pink Header (Melengkung)
            Container(
              height: 380,
              decoration: const BoxDecoration(
                color: Color(0xFFA01355), // Warna Utama
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),

            // 2. Content Scrollable
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60), // Space untuk App Bar
                  // --- HEADER INFO ---
                  Center(
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              'assets/images/gambar1.png',
                            ), // Placeholder Logo
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Job Title
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Company Name
                        const Text(
                          "Perusahaan Recruiter",
                          // Placeholder (karena model blm ada field nama PT)
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        // Status Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCDD2), // Pink muda
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Aktif Menyeleksi",
                            style: TextStyle(
                              color: Color(0xFFA01355),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- FLOATING STATS CARD (Gaji, Tipe, Lokasi) ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoItem(
                            Icons.monetization_on_outlined,
                            salary != "-" ? salary : "Negosiasi",
                            "Gaji",
                          ),
                          _buildInfoItem(
                            Icons.access_time,
                            type != "-" ? type : "Full Time",
                            "Tipe",
                          ),
                          _buildInfoItem(
                            Icons.location_on_outlined,
                            location != "-" ? location : "Remote",
                            "Lokasi",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- DESCRIPTION ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tentang Lowongan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          job.description,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        OutlinedButton(
                          onPressed: controller.goToApplicantList,
                          child: const Text("Daftat Pelamar"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. Top Navigation Bar (Back & Actions)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Actions (Bookmark & Share)
                      Row(
                        children: [
                          const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.share_outlined, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFFDF5F7), // Pink sangat muda
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFA01355), size: 24),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
