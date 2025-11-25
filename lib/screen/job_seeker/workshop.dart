import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

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
      final workshopData = await workshopRepository.getById(id);
      workshop.value = workshopData;

      if (workshopData != null) {
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
              // 1. Gambar Cover dari Server
              Container(
                width: double.infinity,
                height: 220,
                child: data.imageUrl != null && data.imageUrl!.isNotEmpty
                    ? Image.network(
                        data.imageUrl!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade300,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print("Error loading workshop image: $error");
                          return Container(
                            color: Colors.grey.shade300,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: Center(
                          child: Icon(
                            Icons.school,
                            size: 50,
                            color: Colors.grey.shade500,
                          ),
                        ),
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
                        // Logo Recruiter dari Server
                        Obx(() {
                          final rec = controller.recruiter.value;
                          if (rec?.pictureUrl != null &&
                              rec!.pictureUrl!.isNotEmpty) {
                            return Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blueAccent),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  rec.pictureUrl!,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.white,
                                      child: Icon(
                                        Icons.business,
                                        size: 16,
                                        color: Colors.blueAccent,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                          return Container(
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
                          );
                        }),
                        const SizedBox(width: 8),

                        // Nama Perusahaan (Recruiter Name)
                        Obx(() {
                          final rec = controller.recruiter.value;
                          return Text(
                            rec?.name ?? "Memuat Penyelenggara...",
                            style: TextStyle(
                              color: kSubtitleColor,
                              fontSize: 14,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 4. Tanggal Dibuat
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Dibuat: ${_formatDate(data.createdAt)}",
                          style: TextStyle(fontSize: 13, color: kSubtitleColor),
                        ),
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

  // Format tanggal
  String _formatDate(DateTime date) {
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
