import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecruiterEditCompanyController extends GetxController {
  // --- Form Variables (Dummy Data) ---
  final RxString companyName = "PT Pisang Kemul".obs; // Pre-filled dummy
  final RxString industry = "F & B".obs;
  final RxString companySize = "11 - 50 Karyawan".obs;
  final RxString description = "Perusahaan yang bergerak di bidang kuliner pisang.".obs;
  final RxString location = "Jakarta Selatan".obs;
  final RxString address = "Jl. H. Nawi Raya No. 10".obs;

  // --- Dummy Data untuk Dropdown ---
  final List<String> industryList = ["Teknologi", "Kesehatan", "Pendidikan", "Keuangan", "F & B", "Retail"];
  final List<String> sizeList = ["1 - 10 Karyawan", "11 - 50 Karyawan", "51 - 200 Karyawan", "201 - 500 Karyawan", "500+ Karyawan"];

  // --- Logic Simpan ---
  void saveChanges() {
    // Disini nanti logika simpan ke API/Firebase
    Get.back();
    Get.snackbar(
        "Berhasil",
        "Data perusahaan berhasil diperbarui",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16)
    );
  }

  // Helper BottomSheet
  void showSelectionSheet(String title, List<String> options, RxString targetVariable) {
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
            Text("Pilih $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...options.map((option) => ListTile(
              title: Text(option),
              onTap: () {
                targetVariable.value = option;
                Get.back();
              },
              trailing: targetVariable.value == option
                  ? const Icon(Icons.check_circle, color: Color(0xFFA01355))
                  : null,
            )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class RecruiterEditCompanyPage extends StatelessWidget {
  final controller = Get.put(RecruiterEditCompanyController());

  RecruiterEditCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA01355), // Merah Marun
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Edit Data Perusahaan",
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

            // --- FORM CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // LOGO + EDIT ICON
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0E0E0), // Abu-abu placeholder (atau ganti gambar)
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                  "LOGO",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE91E63), // Pink cerah
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.edit, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // INFO PERUSAHAAN
                    _buildSectionTitle("Info Perusahaan"),

                    _buildLabel("Nama Perusahaan", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan nama perusahaan",
                      initialValue: controller.companyName.value,
                      onChanged: (v) => controller.companyName.value = v,
                    ),

                    _buildLabel("Industri", isRequired: true),
                    _buildDropdownInput(
                      controller.industry,
                      "Tambahkan industri",
                          () => controller.showSelectionSheet("Industri", controller.industryList, controller.industry),
                    ),

                    _buildLabel("Ukuran Perusahaan", isRequired: true),
                    _buildDropdownInput(
                      controller.companySize,
                      "Pilih ukuran perusahaan",
                          () => controller.showSelectionSheet("Ukuran Perusahaan", controller.sizeList, controller.companySize),
                    ),

                    _buildLabel("Deskripsi Perusahaan", isRequired: true),
                    _buildTextInput(
                      hint: "Jelaskan tentang perusahaan Anda",
                      initialValue: controller.description.value,
                      onChanged: (v) => controller.description.value = v,
                    ),

                    const SizedBox(height: 10),

                    // LOKASI
                    _buildSectionTitle("Lokasi"),

                    _buildLabel("Lokasi", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan lokasi perusahaan",
                      initialValue: controller.location.value,
                      onChanged: (v) => controller.location.value = v,
                    ),

                    _buildLabel("Alamat Kantor", isRequired: true),
                    _buildTextInput(
                      hint: "Alamat lengkap (gedung & lantai, jalan, kelurahan, dst.)",
                      initialValue: controller.address.value,
                      onChanged: (v) => controller.address.value = v,
                    ),

                    const SizedBox(height: 30),

                    // BUTTON SIMPAN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA01355),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS (Sama seperti di New Profile) ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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
              fontFamily: 'PlusJakartaSans'
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required String hint,
    String? initialValue,
    required Function(String) onChanged,
  }) {
    // Menggunakan controller text untuk initial value
    final textController = TextEditingController(text: initialValue);
    // Cursor ditaruh di akhir text jika ada initial value
    textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC), // Pink Muda
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: textController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: const Icon(Icons.chevron_right, color: Colors.grey),
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
            Obx(() => Text(
              valueStore.value.isEmpty ? hint : valueStore.value,
              style: TextStyle(
                color: valueStore.value.isEmpty ? Colors.grey[600] : Colors.black87,
                fontSize: 14,
              ),
            )),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}