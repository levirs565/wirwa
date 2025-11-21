import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class RecruiterNewJobController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final JobVacancyRepository vacancyRepository = Get.find();

  // --- Reactive Variables untuk Form ---
  final RxString title = "".obs;
  final RxString description = "".obs;

  // Dropdown Variables
  final RxString jobType = "".obs;
  final RxString workPolicy = "".obs;
  final RxString salary = "".obs;
  final RxString minAge = "".obs;
  final RxString skill = "".obs;
  final RxString minEducation = "".obs;

  // --- Validation Logic ---
  bool get canSubmit =>
      title.value.isNotEmpty &&
          description.value.isNotEmpty &&
          jobType.value.isNotEmpty &&
          workPolicy.value.isNotEmpty &&
          salary.value.isNotEmpty &&
          minAge.value.isNotEmpty &&
          skill.value.isNotEmpty &&
          minEducation.value.isNotEmpty;

  // --- Data Dummy ---
  final List<String> jobTypeList = ["Penuh Waktu", "Paruh Waktu", "Kontrak", "Magang"];
  final List<String> workPolicyList = ["Onsite", "Remote", "Hybrid"];
  final List<String> salaryList = ["< 2 Juta", "2 - 4 Juta", "4 - 7 Juta", "7 - 10 Juta", "> 10 Juta"];
  final List<String> educationList = ["SMA/SMK", "Diploma (D3)", "Sarjana (S1)", "Magister (S2)"];
  final List<String> skillList = ["Komunikasi", "Desain Grafis", "Pemrograman", "Marketing", "Administrasi"];

  @override
  void onReady() {
    super.onReady();
    resetForm();
  }

  void resetForm() {
    title.value = "";
    description.value = "";
    jobType.value = "";
    workPolicy.value = "";
    salary.value = "";
    minAge.value = "";
    skill.value = "";
    minEducation.value = "";
  }

  // Fungsi Submit
  Future<void> onSubmit() async {
    if (!canSubmit) return;

    // Kita simpan data detail ke dalam deskripsi agar bisa diambil nanti
    // Format: " - Label: Value" (Penting untuk parsing di Job List)
    String finalDescription = """
${description.value}

--- Metadata ---
- Tipe: ${jobType.value}
- Kebijakan: ${workPolicy.value}
- Gaji: ${salary.value}
- Pendidikan: ${minEducation.value}
- Umur Min: ${minAge.value}
- Skill: ${skill.value}
    """;

    try {
      DateTime inReviewDate = DateTime(2025, 12, 1);

      await vacancyRepository.add(
        JobVacancy(
          id: "",
          createdAt: DateTime.now(),
          title: title.value,
          location: workPolicy.value,
          description: finalDescription,
          startDate: inReviewDate, // <--- INI KUNCINYA
          endDate: null,
          recruiterId: authRepository.getUserId()!,
        ),
      );
      Get.back();
      Get.snackbar("Sukses", "Lowongan dikirim untuk direview", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal membuat lowongan: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

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
    );
  }
}

class RecruiterNewJobPage extends StatelessWidget {
  final controller = Get.put(RecruiterNewJobController());

  RecruiterNewJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA01355),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Buat Lowongan Baru",
                        style: TextStyle(
                          color: Color(0xFFA01355),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Detail Pekerjaan"),
                    _buildLabel("Nama Pekerjaan", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan nama pekerjaan (cth: Copywriter)",
                      onChanged: (v) => controller.title.value = v,
                    ),
                    _buildLabel("Deskripsi Pekerjaan", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan detail tanggung jawab...",
                      isMultiLine: true,
                      onChanged: (v) => controller.description.value = v,
                    ),
                    _buildLabel("Tipe Pekerjaan", isRequired: true),
                    _buildDropdownInput(
                      controller.jobType,
                      "Pilih tipe pekerjaan",
                          () => controller.showSelectionSheet("Tipe Pekerjaan", controller.jobTypeList, controller.jobType),
                    ),
                    _buildLabel("Kebijakan Kerja", isRequired: true),
                    _buildDropdownInput(
                      controller.workPolicy,
                      "Pilih kebijakan kerja",
                          () => controller.showSelectionSheet("Kebijakan Kerja", controller.workPolicyList, controller.workPolicy),
                    ),
                    _buildLabel("Gaji", isRequired: true),
                    _buildDropdownInput(
                      controller.salary,
                      "Pilih range gaji",
                          () => controller.showSelectionSheet("Gaji", controller.salaryList, controller.salary),
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle("Persyaratan"),

                    _buildLabel("Umur", isRequired: true),
                    _buildTextInput(
                      hint: "Masukan batas umur (cth: Min 20 Thn)",
                      onChanged: (v) => controller.minAge.value = v,
                    ),
                    _buildLabel("Skill", isRequired: true),
                    _buildDropdownInput(
                      controller.skill,
                      "Pilih skill utama",
                          () => controller.showSelectionSheet("Skill", controller.skillList, controller.skill),
                    ),
                    _buildLabel("Pendidikan Minimum", isRequired: true),
                    _buildDropdownInput(
                      controller.minEducation,
                      "Pilih pendidikan",
                          () => controller.showSelectionSheet("Pendidikan", controller.educationList, controller.minEducation),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Submit
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: Obx(() => ElevatedButton(
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
                  "Simpan & Ajukan Review",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'PlusJakartaSans'),
          children: [
            if (isRequired) const TextSpan(text: " *", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput({required String hint, required Function(String) onChanged, bool isMultiLine = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: const Color(0xFFFCE4EC), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        onChanged: onChanged,
        maxLines: isMultiLine ? 4 : 1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdownInput(RxString valueStore, String hint, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: const Color(0xFFFCE4EC), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
              valueStore.value.isEmpty ? hint : valueStore.value,
              style: TextStyle(color: valueStore.value.isEmpty ? Colors.grey[600] : Colors.black87, fontSize: 14),
            )),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}