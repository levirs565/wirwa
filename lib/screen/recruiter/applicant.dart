import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class RecruiterApplicantController extends GetxController {
  static const String ARGUMENT_ID = "id"; // Ini harusnya Job ID (bukan Application ID)

  final JobApplicationRepository jobApplicationRepository = Get.find();

  String jobId = "";
  final RxList<JobApplicationWithSeeker> allApplications = <JobApplicationWithSeeker>[].obs;
  final RxString selectedTab = "Pelamar".obs; // Pilihan: "Pelamar", "Seleksi"

  @override
  void onInit() {
    super.onInit();
    // Kita asumsikan ID yang dikirim adalah JobVacancyID untuk melihat semua pelamar di job tersebut
    jobId = Get.arguments[ARGUMENT_ID] ?? "";
  }

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  Future<void> refreshData() async {
    if (jobId.isEmpty) return;
    // Mengambil semua pelamar untuk Job ini
    final apps = await jobApplicationRepository.getAllWithSeeker(jobId);
    allApplications.assignAll(apps);
  }

  // --- Logic Filter Tab ---
  List<JobApplicationWithSeeker> get filteredList {
    if (selectedTab.value == "Pelamar") {
      // Tab Pelamar = Status PENDING
      return allApplications.where((e) => e.application.status == JobApplicationStatus.PENDING).toList();
    } else {
      // Tab Seleksi = Status ACCEPTED (Diterima/Tahap Seleksi)
      return allApplications.where((e) => e.application.status == JobApplicationStatus.ACCEPTED).toList();
    }
  }

  String get pelamarCount =>
      allApplications.where((e) => e.application.status == JobApplicationStatus.PENDING).length.toString();

  // PERBAIKAN: Menambahkan 'get' di sini
  String get seleksiCount =>
      allApplications.where((e) => e.application.status == JobApplicationStatus.ACCEPTED).length.toString();

  // --- Actions ---
  Future<void> accept(String applicationId) async {
    await jobApplicationRepository.setState(applicationId, JobApplicationStatus.ACCEPTED);
    refreshData();
    Get.snackbar("Berhasil", "Pelamar dipindahkan ke tahap Seleksi", backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(16));
  }

  Future<void> reject(String applicationId) async {
    await jobApplicationRepository.setState(applicationId, JobApplicationStatus.REJECTED);
    refreshData();
    Get.snackbar("Ditolak", "Pelamar telah ditolak", backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.all(16));
  }
}

class RecruiterApplicantPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {RecruiterApplicantController.ARGUMENT_ID: id};
  }

  final RecruiterApplicantController controller = Get.put(RecruiterApplicantController());

  RecruiterApplicantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7), // Background Pink Muda
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA01355), // Merah Marun
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Daftar Pelamar",
                        style: TextStyle(
                          color: Colors.black87, // Judul Hitam sesuai gambar (di gambar agak gelap)
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer
                ],
              ),
            ),

            // --- TABS (Pelamar / Seleksi) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton(
                    "Pelamar",
                    controller.pelamarCount,
                    isActive: controller.selectedTab.value == "Pelamar",
                    onTap: () => controller.selectedTab.value = "Pelamar",
                  ),
                  const SizedBox(width: 16),
                  _buildTabButton(
                    "Seleksi",
                    controller.seleksiCount,
                    isActive: controller.selectedTab.value == "Seleksi",
                    onTap: () => controller.selectedTab.value = "Seleksi",
                  ),
                ],
              )),
            ),

            const SizedBox(height: 24),

            // --- LIST PELAMAR ---
            Expanded(
              child: Obx(() {
                final list = controller.filteredList;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "Tidak ada data di tab ${controller.selectedTab.value}",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _buildApplicantCard(item);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildTabButton(String label, String count, {required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE57373) : Colors.white, // Aktif: Pink Orange, Non: Putih
          borderRadius: BorderRadius.circular(12),
          border: isActive ? null : Border.all(color: const Color(0xFFE57373).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFE57373),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : const Color(0xFFE57373).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                count,
                style: TextStyle(
                  color: isActive ? const Color(0xFFE57373) : const Color(0xFFE57373),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantCard(JobApplicationWithSeeker item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Background Card Putih
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.seeker.pictureUrl.isNotEmpty
                    ? Image.network(
                  item.seeker.pictureUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    width: 50, height: 50, color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                )
                    : Container(
                  width: 50, height: 50, color: Colors.grey[300],
                  child: Center(child: Text(item.seeker.name[0], style: const TextStyle(fontWeight: FontWeight.bold))),
                ),
              ),
              // Status Dot Hijau (Online/Active)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Info Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.seeker.name,
                  style: const TextStyle(
                    color: Color(0xFFA01355),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Dummy details karena model UserJobSeeker belum punya field detail
                Text(
                  "Tamat SMA, Kemampuan Komunikasi, 1 Tahun Pengalaman",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Buttons (Check & Cross)
          // Hanya tampil jika status masih Pending (Tab Pelamar)
          if (controller.selectedTab.value == "Pelamar") ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: () => controller.accept(item.application.id),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check, color: Colors.green, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => controller.reject(item.application.id),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close, color: Colors.red, size: 20),
              ),
            ),
          ] else ...[
            // Jika Tab Seleksi, tampilkan status badge saja
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Lolos",
                style: TextStyle(color: Colors.green[700], fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )
          ]
        ],
      ),
    );
  }
}