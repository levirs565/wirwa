import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

// --- Controller ---
class JobSeekerWorkshopController extends GetxController {
  static const String ARGUMENT_ID = "id";

  final WorkshopRepository workshopRepository = Get.find();
  final UserRepository userRepository = Get.find();

  String id = "";
  final Rx<Workshop?> workshop = Rxn();
  final Rx<UserRecruiter?> recruiter = Rxn();
  final RxBool isLoading = true.obs;

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
    isLoading.value = true;
    try {
      // A. Ambil data Workshop dulu
      final workshopData = await workshopRepository.getById(id);
      workshop.value = workshopData;

      // B. Jika workshop ada, ambil data Recruiter berdasarkan recruiterId
      if (workshopData != null) {
        // Asumsi: di model Workshop ada field 'recruiterId'
        final recruiterData = await userRepository.getRecruiterProfile(
          workshopData.recruiterId,
        );
        recruiter.value = recruiterData;
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openUrl() async {
    if (workshop.value?.formUrl == null) return;

    var urlString = workshop.value!.formUrl;
    if (!urlString.startsWith("http")) {
      urlString = "https://$urlString";
    }

    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Gagal", "Tidak dapat membuka link pendaftaran");
    }
  }
}

// --- UI Page ---
class JobSeekerWorkshopPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(String id) {
    return {JobSeekerWorkshopController.ARGUMENT_ID: id};
  }

  final controller = Get.put(JobSeekerWorkshopController());

  final Color kPrimaryColor = const Color(0xFFE33E84);
  final Color kBackgroundColor = const Color(0xFFFFF5F7);
  final Color kTextColor = const Color(0xFF1F1F1F);
  final Color kSubtitleColor = const Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          "Pelatihan",
          style: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.workshop.value == null) {
          return const Center(child: Text("Data tidak ditemukan"));
        }

        final data = controller.workshop.value!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Gambar Cover
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  image: const DecorationImage(
                    // Ganti data.imageUrl dengan field gambar dari database kamu
                    // image: NetworkImage(data.imageUrl),
                    image: AssetImage(
                      'assets/placeholder_study.png',
                    ), // Placeholder sementara
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.white54),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Judul Pelatihan
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3. Penyelenggara (Logo + Nama)
                    Row(
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: const Icon(
                            Icons.business,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Nama Perusahaan (Recruiter Name)
                        Text(
                          // Jika data masih loading atau null, tampilkan placeholder
                          controller.recruiter.value?.name ??
                              "Memuat Penyelenggara...",
                          style: TextStyle(color: kSubtitleColor, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 4. Lokasi & Tanggal
                    Row(
                      children: [
                        _buildIconInfo(
                          Icons.location_on_outlined,
                          "Zoom Meeting",
                        ), // Ganti data.location
                        const SizedBox(width: 20),
                        _buildIconInfo(
                          Icons.calendar_today_outlined,
                          "20 Desember 2025",
                        ), // Ganti formattedDate
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 5. Tentang Pelatihan (Deskripsi)
                    const Text(
                      "Tentang Pelatihan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.description,
                      style: TextStyle(
                        color: kSubtitleColor,
                        height: 1.6,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Widget Helper: Icon Merah + Teks
  Widget _buildIconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFA53337), size: 20),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: kSubtitleColor, fontSize: 13)),
      ],
    );
  }

  // Widget Helper: Tombol Bawah
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.openUrl,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Daftar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
