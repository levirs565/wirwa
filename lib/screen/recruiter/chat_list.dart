import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/chat.dart';

class RecruiterChatListController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final ChatRepository chatRepository = Get.find();
  final RxList<JobSeekerMinimalWithChat> chats =
      <JobSeekerMinimalWithChat>[].obs;

  @override
  void onReady() {
    super.onReady();
    refresh();
  }

  void refresh() async {
    final data = await chatRepository.getByRecruiterId(
      authRepository.getUserId()!,
    );
    chats.assignAll(data);
  }

  void toChat(String vacancyId, String jobSeekerId) {
    Get.to(
      () => ChatPage(),
      arguments: ChatPage.createArguments(jobSeekerId, vacancyId, true),
    );
  }
}

class RecruiterChatListPage extends StatelessWidget {
  final controller = Get.put(RecruiterChatListController());

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

  Widget _listTile(BuildContext context, JobSeekerMinimalWithChat data) {
    return InkWell(
      onTap: () =>
          controller.toChat(data.chat.jobVacancyId, data.chat.jobSeekerId),
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
              backgroundImage: (data.seeker.pictureUrl.isNotEmpty)
                  ? NetworkImage(data.seeker.pictureUrl) as ImageProvider
                  : null,
              child: data.seeker.pictureUrl.isEmpty
                  ? Text(
                      data.seeker.name[0].toUpperCase(),
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
                    "${data.vacancy.title} (${data.seeker.name})",
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
