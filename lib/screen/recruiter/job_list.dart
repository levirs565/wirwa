import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/job.dart';
import 'package:wirwa/screen/recruiter/new_job.dart';
import 'package:wirwa/screen/recruiter/boost.dart'; // 1. Pastikan import ini ada

// --- CONTROLLER ---
class RecruiterJobListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final UserRepository userRepository = Get.find();

  // State Variables
  final RxList<JobVacancy> allJobs = <JobVacancy>[].obs;
  final RxString userName = "Recruiter".obs;
  final RxString searchQuery = "".obs;
  final RxString selectedStatus = "Aktif".obs;

  @override
  void onReady() {
    super.onReady();
    loadProfile();
    refreshData();
  }

  void loadProfile() async {
    final userId = authRepository.getUserId();
    if (userId != null) {
      final profile = await userRepository.getRecruiterProfile(userId);
      if (profile != null) {
        userName.value = profile.name;
      }
    }
  }

  void refreshData() {
    jobVacancyRepository
        .getAll(recruiterIdFilter: authRepository.getUserId())
        .then((value) {
      allJobs.assignAll(value);
    });
  }

  List<JobVacancy> get filteredJobs {
    var result = allJobs.where((job) {
      final query = searchQuery.value.toLowerCase();
      final title = job.title.toLowerCase();
      return title.contains(query);
    }).toList();

    final now = DateTime.now();
    final status = selectedStatus.value;

    if (status == "Aktif") {
      result = result.where((job) => job.startDate.isBefore(now) && (job.endDate == null || job.endDate!.isAfter(now))).toList();
    } else if (status == "NonAktif") {
      result = result.where((job) => job.endDate != null && job.endDate!.isBefore(now)).toList();
    } else if (status == "Dalam Review") {
      result = result.where((job) => job.startDate.isAfter(now)).toList();
    } else if (status == "Draft") {
      result = [];
    }

    return result;
  }

  String getCountForStatus(String status) {
    final now = DateTime.now();
    if (status == "Aktif") {
      return allJobs.where((job) => job.startDate.isBefore(now) && (job.endDate == null || job.endDate!.isAfter(now))).length.toString();
    } else if (status == "NonAktif") {
      return allJobs.where((job) => job.endDate != null && job.endDate!.isBefore(now)).length.toString();
    } else if (status == "Dalam Review") {
      return allJobs.where((job) => job.startDate.isAfter(now)).length.toString();
    }
    return "0";
  }

  void newJob() async {
    await Get.to(() => RecruiterNewJobPage());
    refreshData();
  }

  Future<void> toDetail(String id) async {
    await Get.to(
          () => RecruiterJobPage(),
      arguments: RecruiterJobPage.createArguments(id),
    );
    refreshData();
  }

  // 2. Tambahkan fungsi navigasi ke Halaman Boost
  void toBoostPage(JobVacancy job) {
    Get.to(() => RecruiterBoostPage(), arguments: RecruiterBoostPage.createArguments(job));
  }
}

// --- UI PAGE ---
class RecruiterJobListPage extends StatelessWidget {
  final RecruiterJobListController controller = Get.put(RecruiterJobListController());

  RecruiterJobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7),
      body: Stack(
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFFA01355),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                        "Halo, ${controller.userName.value} 👋",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFA01355)),
                      hintText: "Cari Postingan Lowongan",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(() => Row(
                    children: [
                      _buildFilterTab("Aktif", controller.getCountForStatus("Aktif")),
                      _buildFilterTab("Dalam Review", controller.getCountForStatus("Dalam Review")),
                      _buildFilterTab("NonAktif", controller.getCountForStatus("NonAktif")),
                      _buildFilterTab("Draft", "0"),
                    ],
                  )),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Obx(() {
                    final jobs = controller.filteredJobs;

                    if (jobs.isEmpty) {
                      String message = "Belum ada lowongan";
                      if (controller.searchQuery.isNotEmpty) {
                        message = "Pencarian tidak ditemukan";
                      } else if (controller.selectedStatus.value == "Draft") {
                        message = "Belum ada draft tersimpan";
                      } else if (controller.selectedStatus.value == "Dalam Review") {
                        message = "Tidak ada lowongan sedang direview";
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              message,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => controller.refreshData(),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        itemCount: jobs.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return _buildJobCard(
                            job: job,
                            onTap: () => controller.toDetail(job.id),
                            // 3. Hubungkan aksi Boost ke Controller
                            onBoost: () => controller.toBoostPage(job),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: controller.newJob,
        backgroundColor: const Color(0xFFE57373),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildFilterTab(String label, String count) {
    final isSelected = controller.selectedStatus.value == label;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.selectedStatus.value = label;
          },
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE57373) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? null : Border.all(color: const Color(0xFFE57373).withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFE57373),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (count != "0") ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFFE57373).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFE57373) : const Color(0xFFE57373),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 4. Tambahkan parameter onBoost di sini
  Widget _buildJobCard({required JobVacancy job, required VoidCallback onTap, required VoidCallback onBoost}) {
    String dateString = DateFormat("dd MMM yyyy").format(job.createdAt);
    final now = DateTime.now();

    String statusText = "Aktif";
    Color statusColor = const Color(0xFFB9F6CA);
    Color textColor = const Color(0xFF2E7D32);

    if (job.startDate.isAfter(now)) {
      statusText = "Review";
      statusColor = Colors.orange[100]!;
      textColor = Colors.orange[800]!;
    } else if (job.endDate != null && job.endDate!.isBefore(now)) {
      statusText = "NonAktif";
      statusColor = Colors.grey[300]!;
      textColor = Colors.grey[700]!;
    }

    // Cek Metadata Boost dari deskripsi
    bool isBoosted = job.description.contains("- Status Boost: Aktif");

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge Boost & Status
                  Row(
                    children: [
                      if (isBoosted)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE57373),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Text("Diboost", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              SizedBox(width: 2),
                              Icon(Icons.flash_on, size: 12, color: Colors.white),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "${job.location} | Full Time",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              Text(
                "Dibuat : $dateString",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("0", "Pelamar"),
                  _buildStatItem("0", "Seleksi"),
                ],
              ),
              const SizedBox(height: 16),

              // 5. Hubungkan tombol ke fungsi onBoost
              SizedBox(
                width: double.infinity,
                child: isBoosted
                    ? null // Jika sudah diboost, tombol hilang
                    : OutlinedButton.icon(
                  onPressed: onBoost, // PANGGIL CALLBACK DISINI
                  icon: const Icon(Icons.flash_on, size: 18),
                  label: const Text("Boost Lowongan"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFA01355),
                    side: const BorderSide(color: Color(0xFFA01355)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(label, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ],
    );
  }
}