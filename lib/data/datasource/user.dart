import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class UserDataSource implements UserRepository {
  final client = Supabase.instance.client;

  @override
  Future<UserRole?> getUserRole(String id) async {
    final data = await client
        .from('user')
        .select('role')
        .eq('id', id)
        .maybeSingle();
    if (data == null) {
      return null;
    }
    return UserRoleMapper.fromValue(data["role"]);
  }

  @override
  Future<void> setUserRole(String id, UserRole role) async {
    await client.from('user').insert({
      'id': id,
      'role': role.toValue(),
    });
  }

  @override
  Future<UserRecruiter?> getRecruiterProfile(String id) async {
    final data = await client
        .from('user_recruiter')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserRecruiterMapper.fromMap(data);
  }

  @override
  Future<void> setRecruiterProfile(UserRecruiter recruiter) {
    return client.from('user_recruiter').upsert(recruiter.toMap());
  }

  @override
  Future<void> setJobSeekerProfile(UserJobSeeker user) {
    return client.from('user_job_seeker').upsert(user.toMap());
  }

  @override
  Future<UserJobSeeker?> getJobSeekerProfile(String id) async {
    var data = await client.from("user_job_seeker").select().eq("id", id).maybeSingle();
    if (data == null) return null;

    return UserJobSeekerMapper.fromMap(data);
  }
}
