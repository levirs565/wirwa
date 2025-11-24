import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecruiterNewProfileController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();

  // --- Form Variables ---
  // Kita set default type ke COMPANY karena UI ini khusus "Buat Perusahaan Baru"
  final Rx<UserRecruiterType> type = UserRecruiterType.COMPANY.obs;

  final RxString companyName = "".obs;
  final RxString phoneNumber = "".obs;
  final RxString industry = "".obs;
  final RxString companySize = "".obs;
  final RxString description = "".obs;
  final RxString location = "".obs;
  final RxString address = "".obs;

  final Rx<File?> selectedImage = Rxn(null);
  final ImagePicker _picker = ImagePicker();

  // --- Validation ---
  bool get canSubmit =>
      companyName.value.isNotEmpty &&
      phoneNumber.value.isNotEmpty &&
      industry.value.isNotEmpty &&
      companySize.value.isNotEmpty &&
      description.value.isNotEmpty &&
      location.value.isNotEmpty &&
      address.value.isNotEmpty;

  // --- Dummy Data untuk Dropdown ---
  final List<String> industryList = [
    "Teknologi",
    "Kesehatan",
    "Pendidikan",
    "Keuangan",
    "F & B",
    "Retail",
  ];
  final List<String> sizeList = [
    "1 - 10 Karyawan",
    "11 - 50 Karyawan",
    "51 - 200 Karyawan",
    "201 - 500 Karyawan",
    "500+ Karyawan",
  ];

  @override
  void onReady() {
    super.onReady();
    resetForm();
  }

  void resetForm() {
    companyName.value = "";
    phoneNumber.value = "";
    industry.value = "";
    companySize.value = "";
    description.value = "";
    location.value = "";
    address.value = "";
    selectedImage.value = null;
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

  // --- Logic Submit ---
  Future<void> onSubmit() async {
    if (!canSubmit) return;

    try {
      final profileUrl = selectedImage.value != null
          ? await userRepository.uploadProfile(
              authRepository.getUserId()!,
              selectedImage.value!,
            )
          : null;

      await userRepository.setRecruiterProfile(
        UserRecruiter(
          id: authRepository.getUserId()!,
          type: type.value,
          name: companyName.value,
          pictureUrl: profileUrl,
          phoneNumber: phoneNumber.value,
        ),
      );

      // Navigasi ke Halaman Utama Recruiter setelah simpan
      Get.offAll(() => RecruiterPage());
      Get.snackbar(
        "Sukses",
        "Profil Perusahaan Berhasil Dibuat",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menyimpan profil: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper BottomSheet
  void showSelectionSheet(
    String title,
    List<String> options,
    RxString targetVariable,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih $title",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...options.map(
              (option) => ListTile(
                title: Text(option),
                onTap: () {
                  targetVariable.value = option;
                  Get.back();
                },
                trailing: targetVariable.value == option
                    ? const Icon(Icons.check_circle, color: Color(0xFFA01355))
                    : null,
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class RecruiterNewProfilePage extends StatelessWidget {
  final controller = Get.put(RecruiterNewProfileController());

  RecruiterNewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER (Title & Back Button) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Logout atau Back ke login jika user membatalkan pembuatan profil
                      controller.authRepository.signOut();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA01355), // Merah Marun
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
                        "Buat Perusahaan Baru",
                        style: TextStyle(
                          color: Color(0xFFA01355),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer penyeimbang
                ],
              ),
            ),

            // --- SCROLLABLE FORM ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LOGO PLACEHOLDER
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
                                  image: controller.selectedImage.value != null
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
                    const SizedBox(height: 30),

                    // SECTION: Info Perusahaan
                    _buildSectionTitle("Info Perusahaan"),

                    _buildLabel("Nama Perusahaan", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan nama perusahaan",
                      onChanged: (v) => controller.companyName.value = v,
                    ),

                    _buildLabel("Nomor Telepon", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan nomor telepon perusahaan",
                      onChanged: (v) => controller.phoneNumber.value = v,
                      keyboardType: TextInputType.phone,
                    ),

                    _buildLabel("Industri", isRequired: true),
                    _buildDropdownInput(
                      controller.industry,
                      "Tambahkan Industri",
                      () => controller.showSelectionSheet(
                        "Industri",
                        controller.industryList,
                        controller.industry,
                      ),
                    ),

                    _buildLabel("Ukuran Perusahaan", isRequired: true),
                    _buildDropdownInput(
                      controller.companySize,
                      "Pilih ukuran perusahaan",
                      () => controller.showSelectionSheet(
                        "Ukuran Perusahaan",
                        controller.sizeList,
                        controller.companySize,
                      ),
                    ),

                    _buildLabel("Deskripsi Perusahaan", isRequired: true),
                    _buildTextInput(
                      hint: "Jelaskan tentang perusahaan Anda",
                      onChanged: (v) => controller.description.value = v,
                    ),

                    const SizedBox(height: 10),

                    // SECTION: Lokasi
                    _buildSectionTitle("Lokasi"),

                    _buildLabel("Lokasi", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan lokasi perusahaan",
                      onChanged: (v) => controller.location.value = v,
                    ),

                    _buildLabel("Alamat Kantor", isRequired: true),
                    _buildTextInput(
                      hint:
                          "Alamat lengkap (gedung & lantai, jalan, kelurahan, dst.)",
                      onChanged: (v) => controller.address.value = v,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // --- SUBMIT BUTTON ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.canSubmit ? controller.onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA01355),
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  // --- WIDGET HELPERS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'PlusJakartaSans',
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: " *",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required String hint,
    required Function(String) onChanged,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC), // Pink Muda
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ), // Style panah seperti di gambar
        ),
      ),
    );
  }

  Widget _buildDropdownInput(
    RxString valueStore,
    String hint,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE4EC), // Pink Muda
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                valueStore.value.isEmpty ? hint : valueStore.value,
                style: TextStyle(
                  color: valueStore.value.isEmpty
                      ? Colors.grey[600]
                      : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
