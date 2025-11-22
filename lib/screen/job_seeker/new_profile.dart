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
  final Rx<String> pictureUrl = "".obs;
  final Rx<File?> selectedImage = Rxn(null);
  final ImagePicker _picker = ImagePicker();

  bool get canSubmit =>
      nameError.value == null &&
      domisiliError.value == null &&
      phoneNumberError.value == null &&
      birthDateError.value == null &&
      birthDate.value != null;

  @override
  void onReady() {
    super.onReady();
    setName("");
    setDomisili("");
    setPhoneNumber("");
  }

  void setName(String value) {
    name.value = value;

    if (name.trim().length < 5) {
      nameError.value = "Name must be at least 5 characters";
    } else {
      nameError.value = null;
    }
  }

  void setDomisili(String value) {
    domisili.value = value;

    if (domisili.trim().length < 5) {
      domisiliError.value = "Domisili must be at least 5 characters";
    } else {
      domisiliError.value = null;
    }
  }

  void setPhoneNumber(String value) {
    phoneNumber.value = value;

    if (phoneNumber.trim().length < 5) {
      phoneNumberError.value = "Phone number must be at least 5 characters";
    } else {
      phoneNumberError.value = null;
    }
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
          // For now, just use the local path
          // In production, you should upload to Supabase Storage
          pictureUrl.value = image.path;
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
    await userRepository.setJobSeekerProfile(
      UserJobSeeker(
        id: authRepository.getUserId()!,
        birthDate: birthDate.value ?? DateTime.now(),
        domisili: domisili.value,
        name: name.value,
        phoneNumber: phoneNumber.value,
        pictureUrl: pictureUrl.value,
      ),
    );
    Get.off(JobSeekerPage());
  }
}

class JobSeekerNewProfilePage extends StatelessWidget {
  final controller = Get.put(JobSeekerNewProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Akun",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE91E63),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Masuk Sebagai Pelamar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Profile Picture Upload
                    Center(
                      child: Obx(
                        () => Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  controller.selectedImage.value != null
                                  ? FileImage(controller.selectedImage.value!)
                                  : null,
                              child: controller.selectedImage.value == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey[600],
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextButton.icon(
                              onPressed: controller.pickImage,
                              icon: Icon(
                                Icons.upload,
                                color: Color(0xFFE91E63),
                              ),
                              label: Text(
                                controller.selectedImage.value == null
                                    ? "Upload Foto Profil"
                                    : "Ganti Foto",
                                style: TextStyle(color: Color(0xFFE91E63)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Obx(
                      () => TextField(
                        onChanged: controller.setName,
                        decoration: InputDecoration(
                          labelText: "Nama Lengkap",
                          border: OutlineInputBorder(),
                          errorText: controller.nameError.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Birth Date Picker
                    Obx(
                      () => InkWell(
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
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Tanggal Lahir",
                            border: OutlineInputBorder(),
                            errorText: controller.birthDateError.value,
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            controller.birthDate.value != null
                                ? "${controller.birthDate.value!.day}/${controller.birthDate.value!.month}/${controller.birthDate.value!.year}"
                                : "Pilih tanggal lahir",
                            style: TextStyle(
                              color: controller.birthDate.value != null
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(
                      () => TextField(
                        onChanged: controller.setDomisili,
                        decoration: InputDecoration(
                          labelText: "Domisili",
                          border: OutlineInputBorder(),
                          errorText: controller.domisiliError.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            onChanged: controller.setPhoneNumber,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Nomor WhatsApp",
                              border: OutlineInputBorder(),
                              errorText: controller.phoneNumberError.value,
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Color(0xFF25D366), // WhatsApp green
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
                  onPressed: controller.canSubmit ? controller.onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
