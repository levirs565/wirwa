import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Pastikan import model dan repo kamu tetap ada
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/job.dart';

// --- Controller Tetap Sama (Sedikit penyesuaian jika perlu filter) ---
class JobSeekerJobListController extends GetxController {
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final AuthRepository authRepository = Get.find();
  final RxList<JobVacancy> jobs = <JobVacancy>[].obs;

  // Data user yang sedang login
  final Rxn<UserJobSeeker> currentUser = Rxn<UserJobSeeker>();

  // Map untuk menyimpan data recruiter berdasarkan ID
  final RxMap<String, UserRecruiter> recruiters = <String, UserRecruiter>{}.obs;

  // Tambahan untuk handle filter kategori (Contoh UI saja)
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
    // Disini nanti logika filter list jobs berdasarkan kategori
  }
}

// --- UI Page Utama ---
class JobSeekerJobListPage extends StatelessWidget {
  final JobSeekerJobListController controller = Get.put(
    JobSeekerJobListController(),
  );

  // Definisi Warna sesuai gambar
  final Color kBackgroundColor = const Color(0xFFFFF5F7); // Pink muda sekali
  final Color kPrimaryColor = const Color(0xFFFF8E88); // Pink tombol/aksen
  final Color kTextColor = const Color(0xFF1F1F1F);
  final Color kSubtitleColor = const Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // Menambahkan Bottom Nav Bar Dummy agar mirip gambar
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: kPrimaryColor,
      //   unselectedItemColor: Colors.grey,
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
      //     BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Pelatihan'),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
      //   ],
      // ),
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
                        physics:
                            const NeverScrollableScrollPhysics(), // Agar scroll ikut parent
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

  // 1. Bagian Header (Teks, Ilustrasi, Search Bar)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas dengan greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final userName = controller.currentUser.value?.name ?? "User";
                return Row(
                  children: [
                    Icon(Icons.waving_hand, color: Color(0xFFFFB800), size: 24),
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
          const SizedBox(height: 10),

          // Row untuk Teks Besar dan Gambar Ilustrasi
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  "Ayo, Cari Pekerjaan\nSesuai dengan\nDirimu!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor.withOpacity(0.8),
                    height: 1.2,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                // Ganti ini dengan Image.asset('assets/illustration.png') jika punya gambarnya
                child: Icon(
                  Icons.person_search_rounded,
                  size: 80,
                  color: Colors.brown[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Cari Pekerjaan",
                prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Bagian Filter Kategori (Horizontal Scroll)
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
                  "Remote", // Ganti dengan job.location
                  style: TextStyle(color: kSubtitleColor, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  "Rp 2 jt - Rp 4 jt /bulan", // Ganti dengan job.salaryRange
                  style: TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
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
