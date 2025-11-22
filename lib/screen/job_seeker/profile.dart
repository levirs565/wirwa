import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class JobSeekerProfileController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final Rx<UserJobSeeker?> profile = Rxn();
  final Rx<String?> userEmail = Rxn();
  final Rx<File?> selectedImage = Rxn(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onReady() {
    super.onReady();
    userRepository.getJobSeekerProfile(authRepository.getUserId()!).then((
      value,
    ) {
      profile.value = value;
    });
    userEmail.value = authRepository.getUserEmail();
  }

  Future<void> logout() async {
    await authRepository.signOut();
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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
            final updatedProfile = UserJobSeeker(
              id: profile.value!.id,
              pictureUrl: image.path,
              birthDate: profile.value!.birthDate,
              domisili: profile.value!.domisili,
              name: profile.value!.name,
              phoneNumber: profile.value!.phoneNumber,
            );

            await userRepository.setJobSeekerProfile(updatedProfile);
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

class JobSeekerProfilePage extends StatelessWidget {
  final JobSeekerProfileController controller = Get.put(
    JobSeekerProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFA01355);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   title: Text(
      //     "Profil Saya",
      //     style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Obx(() {
        final profileData = controller.profile.value;

        if (profileData == null) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Avatar
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(
                  top: 80,
                  bottom: 30,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    // Avatar with edit button
                    Stack(
                      children: [
                        Obx(
                          () => CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                controller.selectedImage.value != null
                                ? FileImage(controller.selectedImage.value!)
                                : (profileData.pictureUrl.isNotEmpty &&
                                          File(
                                            profileData.pictureUrl,
                                          ).existsSync()
                                      ? FileImage(File(profileData.pictureUrl))
                                      : null),
                            child:
                                controller.selectedImage.value == null &&
                                    (profileData.pictureUrl.isEmpty ||
                                        !File(
                                          profileData.pictureUrl,
                                        ).existsSync())
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: primaryColor,
                                  )
                                : null,
                          ),
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
                                color: primaryColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Name
                    Text(
                      profileData.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // WhatsApp Number & Email
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_android,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            profileData.phoneNumber,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "|",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.email, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              controller.userEmail.value ?? "-",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Information Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Informasi Pribadi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    _buildInfoRow(
                      icon: Icons.cake,
                      label: "Tanggal Lahir",
                      value: controller.formatDate(profileData.birthDate),
                      color: primaryColor,
                    ),
                    Divider(height: 1, indent: 56),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      label: "Domisili",
                      value: profileData.domisili,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Logout Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.logout,
                  icon: Icon(Icons.logout, color: Colors.red[700]),
                  label: Text(
                    "Keluar dari Aplikasi",
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.red[700]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
