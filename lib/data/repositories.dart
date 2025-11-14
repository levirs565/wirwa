import 'package:wirwa/data/model.dart';

abstract interface class AuthRepository {
  Stream<String?> userChangedStream();
  String? getUserId();
  Future<void> login();
  Future<void> signOut();
}

abstract interface class UserRepository {
  Future<UserRole?> getUserRole(String id);
  Future<void> setUserRole(String id, UserRole role);
  Future<UserRecruiter?> getRecruiterProfile(String id);
  Future<void> setJobSeekerProfile(UserJobSeeker recruiter);
  Future<UserJobSeeker?> getJobSeekerProfile(String id);
  Future<void> setRecruiterProfile(UserRecruiter user);
}

abstract interface class JobVacancyRepository {
  /**
   * Warning: id, createdAt, recruiterId is ignored
   */
  Future<void> add(JobVacancy job);

  /**
   * Warning: createdAt, recruiterId is ignored
   */
  Future<void> update(JobVacancy job);

  Future<void> delete(String id);

  Future<List<JobVacancy>> getAll({String? recruiterIdFilter});

  Future<List<JobVacancy>> getAdvertised();

  Future<JobVacancy?> getById(String id);

  Future<void> createAdvertiseRequest(String id);

  Future<void> approveAdvertiseRequest(String advertiseRequestId);
}

abstract interface class JobApplicationRepository {
  Future<void> add(JobApplication application);

  Future<JobApplication?> get(String jobVacancyId, String jobSeekerId);

  Future<List<JobApplicationWithVacancy>> getAllWithVacancy(String jobSeekerId);
}