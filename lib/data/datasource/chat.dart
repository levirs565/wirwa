import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class ChatDataSource implements ChatRepository {
  final client = Get.find<SupabaseClient>();

  // TODO: Enable RLS

  @override
  Future<void> add(Chat chat) async {
    final data = chat.toMap();
    data.remove("id");
    data.remove("created_at");
    await client.from("chat").insert(data);
  }

  @override
  Future<List<RecruiterMinimalWithChat>> getByJobSeekerId(
    String jobSeekerId,
  ) async {
    final data = await client
        .from("chat_latest")
        .select("*,user_recruiter(name,picture_url)")
        .eq("job_seeker_id", jobSeekerId);
    return data
        .map(
          (raw) => RecruiterMinimalWithChat(
            recruiter: UserRecruiterMinimalMapper.fromMap(
              raw["user_recruiter"],
            ),
            chat: ChatMapper.fromMap(raw),
          ),
        )
        .toList();
  }

  @override
  Future<List<JobSeekerMinimalWithChat>> getByRecruiterId(
    String recruiterId,
  ) async {
    final data = await client
        .from("chat_latest")
        .select("*,user_job_seeker(name,picture_url)")
        .eq("recruiter_id", recruiterId);
    return data
        .map(
          (raw) => JobSeekerMinimalWithChat(
            seeker: UserJobSeekerMinimalMapper.fromMap(raw["user_job_seeker"]),
            chat: ChatMapper.fromMap(raw),
          ),
        )
        .toList();
  }

  @override
  Future<List<ChatWithJobVacancyMinimal>> getConversations(
    String recruiterId,
    String jobSeekerId,
  ) async {
    final data = await client
        .from("chat")
        .select("*,job_vacancy(title)")
        .eq("recruiter_id", recruiterId)
        .eq("job_seeker_id", jobSeekerId);
    return data
        .map(
          (raw) => ChatWithJobVacancyMinimal(
            chat: ChatMapper.fromMap(raw),
            vacancy: raw["job_vacancy"] != null
                ? JobVacancyMinimalMapper.fromMap(raw["job_vacancy"])
                : null,
          ),
        )
        .toList();
  }
}
