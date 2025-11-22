import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'workshop.dart'; 

// --- Controller ---
class JobSeekerWorkshopListController extends GetxController {
  final WorkshopRepository workshopRepository = Get.find();
  final RxList<WorkshopWithRecruiter> workshops = <WorkshopWithRecruiter>[].obs;
  
  // Tambahan untuk filter UI
  final List<String> categories = ["Semua", "Penuh Waktu", "Paruh Waktu", "Bootcamp"];
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() {
    workshopRepository.getAll().then((value) {
      workshops.clear();
      workshops.insertAll(0, value);
    });
  }

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
    // Tambahkan logika filter data di sini jika diperlukan
  }

  Future<void> toDetail(String id) async {
    await Get.to(
      () => JobSeekerWorkshopPage(),
      arguments: JobSeekerWorkshopPage.createArguments(id),
    );
    refresh();
  }
}

// --- UI Page ---
class JobSeekerWorkshopListPage extends StatelessWidget {
  final controller = Get.put(JobSeekerWorkshopListController());

  final Color kBackgroundColor = const Color(0xFFFFF5F7);
  final Color kPrimaryColor = const Color(0xFFFF5A5F); 
  final Color kTextColor = const Color(0xFF1F1F1F);
  final Color kSubtitleColor = const Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildCategoryFilter(),
            const SizedBox(height: 20),
            // List Workshop
            Expanded(
              child: Obx(
                () => controller.workshops.isEmpty
                    ? Center(child: Text("Belum ada pelatihan", style: TextStyle(color: kSubtitleColor)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.workshops.length,
                        itemBuilder: (context, index) =>
                            _buildWorkshopCard(context, controller.workshops[index]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Header (Judul & Search Bar)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          // Top Bar (Back Button & Title)
          Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back, color: kTextColor),
              ),
              Expanded(
                child: Text(
                  "Pelatihan",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextColor),
                ),
              ),
              const SizedBox(width: 24), // Penyeimbang icon back agar judul pas di tengah
            ],
          ),
          const SizedBox(height: 20),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Pelatihan",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                suffixIcon: Icon(Icons.tune, color: kSubtitleColor), // Icon filter di kanan
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Filter Kategori (Horizontal Scroll)
  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedCategoryIndex.value == index;
            return GestureDetector(
              onTap: () => controller.changeCategory(index),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? kPrimaryColor : kPrimaryColor.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(
                    controller.categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // 3. Kartu Workshop
  Widget _buildWorkshopCard(BuildContext context, WorkshopWithRecruiter data) {
    return GestureDetector(
      onTap: () => controller.toDetail(data.workshop.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Workshop
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300, // Placeholder warna abu-abu
                // Gunakan kode di bawah jika sudah ada URL gambar di model:
                // child: Image.network(
                //   data.workshop.imageUrl ?? "https://via.placeholder.com/300", 
                //   fit: BoxFit.cover,
                // ),
                child: const Icon(Icons.image, size: 50, color: Colors.white), // Placeholder icon
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    data.workshop.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Nama Penyelenggara (Logo kecil + Nama)
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.business, size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data.recruiter?.name ?? "Penyelenggara",
                          style: TextStyle(color: kSubtitleColor, fontSize: 12, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Deskripsi Singkat
                  Text(
                    data.workshop.description, // Pastikan field ini ada di model
                    style: TextStyle(color: kTextColor.withOpacity(0.8), fontSize: 14, height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Lokasi & Tanggal
                  Row(
                    children: [
                      _buildFooterInfo(Icons.location_on_outlined, "Zoom Meeting"), // Bisa ganti data.workshop.location
                      const SizedBox(width: 16),
                      _buildFooterInfo(Icons.calendar_today_outlined, "20 Des 2025"), // Bisa ganti format tanggal
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kecil untuk icon + teks di bawah kartu
  Widget _buildFooterInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFA53337)), // Merah gelap sesuai gambar
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: kSubtitleColor),
        ),
      ],
    );
  }
}