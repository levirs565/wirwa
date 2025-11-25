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
  static const String ARGUMENT_JOB_VACANCY_ID = "job_vacancy_id";
  static const String ARGUMENT_IS_RECRUITER = "is_recruiter";

  final ChatRepository chatRepository = Get.find();
  final JobVacancyRepository jobVacancyRepository = Get.find();
  final JobApplicationRepository jobApplicationRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  String jobSeekerId = "";
  String jobVacancyId = "";
  bool isRecruiter = false;

  final RxList<Chat> chats = <Chat>[].obs;
  final Rx<JobVacancy?> jobVacancy = Rxn();
  final Rx<UserJobSeeker?> jobSeekerProfile = Rxn();
  final Rx<UserRecruiter?> recruiterProfile = Rxn();
  final Rx<JobApplication?> application = Rxn();

  @override
  void onInit() {
    super.onInit();
    jobSeekerId = Get.arguments[ARGUMENT_JOB_SEEKER_ID] ?? "";
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
    final job = await jobVacancyRepository.getById(jobVacancyId);
    jobVacancy.value = job;

    application.value = await jobApplicationRepository.get(
      jobVacancyId,
      jobSeekerId,
    );

    if (isRecruiter) {
      jobSeekerProfile.value = await userRepository.getJobSeekerProfile(
        jobSeekerId,
      );
    } else {
      recruiterProfile.value = await userRepository.getRecruiterProfile(
        job!.recruiterId,
      );
    }

    final data = await chatRepository.getConversations(
      jobVacancyId,
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
        jobSeekerId: jobSeekerId,
        jobVacancyId: jobVacancyId,
        message: message,
        isRecruiter: isRecruiter,
      ),
    );
    messageController.clear();
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

  void setApplicantState(JobApplicationStatus? value) async {
    if (value == null) return;

    await jobApplicationRepository.setState(
      application.value!.id,
      value,
    );
  }
}

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatController());

  static Map<String, dynamic> createArguments(
    String jobSeekerId,
    String jobVacancyId,
    bool isRecruiter,
  ) {
    return {
      ChatController.ARGUMENT_JOB_SEEKER_ID: jobSeekerId,
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
            _appBar(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: _chatList(context),
              ),
            ),
            _messageInput(context),
          ],
        ),
      ),
    );
  }

  static Map<JobApplicationStatus, String> statusMap = {
    JobApplicationStatus.PENDING: "Dilamar",
    JobApplicationStatus.SELECTION: "Seleksi",
    JobApplicationStatus.ACCEPTED: "Direkrut",
    JobApplicationStatus.REJECTED: "Belum Sesuai",
  };

  Widget _appBar(BuildContext context) {
    return Padding(
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
                  "${controller.jobVacancy.value?.title ?? ""} (${(controller.isRecruiter ? controller.jobSeekerProfile.value?.name : controller.recruiterProfile.value?.name) ?? ""})",
                  style: TextStyle(
                    color: Color(0xFFA01355),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Obx(
            () => controller.application.value != null
                ? (controller.application.value!.status ==
                          JobApplicationStatus.PENDING || !controller.isRecruiter)
                      ? Text(statusMap[controller.application.value!.status]!)
                      : DropdownMenu(
                          controller: controller.statusController,
                          initialSelection: controller.application.value?.status,
                          onSelected: controller.setApplicantState,
                          dropdownMenuEntries: statusMap.entries
                              .where(
                                (entry) =>
                                    entry.key != JobApplicationStatus.PENDING,
                              )
                              .map(
                                (entry) => DropdownMenuEntry(
                                  value: entry.key,
                                  label: entry.value,
                                ),
                              )
                              .toList(),
                        )
                : Center(),
          ),
        ],
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

  Widget _chat(BuildContext context, Chat chat) {
    bool isRight = controller.isRecruiter == chat.isRecruiter;
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

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: boxDecoration,
          child: Text(chat.message, style: textStyle),
        ),
      ),
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
