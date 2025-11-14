import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class JobApplicationDataSource implements JobApplicationRepository {
  final SupabaseClient client = Get.find();

  @override
  Future<void> add(JobApplication application) async {
    final data = application.toMap();
    data.remove("id");
    data.remove("created_at");
    await client.from("job_application").insert(data);
  }

  @override
  Future<JobApplication?> get(String jobVacancyId, String jobSeekerId) async {
    // TODO: Configure RLS rule
    final data = await client
        .from("job_application")
        .select()
        .eq("job_vacancy_id", jobVacancyId)
        .eq("job_seeker_id", jobSeekerId)
        .maybeSingle();
    if (data == null) return null;
    return JobApplicationMapper.fromMap(data);
  }

  @override
  Future<List<JobApplicationWithVacancy>> getAllWithVacancy(
    String jobSeekerId,
  ) async {
    final data = await client
        .from("job_application")
        .select("*, job_vacancy(*)")
        .eq("job_seeker_id", jobSeekerId);
    return data.map(
      (map) => JobApplicationWithVacancy(
        application: JobApplicationMapper.fromMap(map),
        vacancy: JobVacancyMapper.fromMap(map["job_vacancy"])
      )
    ).toList();
  }

  // Future<void> test(String jobSeekerId) async {
  //   final data = await client.from("job_application")
  //   .select("*, job_vacancy(*)")
  //   .eq("job_seeker_id", jobSeekerId);
  //   return Pri
  // }
}
