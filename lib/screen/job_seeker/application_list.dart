import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/job.dart';

class JobSeekerApplicationListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();
  
  final RxList<JobApplicationWithVacancy> jobs = <JobApplicationWithVacancy>[].obs;
  
  final RxInt selectedFilterIndex = 0.obs;

  final List<String> filters = ["Dilamar", "Seleksi", "Direkrut", "Belum Siap"];
  // Dummy counts untuk badge (nanti bisa diambil dari data real)
  final List<int> filterCounts = [1, 0, 0, 2];

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  void refreshData() {
    // Simulasi loading atau fetch data
    jobApplicationRepository
        .getAllWithVacancy(authRepository.getUserId()!)
        .then((value) {
      jobs.clear();
      jobs.insertAll(0, value);
    });
  }

  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    // Di sini nanti bisa tambahkan logika filtering list 'jobs' berdasarkan status
    refreshData(); 
  }

  void toDetail(String id) {
    Get.to(
      () => JobSeekerJobPage(),
      arguments: JobSeekerJobPage.createArguments(id),
    );
  }
}

// --- 2. Update Page UI ---
class JobSeekerApplicationListPage extends StatelessWidget {
  final JobSeekerApplicationListController controller = Get.put(
    JobSeekerApplicationListController(),
  );

  // Warna sesuai desain (Salmon/Pinkish)
  final Color primaryColor = const Color(0xFFFF8B7E);
  final Color backgroundColor = const Color(0xFFFFF8F8);
  final Color textGrey = const Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Riwayat Lowongan",
          style: TextStyle(
            color: Colors.black87, 
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
         
          _buildFilterSection(),
          
          const SizedBox(height: 10),

          
          Expanded(
            child: Obx(
              () => controller.jobs.isEmpty 
                  ? Center(child: Text("Belum ada riwayat", style: TextStyle(color: textGrey))) 
                  : _list(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(controller.filters.length, (index) {
          return Obx(() {
            bool isSelected = controller.selectedFilterIndex.value == index;
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () => controller.changeFilter(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        controller.filters[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Badge count
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.3) : const Color(0xFFFFF0EE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${controller.filterCounts[index]}", 
                          style: TextStyle(
                            color: isSelected ? Colors.white : primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.jobs.length,
      itemBuilder: (context, index) =>
          _listTile(context, controller.jobs[index]),
    );
  }

  Widget _listTile(BuildContext context, JobApplicationWithVacancy job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.toDetail(job.vacancy.id),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage("https://via.placeholder.com/150"), 
                        fit: BoxFit.cover
                      )
                    ),
                    child: const Icon(Icons.business, color: Colors.grey), 
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.vacancy.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "PT Pisang Kemul", 
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
               
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      job.application.status.toString().split('.').last, 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag("Penuh Waktu"),
                  _buildTag("F&B"),
                  _buildTag("Entry Level"),
                ],
              ),

              const SizedBox(height: 16),
              
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18, color: primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    "Remote", 
                    style: TextStyle(color: textGrey, fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    "Rp 2 jt - Rp 4 jt /bulan", 
                    style: TextStyle(
                      color: textGrey, 
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: primaryColor, fontSize: 11),
      ),
    );
  }
}