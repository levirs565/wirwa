import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/main.dart';

class JobSeekerNewProfileController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final Rx<String> name = "".obs;
  final Rx<String?> nameError = Rxn(null);
  final Rx<String> domisili = "".obs;
  final Rx<String?> domisiliError = Rxn(null);
  final Rx<String> phoneNumber = "".obs;
  final Rx<String?> phoneNumberError = Rxn(null);
  final Rx<DateTime?> birthDate = Rxn(null);
  final Rx<String?> birthDateError = Rxn(null);
  final Rx<File?> selectedImage = Rxn(null);
  final ImagePicker _picker = ImagePicker();

  bool get canSubmit =>
      name.value.trim().isNotEmpty &&
      domisili.value.trim().isNotEmpty &&
      phoneNumber.value.trim().isNotEmpty &&
      birthDate.value != null &&
      nameError.value == null &&
      domisiliError.value == null &&
      phoneNumberError.value == null &&
      birthDateError.value == null;

  @override
  void onReady() {
    super.onReady();
    setName("");
    setDomisili("");
    setPhoneNumber("");
  }

  void setName(String value) {
    name.value = value;
    nameError.value = null;
  }

  void setDomisili(String value) {
    domisili.value = value;
    domisiliError.value = null;
  }

  void setPhoneNumber(String value) {
    phoneNumber.value = value;
    phoneNumberError.value = null;
  }

  void setBirthDate(DateTime? date) {
    birthDate.value = date;
    if (date == null) {
      birthDateError.value = "Birth date is required";
    } else {
      birthDateError.value = null;
    }
  }

  Future<void> pickImage() async {
    try {
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
                leading: Icon(Icons.camera_alt, color: Color(0xFFE91E63)),
                title: Text("Kamera"),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFFE91E63)),
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
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil gambar: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> onSubmit() async {
    final pictureUrl = selectedImage.value != null
        ? await userRepository.uploadProfile(
            authRepository.getUserId()!,
            selectedImage.value!,
          )
        : null;

    await userRepository.setJobSeekerProfile(
      UserJobSeeker(
        id: authRepository.getUserId()!,
        birthDate: birthDate.value ?? DateTime.now(),
        domisili: domisili.value,
        name: name.value,
        phoneNumber: phoneNumber.value,
        pictureUrl: pictureUrl ?? "",
      ),
      // FIX THIS, pictureUrl nullable
    );
    Get.off(JobSeekerPage());
  }
}

class JobSeekerNewProfilePage extends StatelessWidget {
  final controller = Get.put(JobSeekerNewProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      controller.authRepository.signOut();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE91E63),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Daftar Akun",
                        style: TextStyle(
                          color: Color(0xFFE91E63),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 36), // Balance untuk back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle
                      Center(
                        child: Text(
                          "Masuk Sebagai Pelamar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Profile Picture Upload
                      Center(
                        child: GestureDetector(
                          onTap: controller.pickImage,
                          child: Stack(
                            children: [
                              Obx(
                                () => Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0E0E0),
                                    shape: BoxShape.circle,
                                    image:
                                        controller.selectedImage.value != null
                                        ? DecorationImage(
                                            image: FileImage(
                                              controller.selectedImage.value!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: controller.selectedImage.value == null
                                      ? const Center(
                                          child: Text(
                                            "LOGO",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE91E63),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Nama Lengkap
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Lengkap",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: controller.setName,
                              decoration: InputDecoration(
                                hintText: "Masukkan nama lengkap",
                                filled: true,
                                fillColor: Color(0xFFFDC5DF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                errorText: controller.nameError.value,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Birth Date Picker
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tanggal Lahir",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Color(0xFFE91E63),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (date != null) {
                                  controller.setBirthDate(date);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFDC5DF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.birthDate.value != null
                                          ? "${controller.birthDate.value!.day}/${controller.birthDate.value!.month}/${controller.birthDate.value!.year}"
                                          : "Pilih tanggal lahir",
                                      style: TextStyle(
                                        color:
                                            controller.birthDate.value != null
                                            ? Colors.black87
                                            : Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[600],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.birthDateError.value != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 12,
                                ),
                                child: Text(
                                  controller.birthDateError.value!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Domisili
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Domisili",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: controller.setDomisili,
                              decoration: InputDecoration(
                                hintText: "Masukkan domisili",
                                filled: true,
                                fillColor: Color(0xFFFDC5DF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                errorText: controller.domisiliError.value,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nomor WhatsApp
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nomor WhatsApp",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: controller.setPhoneNumber,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Masukkan nomor WhatsApp",
                                filled: true,
                                fillColor: Color(0xFFFDC5DF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                errorText: controller.phoneNumberError.value,
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: Color(0xFF25D366), // WhatsApp green
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Color(0xFF25D366),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Pastikan WhatsApp aktif",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Tombol fixed di bawah
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.canSubmit
                        ? controller.onSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.canSubmit
                          ? Color(0xFFE91E63)
                          : Colors.grey[400],
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[400],
                      disabledForegroundColor: Colors.grey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      controller.canSubmit
                          ? "Daftar"
                          : "Lengkapi Data Terlebih Dahulu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
