import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class WorkshopDataSource implements WorkshopRepository {
  final SupabaseClient client = Get.find();

  @override
  Future<String> add(Workshop workshop) async {
    final data = workshop.toMap();
    data.remove("id");
    data.remove("created_at");
    final created = await client.from("workshop").insert(data).select();
    return created.first["id"];
  }

  @override
  Future<void> update(Workshop workshop) async {
    final data = workshop.toMap();
    data.remove("created_at");
    await client.from("workshop").update(data).eq("id", workshop.id);
  }

  @override
  Future<void> delete(String id) async {
    await client.from("workshop").delete().eq("id", id);
  }

  @override
  Future<List<WorkshopWithRecruiter>> getAll() async {
    final data = await client.from("workshop").select("*, user_recruiter(*)");
    return data
        .map(
          (row) => WorkshopWithRecruiter(
            workshop: WorkshopMapper.fromMap(row),
            recruiter: UserRecruiterMapper.fromMap(row["user_recruiter"]),
          ),
        )
        .toList();
  }

  @override
  Future<List<Workshop>> getByRecruiterId(String recruiterId) async {
    final data = await client
        .from("workshop")
        .select("*")
        .eq("recruiter_id", recruiterId);
    return data.map((row) => WorkshopMapper.fromMap(row)).toList();
  }

  @override
  Future<Workshop?> getById(String id) async {
    final data = await client
        .from("workshop")
        .select()
        .eq("id", id)
        .maybeSingle();
    if (data == null) return null;
    return WorkshopMapper.fromMap(data);
  }

  @override
  Future<String> uploadWorkshopImage(String workshopId, File file) async {
    final path = "workshop/$workshopId";
    await client.storage
        .from("files")
        .upload(path, file, fileOptions: const FileOptions(upsert: true));
    final data = client.storage.from("files").getPublicUrl(path);
    return data;
  }
}
