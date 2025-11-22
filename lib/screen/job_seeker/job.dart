import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

// --- Controller Tetap Sama ---
class JobSeekerJobController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();

  String id = "";
  Rx<JobVacancy?> job = Rxn();
  Rx<UserRecruiter?> recruiter = Rxn();
  Rx<JobApplication?> application = Rxn();

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
    if (job == null) return;
    final recruiter = await userRepository.getRecruiterProfile(job.recruiterId);
    if (recruiter == null) return;
    final application = await jobApplicationRepository.get(
      id,
      authRepository.getUserId()!,
    );

    this.application.value = application;
    this.recruiter.value = recruiter;
    this.job.value = job;
  }

  Future<void> apply() async {
    await jobApplicationRepository.add(
      JobApplication(
        id: "",
        createdAt: DateTime.now(),
        status: JobApplicationStatus.PENDING,
        jobVacancyId: id,
        jobSeekerId: authRepository.getUserId()!,
      ),
    );
    await refresh();
    Get.snackbar("Berhasil", "Lamaran berhasil dikirim!",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}

// --- UI Page Detail Pekerjaan ---
class JobSeekerJobPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {JobSeekerJobController.ARGUMENT_ID: id};
  }

  final JobSeekerJobController controller = Get.put(JobSeekerJobController());

  // Definisi Warna
  final Color kPrimaryColor = const Color(0xFFFF5A5F); // Warna merah utama
  final Color kTextColor = const Color(0xFF1F1F1F);
  final Color kSubtitleColor = const Color(0xFF8A8A8A);
  final Color kBackgroundColor = const Color(0xFFFFF5F7); // Pink muda untuk background bawah

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // Tombol Lamar Melayang di Bawah
      bottomNavigationBar: _buildBottomActionButton(),
      body: Obx(
        () => controller.job.value == null
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final job = controller.job.value!;
    final recruiter = controller.recruiter.value;

    return Column(
      children: [
        // 1. Header Merah (App Bar + Info Utama)
        Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // App Bar Custom
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const Text("Detail Pekerjaan", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () {
                      // Implementasi Share
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Nama PT (Recruiter)
              Text(
                recruiter?.name ?? "Nama Perusahaan Tidak Tersedia",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Judul Pekerjaan
              Text(
                job.title,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Informasi Gaji, Lokasi, Tipe (Dalam Kartu Putih)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(Icons.monetization_on_outlined, "Gaji", "Rp 2jt - 4jt"), // Ganti dengan data dari model
                    _buildDivider(),
                    _buildInfoItem(Icons.location_on_outlined, "Lokasi", job.location),
                    _buildDivider(),
                    _buildInfoItem(Icons.work_outline, "Tipe", "Penuh Waktu"), // Ganti dengan data dari model
                  ],
                ),
              ),
            ],
          ),
        ),

        // 2. Konten Tab & Deskripsi (Scrollable)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab Navigasi (Dummy UI)
                Row(
                  children: [
                    _buildTabButton("Deskripsi", isActive: true),
                    const SizedBox(width: 20),
                    _buildTabButton("Perusahaan", isActive: false),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Judul Bagian
                const Text(
                  "Deskripsi Pekerjaan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Isi Deskripsi Utama
                Text(
                  job.description,
                  style: TextStyle(color: kSubtitleColor, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Kualifikasi (Contoh Poin-Poin)
                const Text("Kualifikasi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildBulletPoint("Pendidikan minimal S1 semua jurusan"),
                _buildBulletPoint("Pengalaman minimal 1 tahun di bidang terkait"),
                _buildBulletPoint("Mampu bekerja dalam tim maupun individu"),
                const SizedBox(height: 20),

                // Tanggung Jawab (Contoh Poin-Poin)
                const Text("Tanggung Jawab", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildBulletPoint("Mengelola dan mengembangkan strategi pemasaran"),
                _buildBulletPoint("Melakukan riset pasar dan analisis kompetitor"),
                const SizedBox(height: 80), // Spasi agar konten tidak tertutup tombol di bawah
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget Pembantu Kecil ---

  // Widget untuk item info di header (Gaji, Lokasi, Tipe)
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: kPrimaryColor),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12, color: kSubtitleColor)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
      ],
    );
  }

  // Garis pemisah vertikal kecil
  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  // Tombol Tab (Deskripsi / Perusahaan)
  Widget _buildTabButton(String text, {required bool isActive}) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isActive ? kPrimaryColor : kSubtitleColor,
          ),
        ),
        const SizedBox(height: 5),
        if (isActive)
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          )
      ],
    );
  }

  // Poin untuk list kualifikasi/tanggung jawab
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(color: kPrimaryColor, fontSize: 16)),
          Expanded(
            child: Text(text, style: TextStyle(color: kSubtitleColor, height: 1.5)),
          ),
        ],
      ),
    );
  }

  // Tombol Aksi di Bagian Bawah (Lamar)
  Widget _buildBottomActionButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: Obx(() {
        final isApplied = controller.application.value != null;
        return ElevatedButton(
          onPressed: isApplied ? null : controller.apply,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            disabledBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: Text(
            isApplied
                ? "Sudah Dilamar (${controller.application.value!.status})"
                : "Lamar Sekarang",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    );
  }
}