import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/job.dart';

class JobSeekerJobListController extends GetxController {
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final AuthRepository authRepository = Get.find();
  final RxList<JobVacancy> jobs = <JobVacancy>[].obs;

  final Rxn<UserJobSeeker> currentUser = Rxn<UserJobSeeker>();

  final RxMap<String, UserRecruiter> recruiters = <String, UserRecruiter>{}.obs;

  final List<String> categories = [
    "Semua",
    "Penuh Waktu",
    "Paruh Waktu",
    "Freelance",
  ];
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    _loadCurrentUser();
    refresh();
  }

  Future<void> _loadCurrentUser() async {
    final userId = authRepository.getUserId();
    if (userId != null) {
      final user = await userRepository.getJobSeekerProfile(userId);
      currentUser.value = user;
    }
  }

  void refresh() {
    jobVacancyRepository.getAll().then((value) {
      jobs.clear();
      jobs.insertAll(0, value);

      // Fetch recruiter data untuk setiap job
      for (var job in value) {
        _fetchRecruiter(job.recruiterId);
      }
    });
  }

  Future<void> _fetchRecruiter(String recruiterId) async {
    if (!recruiters.containsKey(recruiterId)) {
      try {
        final recruiter = await userRepository.getRecruiterProfile(recruiterId);
        if (recruiter != null) {
          recruiters[recruiterId] = recruiter;
        }
      } catch (e) {
        print("Error fetching recruiter: $e");
      }
    }
  }

  void toDetail(String id) {
    Get.to(
      () => JobSeekerJobPage(),
      arguments: JobSeekerJobPage.createArguments(id),
    );
  }

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }
}

// --- UI Page Utama ---
class JobSeekerJobListPage extends StatelessWidget {
  final JobSeekerJobListController controller = Get.put(
    JobSeekerJobListController(),
  );

  // Definisi Warna sesuai gambar
  final Color kBackgroundColor = const Color(0xFFFFF5F7);
  final Color kPrimaryColor = const Color(0xFFFF8E88);
  final Color kTextColor = const Color(0xFF1F1F1F);
  final Color kSubtitleColor = const Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildCategoryFilter(),
              const SizedBox(height: 20),
              // List Job
              Obx(
                () => controller.jobs.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Belum ada lowongan"),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.jobs.length,
                        itemBuilder: (context, index) =>
                            _buildJobCard(context, controller.jobs[index]),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final userName = controller.currentUser.value?.name ?? "User";
                return Row(
                  children: [
                    const Icon(
                      Icons.waving_hand,
                      color: Color(0xFFFFB800),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Halo, $userName!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                      ),
                    ),
                  ],
                );
              }),
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDCAC5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: kPrimaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
              decoration: BoxDecoration(
                color: const Color(0xFFA01355),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50, top: 0),
                      child: Text(
                        "ayo, cari pekerjaan\nsesuai dengan\ndirimu!",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Image.asset(
                      'assets/images/gambar4.png',
                      height: 130,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person_search_rounded,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 10,
              left: 35,
              right: 35,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Cari Pekerjaan",
                    hintStyle: TextStyle(
                      color: Color(0xFF8A8A8A),
                      fontSize: 14,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15, right: 10),
                      child: Icon(
                        Icons.search,
                        color: Color(0xFFFF8E88),
                        size: 24,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedCategoryIndex.value == index;
            return GestureDetector(
              onTap: () => controller.changeCategory(index),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.5),
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // 3. Bagian Kartu Pekerjaan (Job Card)
  Widget _buildJobCard(BuildContext context, JobVacancy job) {
    return GestureDetector(
      onTap: () => controller.toDetail(job.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
            // Header Card: Logo & Judul
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Perusahaan
                Obx(() {
                  final recruiter = controller.recruiters[job.recruiterId];
                  // Untuk sekarang pakai initial letter dari nama perusahaan
                  final initial = recruiter != null && recruiter.name.isNotEmpty
                      ? recruiter.name[0].toUpperCase()
                      : 'P';

                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      // TODO: Tambahkan field pictureUrl di UserRecruiter model
                      // Jika ada pictureUrl, gunakan:
                      // image: recruiter?.pictureUrl != null
                      //     ? DecorationImage(
                      //         image: NetworkImage(recruiter!.pictureUrl),
                      //         fit: BoxFit.cover,
                      //       )
                      //     : null,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 12),
                // Judul & Nama PT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title, // Dari Model
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Nama Perusahaan dari UserRecruiter
                      Obx(() {
                        final recruiter =
                            controller.recruiters[job.recruiterId];
                        return Text(
                          recruiter?.name ?? "Loading...",
                          style: TextStyle(color: kSubtitleColor, fontSize: 12),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tags (Penuh Waktu, F&B, dll)
            Row(
              children: [
                _buildTag("Penuh Waktu"),
                const SizedBox(width: 8),
                _buildTag("F&B"),
                const SizedBox(width: 8),
                _buildTag("Entry Level"),
              ],
            ),
            const SizedBox(height: 16),

            // Footer Card: Lokasi & Gaji
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: kPrimaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  job.workPolicy ?? job.location,
                  style: TextStyle(color: kSubtitleColor, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  job.salary ?? "-",
                  style: TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol Daftar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.toDetail(job.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA01355), // Warna maroon
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Daftar",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget kecil untuk Tag
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: kPrimaryColor.withOpacity(0.8)),
      ),
    );
  }
}
