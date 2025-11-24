import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/chat.dart';

class JobSeekerChatListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final ChatRepository chatRepository = Get.find();
  final RxList<RecruiterMinimalWithChat> chats =
      <RecruiterMinimalWithChat>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() async {
    final data = await chatRepository.getByJobSeekerId(
      authRepository.getUserId()!,
    );
    chats.assignAll(data);
  }

  void toChat(String recruiterId) {
    Get.to(
      () => ChatPage(),
      arguments: ChatPage.createArguments(
        authRepository.getUserId()!,
        recruiterId,
        null,
        false,
      ),
    );
  }
}

class JobSeekerChatListPage extends StatelessWidget {
  final controller = Get.put(JobSeekerChatListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.chats.length,
        itemBuilder: (context, index) =>
            _listTile(context, controller.chats[index]),
      ),
    );
  }

  Widget _listTile(BuildContext context, RecruiterMinimalWithChat data) {
    return InkWell(
      onTap: () => controller.toChat(data.chat.recruiterId),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              backgroundImage: (data.recruiter.pictureUrl != null)
                  ? NetworkImage(data.recruiter.pictureUrl!) as ImageProvider
                  : null,
              child: data.recruiter.pictureUrl == null
                  ? Text(
                      data.recruiter.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFA01355),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.recruiter.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      data.chat.message,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
