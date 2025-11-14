import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class JobVacancyDataSource implements JobVacancyRepository {
  final client = Get.find<SupabaseClient>();

  @override
  Future<void> add(JobVacancy job) {
    final data = job.toMap();
    data.remove("id");
    data.remove("created_at");
    data.remove("recruiter_id");
    return client.from("job_vacancy").insert(data);
  }

  @override
  Future<void> update(JobVacancy job) {
    final data = job.toMap();
    data.remove("created_at");
    data.remove("recruiter_id");
    return client.from("job_vacancy").update(data).eq("id", job.id);
  }

  @override
  Future<void> delete(String id) {
    return client.from("job_vacancy").delete().eq("id", id);
  }

  @override
  Future<List<JobVacancy>> getAll({String? recruiterIdFilter}) async {
    var query = client.from("job_vacancy").select();
    if (recruiterIdFilter != null) {
      query = query.eq("recruiter_id", recruiterIdFilter);
    }
    final data = await query.order("created_at", ascending: false);
    return data.map((data) => JobVacancyMapper.fromMap(data)).toList();
  }

  @override
  Future<List<JobVacancy>> getAdvertised() async {
    // TODO: Approved date? Reject?
    final data = await client
        .from("job_vacancy_advertise_request")
        .select("job_vacancy(*)")
        .eq("is_approved", true)
        .order("job_vacancy.created_at", ascending: false);
    return data.map((data) => JobVacancyMapper.fromMap(data)).toList();
  }

  @override
  Future<JobVacancy?> getById(String id) async {
    final data = await client
        .from("job_vacancy")
        .select()
        .eq("id", id)
        .maybeSingle();
    if (data == null) return null;
    return JobVacancyMapper.fromMap(data);
  }

  @override
  Future<void> createAdvertiseRequest(String id) async {
    await client.from("job_vacancy_advertise_request").insert({
      "job_vacancy_id": id,
    });
  }

  @override
  Future<void> approveAdvertiseRequest(String advertiseRequestId) async {
    await client
        .from("job_vacancy_advertise_request")
        .update({"is_approved": true})
        .eq("id", advertiseRequestId);
  }
}
