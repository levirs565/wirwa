import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/landing_screen.dart';
import 'package:wirwa/screen/recruiter/edit_company.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecruiterProfileController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();

  final Rxn<UserRecruiter> profile = Rxn<UserRecruiter>();

  final Rx<String?> userEmail = Rxn();
  final Rx<File?> selectedImage = Rxn(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onReady() {
    super.onReady();
    loadProfile();
  }

  void loadProfile() {
    final userId = authRepository.getUserId();
    if (userId != null) {
      userRepository.getRecruiterProfile(userId).then((value) {
        profile.value = value;
      });
      userEmail.value = authRepository.getUserEmail();
    }
  }

  Future<void> logout() async {
    await authRepository.signOut();
    Get.offAll(() => const LandingScreen());
  }

  Future<void> pickImage() async {
    try {
      // Show dialog to choose camera or gallery
      final source = await Get.bottomSheet<ImageSource>(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFFA01355)),
                title: Text("Kamera"),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFFA01355)),
                title: Text("Galeri"),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      );

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (image != null) {
          selectedImage.value = File(image.path);

          // Update profile with new image path
          if (profile.value != null) {
            final pictureUrl = await userRepository.uploadProfile(
              authRepository.getUserId()!,
              selectedImage.value!,
            );

            final updatedProfile = UserRecruiter(
              id: profile.value!.id,
              pictureUrl: pictureUrl,
              type: profile.value!.type,
              phoneNumber: profile.value!.phoneNumber,
              name: profile.value!.name,
            );

            await userRepository.setRecruiterProfile(updatedProfile);
            profile.value = updatedProfile;

            Get.snackbar(
              "Berhasil",
              "Foto profil berhasil diperbarui",
              backgroundColor: Color(0xFFA01355),
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil gambar: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class RecruiterProfilePage extends StatelessWidget {
  final RecruiterProfileController controller = Get.put(
    RecruiterProfileController(),
  );

  RecruiterProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7),
      body: Column(
        children: [
          // --- HEADER SECTION ---
          _buildHeader(),

          // --- BODY SECTION ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pengaturan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
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
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          iconColor: const Color(0xFFA01355),
                          title: "Informasi Perusahaan",
                          onTap: () {
                            // NAVIGASI KE HALAMAN EDIT PERUSAHAAN
                            Get.to(() => RecruiterEditCompanyPage());
                          },
                        ),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        _buildMenuItem(
                          icon: Icons.logout,
                          iconColor: const Color(0xFFE57373),
                          title: "Keluar Aplikasi",
                          onTap: () => _showLogoutDialog(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: const BoxDecoration(
        color: Color(0xFFA01355),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Obx(() {
        final user = controller.profile.value;
        final String displayName = user?.name ?? "Memuat...";

        return Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: user?.pictureUrl != null
                      ? NetworkImage(user!.pictureUrl!)
                      : null,
                  child: user?.pictureUrl == null
                      ? Icon(Icons.person, size: 50, color: Color(0xFFA01355))
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Color(0xFFA01355),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              displayName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  user?.phoneNumber ?? '-',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 12),
                Container(width: 1, height: 12, color: Colors.white70),
                const SizedBox(width: 12),
                const Icon(Icons.email, color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  controller.userEmail.value ?? '-',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: iconColor),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Konfirmasi Keluar",
      middleText: "Apakah Anda yakin ingin keluar dari aplikasi?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFA01355),
      cancelTextColor: Colors.black87,
      onConfirm: () {
        controller.logout();
      },
    );
  }
}
