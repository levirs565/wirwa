import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/recruiter/job_list.dart';

class RecruiterBoostController extends GetxController {
  static const String ARGUMENT_JOB = "job";

  final JobVacancyRepository jobVacancyRepository = Get.find();
  late JobVacancy job;

  // Variabel Dummy UI
  final RxInt selectedPaymentIndex = (-1).obs;
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    job = Get.arguments[ARGUMENT_JOB];
  }

  void selectPayment(int index) {
    selectedPaymentIndex.value = index;
  }

  // Simulasi Alur Pembayaran
  Future<void> processPayment() async {
    if (selectedPaymentIndex.value == -1) {
      Get.snackbar("Pilih Metode", "Silakan pilih metode pembayaran terlebih dahulu", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // 1. Tampilkan BottomSheet QRIS Dummy
    await Get.bottomSheet(
      _buildQRISSheet(),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );
  }

  // Widget BottomSheet QRIS & Loading
  Widget _buildQRISSheet() {
    // Simulasi timer otomatis sukses dalam 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isBottomSheetOpen ?? false) Get.back(); // Tutup QRIS
      _finishBoost(); // Selesaikan Boost
    });

    return Container(
      height: Get.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
              const Expanded(child: Center(child: Text("Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Selesaikan pembayaran dalam waktu", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          const Text("00 : 03", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFA01355))), // Timer palsu
          const SizedBox(height: 24),

          // QR Code Dummy (Placeholder)
          Container(
            width: 250,
            height: 250,
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.qr_code_2, size: 150)),
          ),

          const Spacer(),
          const Text("Total", style: TextStyle(color: Colors.grey)),
          const Text("Rp 100.000", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFA01355))),
          const SizedBox(height: 24),

          // Tombol Konfirmasi (Hanya visual, logic timer diatas yang jalan)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {}, // Disabled, tunggu timer
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Menunggu Pembayaran...", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finishBoost() async {
    // 2. Update Data Dummy (Inject Metadata ke Deskripsi)
    // Karena repository  belum ada fungsi update,  ini update local list controller saja
    // agar terlihat berubah.

    try {
      // Cari Controller List dan update datanya secara lokal
      final RecruiterJobListController listController = Get.find();
      final int index = listController.allJobs.indexWhere((element) => element.id == job.id);

      if (index != -1) {
        // duplikasi job dan tambahkan tanda di deskripsi
        //  Tambahkan "- Status Boost: Aktif" ke deskripsi
        final updatedJob = JobVacancy(
          id: job.id,
          createdAt: job.createdAt,
          title: job.title,
          location: job.location,
          description: "${job.description}\n\n- Status Boost: Aktif", // Inject Metadata
          startDate: job.startDate,
          endDate: job.endDate,
          recruiterId: job.recruiterId,
        );

        listController.allJobs[index] = updatedJob;
        listController.allJobs.refresh(); // Trigger UI update
      }

      Get.back(); // Kembali ke halaman list
      Get.snackbar("Berhasil", "Lowongan berhasil di-boost!", backgroundColor: Colors.green, colorText: Colors.white);

    } catch (e) {
      Get.back();
    }
  }
}

class RecruiterBoostPage extends StatelessWidget {
  static Map<String, dynamic> createArguments(JobVacancy job) {
    return {RecruiterBoostController.ARGUMENT_JOB: job};
  }

  final RecruiterBoostController controller = Get.put(RecruiterBoostController());

  RecruiterBoostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Boost Lowongan", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Card Preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/gambar1.png'),
                              radius: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.job.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const Text("PT Pisang Kemul", style: TextStyle(color: Colors.grey, fontSize: 12)), // Dummy PT
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                              child: const Text("Aktif", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: const [Icon(Icons.location_on_outlined, size: 16, color: Colors.grey), SizedBox(width: 4), Text("Remote", style: TextStyle(fontSize: 12))]),
                            const Text("Rp 100.000", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("Untuk Apa Boost Lowongan Kerja?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    "Tingkatkan visibilitas lowonganmu dan jangkau lebih banyak kandidat berkualitas! Dengan fitur Boost Loker, lowonganmu akan muncul di posisi teratas, mendapat jangkauan lebih luas.",
                    style: TextStyle(color: Colors.grey[600], height: 1.5),
                  ),

                  const SizedBox(height: 30),
                  const Text("Pilih Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),

                  // Payment Methods List
                  _buildPaymentOption(0, "BCA Virtual Account", "assets/images/bca.png"),
                  _buildPaymentOption(1, "GoPay", "assets/images/gopay.png"),
                  _buildPaymentOption(2, "QRIS", "assets/images/qris.png"),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Total Tarif", style: TextStyle(color: Colors.grey)),
                    Text(currency.format(100000), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFA01355))),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: controller.processPayment,
                  icon: const Icon(Icons.flash_on, size: 18),
                  label: const Text("Boost Lowongan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA01355),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int index, String title, String assetPath) {
    return Obx(() => InkWell(
      onTap: () => controller.selectPayment(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.selectedPaymentIndex.value == index ? const Color(0xFFA01355) : Colors.grey.shade300,
            width: controller.selectedPaymentIndex.value == index ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: controller.selectedPaymentIndex.value == index ? const Color(0xFFFCE4EC) : Colors.white,
        ),
        child: Row(
          children: [
            // Placeholder icon jika asset tidak ada
            const Icon(Icons.payment, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(fontWeight: controller.selectedPaymentIndex.value == index ? FontWeight.bold : FontWeight.normal))),
            if (controller.selectedPaymentIndex.value == index)
              const Icon(Icons.check_circle, color: Color(0xFFA01355)),
          ],
        ),
      ),
    ));
  }
}