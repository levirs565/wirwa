import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/applicant.dart';

class RecruiterJobController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();

  String id = "";
  Rx<JobVacancy?> job = Rxn();
  RxList<JobApplicationWithSeeker> applications = <JobApplicationWithSeeker>[].obs;

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

  Future<void> toDetail(String id) async {
    await Get.to(() => RecruiterApplicantPage(), arguments: RecruiterApplicantPage.createArguments(id));
    await refresh();
  }

  // Helper untuk parsing metadata dari deskripsi (Sama seperti di Job List)
  String extractMetadata(String description, String key) {
    try {
      final line = description.split('\n').firstWhere((l) => l.contains(key), orElse: () => "");
      if (line.isNotEmpty) {
        return line.split(": ")[1].trim();
      }
    } catch (_) {}
    return "-";
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
        // Parsing Data untuk Tampilan UI agar dinamis
        final salary = controller.extractMetadata(job.description, "- Gaji:");
        final type = controller.extractMetadata(job.description, "- Tipe:");
        final location = job.location.isNotEmpty ? job.location : controller.extractMetadata(job.description, "- Kebijakan:");

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
                            backgroundImage: AssetImage('assets/images/gambar1.png'), // Placeholder Logo
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
                          "Perusahaan Recruiter", // Placeholder (karena model blm ada field nama PT)
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Status Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                          _buildInfoItem(Icons.monetization_on_outlined, salary != "-" ? salary : "Negosiasi", "Gaji"),
                          _buildInfoItem(Icons.access_time, type != "-" ? type : "Full Time", "Tipe"),
                          _buildInfoItem(Icons.location_on_outlined, location != "-" ? location : "Remote", "Lokasi"),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          job.description,
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),

                        const SizedBox(height: 30),

                        // --- LIST PELAMAR (Pengganti tombol daftar) ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Pelamar (Applicant)",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFA01355),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${controller.applications.length}",
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (controller.applications.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: Text("Belum ada pelamar.", style: TextStyle(color: Colors.grey))),
                          )
                        else
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.applications.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) => _buildApplicantCard(
                              controller.applications[index],
                                  () => controller.toDetail(controller.applications[index].application.id),
                            ),
                          ),

                        const SizedBox(height: 40),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      // Actions (Bookmark & Share)
                      Row(
                        children: [
                          const Icon(Icons.bookmark_border, color: Colors.white),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildApplicantCard(JobApplicationWithSeeker data, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              backgroundImage: (data.seeker.pictureUrl.isNotEmpty)
                  ? NetworkImage(data.seeker.pictureUrl) as ImageProvider
                  : null,
              child: data.seeker.pictureUrl.isEmpty
                  ? Text(data.seeker.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFFA01355), fontWeight: FontWeight.bold))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.seeker.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: data.application.status == JobApplicationStatus.PENDING
                          ? Colors.orange[100]
                          : (data.application.status == JobApplicationStatus.ACCEPTED ? Colors.green[100] : Colors.red[100]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      data.application.status.toString().split('.').last,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: data.application.status == JobApplicationStatus.PENDING
                            ? Colors.orange[800]
                            : (data.application.status == JobApplicationStatus.ACCEPTED ? Colors.green[800] : Colors.red[800]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}