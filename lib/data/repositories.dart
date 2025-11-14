import 'package:wirwa/data/model.dart';

abstract interface class UserRepository {
  Future<UserRole?> getUserRole(String id);
  Future<void> setUserRole(String id, UserRole role);
  Future<UserRecruiter?> getRecruiterProfile(String id);
  Future<void> setJobSeekerProfile(UserJobSeeker recruiter);
  Future<UserJobSeeker?> getJobSeekerProfile(String id);
  Future<void> setRecruiterProfile(UserRecruiter recruiter);
}

abstract interface class JobVacancyRepository {
  /**
   * Warning: id, createdAt, recruitedId is ignored
   */
  Future<void> add(JobVacancy job);

  /**
   * Warning: createdAt, recruitedId is ignored
   */
  Future<void> update(JobVacancy job);

  Future<void> delete(String id);

  Future<List<JobVacancy>> getAll({String? recruiterIdFilter});

  Future<List<JobVacancy>> getAdvertised();

  Future<JobVacancy?> getById(String id);

  Future<void> createAdvertiseRequest(String id);

  Future<void> approveAdvertiseRequest(String advertiseRequestId);
}