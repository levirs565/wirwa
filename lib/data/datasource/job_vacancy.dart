import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class JobVacancyDataSource implements JobVacancyRepository {
  final client = Supabase.instance.client;

  static JobVacancy fromMap(Map<String, dynamic> map) {
    return JobVacancy(
      id: map["id"] as String,
      createdAt: DateTime.parse(map["created_at"] as String),
      title: map["title"] as String,
      location: map["location"] as String,
      description: map["description"] as String,
      startDate: DateTime.parse(map["start_date"] as String),
      endDate: map["end_date"] == null ? null : DateTime.parse(map["end_date"] as String),
      recruiterId: map["recruiter_id"] as String,
    );
  }

  static Map<String, dynamic> toMap(JobVacancy vacancy) {
    return {
      "title": vacancy.title,
      "location": vacancy.location,
      "description": vacancy.description,
      "start_date": vacancy.startDate.toIso8601String(),
      "end_date": vacancy.endDate?.toIso8601String(),
    };
  }

  @override
  Future<void> add(JobVacancy job) {
    return client.from("job_vacancy").insert(toMap(job));
  }

  @override
  Future<void> update(JobVacancy job) {
    return client.from("job_vacancy").update(toMap(job)).eq("id", job.id);
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
    return data.map((data) => fromMap(data)).toList();
  }

  @override
  Future<List<JobVacancy>> getAdvertised() async {
    // TODO: Approved date? Reject?
    final data = await client
        .from("job_vacancy_advertise_request")
        .select("job_vacancy(*)")
        .eq("is_approved", true)
        .order("job_vacancy.created_at", ascending: false);
    return data.map((data) => fromMap(data)).toList();
  }

  @override
  Future<JobVacancy?> getById(String id) async {
    final data = await client
        .from("job_vacancy")
        .select()
        .eq("id", id)
        .maybeSingle();
    if (data == null) return null;
    return fromMap(data);
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
