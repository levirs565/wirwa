import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';

class UserDataSource implements UserRepository {
  final client = Supabase.instance.client;

  static UserRole _mapStringToUserRole(String role) {
    switch (role) {
      case 'recruiter':
        return UserRole.RECRUITER;
      case 'job_seeker':
        return UserRole.JOB_SEEKER;
      default:
        throw ArgumentError('Invalid role: $role');
    }
  }

  static String _mapUserRoleToString(UserRole role) {
    switch (role) {
      case UserRole.RECRUITER:
        return 'recruiter';
      case UserRole.JOB_SEEKER:
        return 'job_seeker';
    }
  }

  static UserRecruiterType _mapStringToRecruiterType(String type) {
    switch (type) {
      case 'company':
        return UserRecruiterType.COMPANY;
      case 'individual':
        return UserRecruiterType.INDIVIDUAL;
      default:
        throw ArgumentError('Invalid recruiter type: $type');
    }
  }

  static String _mapUserRecruiterTypeToString(UserRecruiterType type) {
    switch (type) {
      case UserRecruiterType.COMPANY:
        return 'company';
      case UserRecruiterType.INDIVIDUAL:
        return 'individual';
    }
  }

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
    return _mapStringToUserRole(data["role"] as String);
  }

  @override
  Future<void> setUserRole(String id, UserRole role) async {
    await client.from('user').insert({
      'id': id,
      'role': _mapUserRoleToString(role),
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

    return UserRecruiter(
      id: data["id"],
      type: _mapStringToRecruiterType(data["type"]),
      name: data["name"],
    );
  }

  @override
  Future<void> setRecruiterProfile(UserRecruiter recruiter) {
    return client.from('user_recruiter').upsert({
      'id': recruiter.id,
      "type": _mapUserRecruiterTypeToString(recruiter.type),
      'name': recruiter.name,
    });
  }

  @override
  Future<void> setJobSeekerProfile(UserJobSeeker recruiter) {
    return client.from('user_job_seeker').upsert({
      'id': recruiter.id,
      "picture_url": recruiter.pictureUrl,
      'name': recruiter.name,
      "domisili": recruiter.domisili,
      "birth_date": recruiter.birthDate.toIso8601String(),
      "phone_number": recruiter.phoneNumber,
    });
  }

  @override
  Future<UserJobSeeker?> getJobSeekerProfile(String id) async {
    var data = await client.from("user_job_seeker").select().eq("id", id).maybeSingle();
    if (data == null) return null;

    return UserJobSeeker(
      id: data["id"],
      name: data["name"],
      pictureUrl: data["picture_url"],
      birthDate: DateTime.parse(data["birth_date"]),
      phoneNumber: data["phone_number"],
      domisili: data["domisili"]
    );
  }
}
