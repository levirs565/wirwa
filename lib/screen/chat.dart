import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/job.dart';
import 'package:wirwa/screen/recruiter/job.dart';

class ChatController extends GetxController {
  static const String ARGUMENT_JOB_SEEKER_ID = "job_seeker_id";
  static const String ARGUMENT_RECRUITER_ID = "recruiter_id";
  static const String ARGUMENT_JOB_VACANCY_ID = "job_vacancy_id";
  static const String ARGUMENT_IS_RECRUITER = "is_recruiter";

  final ChatRepository chatRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final TextEditingController messageController = TextEditingController();

  String jobSeekerId = "";
  String recruiterId = "";
  String? jobVacancyId = "";
  bool isRecruiter = false;

  final RxList<ChatWithJobVacancyMinimal> chats =
      <ChatWithJobVacancyMinimal>[].obs;
  final Rx<JobVacancy?> jobVacancy = Rxn();
  final Rx<UserJobSeeker?> jobSeekerProfile = Rxn();
  final Rx<UserRecruiter?> recruiterProfile = Rxn();

  @override
  void onInit() {
    super.onInit();
    jobSeekerId = Get.arguments[ARGUMENT_JOB_SEEKER_ID] ?? "";
    recruiterId = Get.arguments[ARGUMENT_RECRUITER_ID] ?? "";
    jobVacancyId = Get.arguments[ARGUMENT_JOB_VACANCY_ID];
    isRecruiter = Get.arguments[ARGUMENT_IS_RECRUITER] ?? false;

    refreshData();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void refreshData() async {
    if (isRecruiter) {
      jobSeekerProfile.value = await userRepository.getJobSeekerProfile(
        jobSeekerId,
      );
    } else {
      recruiterProfile.value = await userRepository.getRecruiterProfile(
        recruiterId,
      );
    }

    if (jobVacancyId != null) {
      jobVacancy.value = await jobVacancyRepository.getById(jobVacancyId!);
    } else {
      jobVacancy.value = null;
    }

    final data = await chatRepository.getConversations(
      recruiterId,
      jobSeekerId,
    );
    chats.assignAll(data);
  }

  void sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;
    await chatRepository.add(
      Chat(
        id: "",
        createdAt: DateTime.timestamp(),
        recruiterId: recruiterId,
        jobSeekerId: jobSeekerId,
        jobVacancyId: jobVacancyId,
        message: message,
        isRecruiter: isRecruiter,
      ),
    );
    messageController.clear();
    jobVacancyId = null;
    refreshData();
  }

  void goToJob(String id) {
    if (isRecruiter) {
      Get.to(
        () => RecruiterJobPage(),
        arguments: RecruiterJobPage.createArguments(id),
      );
    } else {
      Get.to(
        () => JobSeekerJobPage(),
        arguments: JobSeekerJobPage.createArguments(id),
      );
    }
  }

  void clearJobVacancy() {
    jobVacancyId = null;
    jobVacancy.value = null;
  }
}

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatController());

  static Map<String, dynamic> createArguments(
    String jobSeekerId,
    String recruiterId,
    String? jobVacancyId,
    bool isRecruiter,
  ) {
    return {
      ChatController.ARGUMENT_JOB_SEEKER_ID: jobSeekerId,
      ChatController.ARGUMENT_RECRUITER_ID: recruiterId,
      ChatController.ARGUMENT_JOB_VACANCY_ID: jobVacancyId,
      ChatController.ARGUMENT_IS_RECRUITER: isRecruiter,
    };
  }

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
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Obx(
                        () => Text(
                          (controller.isRecruiter
                                  ? controller.jobSeekerProfile.value?.name
                                  : controller.recruiterProfile.value?.name) ??
                              "",
                          style: TextStyle(
                            color: Color(0xFFA01355),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: _chatList(context),
              ),
            ),
            _jobVacancy(context),
            _messageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _chatList(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.chats.length,
        itemBuilder: (context, index) =>
            _chat(context, controller.chats[index]),
      ),
    );
  }

  Widget _chat(BuildContext context, ChatWithJobVacancyMinimal data) {
    bool isRight = controller.isRecruiter == data.chat.isRecruiter;
    final alignment = isRight ? Alignment.centerRight : Alignment.centerLeft;
    final boxDecoration = isRight
        ? const BoxDecoration(
            color: Color(0xFFF1F1F1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(1),
            ),
          )
        : const BoxDecoration(
            color: Color(0xFF96184A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(1),
              bottomRight: Radius.circular(20),
            ),
          );
    final textStyle = isRight
        ? TextStyle(color: Colors.black87, fontSize: 14)
        : TextStyle(color: Colors.white, fontSize: 14);

    return Column(
      spacing: 8,
      children: [
        data.vacancy != null
            ? GestureDetector(
                onTap: () => controller.goToJob(data.chat.jobVacancyId!),
                child: Align(
                  alignment: alignment,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: boxDecoration,
                      child: Row(
                        spacing: 8,
                        children: [
                          Text(
                            "Pekerjaan: ${data.vacancy!.title}",
                            style: textStyle,
                          ),
                          Icon(Icons.arrow_outward, color: textStyle.color),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(),
        Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: boxDecoration,
              child: Text(data.chat.message, style: textStyle),
            ),
          ),
        ),
      ],
    );
  }

  Widget _jobVacancy(BuildContext context) {
    return Obx(
      () => controller.jobVacancy.value != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                spacing: 8,
                children: [
                  GestureDetector(
                    onTap: () =>
                        controller.goToJob(controller.jobVacancy.value!.id),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Text(
                            "Pekerjaan: ${controller.jobVacancy.value!.title}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          Icon(Icons.arrow_outward),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.clearJobVacancy,
                    icon: Icon(Icons.clear),
                  ),
                ],
              ),
            )
          : Center(),
    );
  }

  Widget _messageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFEDEDED)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan di sini',
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.sendMessage,
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded, color: Color(0xFFB74857)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
