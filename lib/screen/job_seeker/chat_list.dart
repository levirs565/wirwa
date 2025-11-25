import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/chat.dart';

// --- CONTROLLER ---
class JobSeekerChatListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final ChatRepository chatRepository = Get.find();
  final RxList<RecruiterMinimalWithChat> chats =
      <RecruiterMinimalWithChat>[].obs;
  final RxList<RecruiterMinimalWithChat> allChats =
      <RecruiterMinimalWithChat>[].obs;
  final RxString searchQuery = "".obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  @override
  void onClose() {
    chats.clear();
    allChats.clear();
    print("JobSeekerChatListController disposed");
    super.onClose();
  }

  void refresh() async {
    try {
      final userId = authRepository.getUserId();
      if (userId == null) {
        print("User not logged in, skipping chat load");
        return;
      }

      final data = await chatRepository.getByJobSeekerId(userId);
      allChats.assignAll(data);
      chats.assignAll(data);
    } catch (e, stackTrace) {
      print("Error loading chats: $e");
      print("Stack trace: $stackTrace");
    }
  }

  void searchChats(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      chats.assignAll(allChats);
    } else {
      chats.assignAll(
        allChats
            .where(
              (chat) =>
                  chat.recruiter.name.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  chat.chat.message.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void toChat(String vacancyId) {
    Get.to(
      () => ChatPage(),
      arguments: ChatPage.createArguments(
        authRepository.getUserId()!,
        vacancyId,
        false,
      ),
    );
  }

  String formatChatTime(DateTime chatTime) {
    final now = DateTime.now();
    final difference = now.difference(chatTime);

    if (difference.inDays == 0) {
      final hour = chatTime.hour.toString().padLeft(2, '0');
      final minute = chatTime.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    }

    if (difference.inDays == 1) {
      return "Kemarin";
    }

    if (difference.inDays < 7) {
      final days = [
        'Minggu',
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
      ];
      return days[chatTime.weekday % 7];
    }

    final day = chatTime.day.toString().padLeft(2, '0');
    final month = chatTime.month.toString().padLeft(2, '0');
    final year = chatTime.year.toString().substring(2);
    return "$day/$month/$year";
  }
}

class JobSeekerChatListPage extends StatelessWidget {
  JobSeekerChatListPage({Key? key}) : super(key: key);

  JobSeekerChatListController get controller {
    if (!Get.isRegistered<JobSeekerChatListController>()) {
      return Get.put(JobSeekerChatListController(), tag: 'chat_list');
    }
    return Get.find<JobSeekerChatListController>();
  }

  final Color primaryColor = const Color(0xFFA01355);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => controller.chats.isEmpty
                    ? Center(
                        child: Text(
                          controller.searchQuery.isEmpty
                              ? "Belum ada percakapan"
                              : "Tidak ada hasil pencarian",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: controller.chats.length,
                        itemBuilder: (context, index) =>
                            _listTile(context, controller.chats[index]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const Text(
            "Chat",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: (value) => controller.searchChats(value),
        decoration: InputDecoration(
          hintText: "Cari Percakapan",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: primaryColor),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _listTile(BuildContext context, RecruiterMinimalWithChat data) {
    return InkWell(
      onTap: () => controller.toChat(data.chat.jobVacancyId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: (data.recruiter.pictureUrl != null)
                      ? NetworkImage(data.recruiter.pictureUrl!)
                            as ImageProvider
                      : null,
                  child: data.recruiter.pictureUrl == null
                      ? Text(
                          data.recruiter.name[0].toUpperCase(),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853), // Hijau online
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.recruiter.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.chat.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  controller.formatChatTime(data.chat.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                // Uncomment jika mau tampilkan badge notifikasi
                // const SizedBox(height: 6),
                // Container(
                //   padding: const EdgeInsets.all(6),
                //   decoration: const BoxDecoration(
                //     color: Color(0xFFFFCDD2),
                //     shape: BoxShape.circle,
                //   ),
                //   child: Text(
                //     "1",
                //     style: TextStyle(
                //       color: primaryColor,
                //       fontSize: 10,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
