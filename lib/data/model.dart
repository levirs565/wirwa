import 'package:dart_mappable/dart_mappable.dart';

part 'model.mapper.dart';

@MappableEnum()
enum UserRole {
  @MappableValue("recruiter")
  RECRUITER,
  @MappableValue("job_seeker")
  JOB_SEEKER,
}

@MappableEnum()
enum UserRecruiterType {
  @MappableValue("company")
  COMPANY,
  @MappableValue("individual")
  INDIVIDUAL,
}

@MappableClass()
class UserRecruiter with UserRecruiterMappable {
  final String id;
  final UserRecruiterType type;
  final String name;

  UserRecruiter({required this.id, required this.type, required this.name});
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserJobSeeker with UserJobSeekerMappable {
  final String id, pictureUrl;
  final DateTime birthDate;
  final String domisili, name, phoneNumber;

  UserJobSeeker({
    required this.id,
    required this.pictureUrl,
    required this.birthDate,
    required this.domisili,
    required this.name,
    required this.phoneNumber,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class JobVacancy with JobVacancyMappable {
  final String id;
  final DateTime createdAt;
  final String title, location, description;
  final DateTime startDate;
  final DateTime? endDate;
  final String recruiterId;

  // TODO: Salary

  JobVacancy({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.location,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.recruiterId,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Workshop with WorkshopMappable {
  final String id;
  final DateTime createdAt;
  final String title, description, formUrl, recruiterId;

  Workshop({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.formUrl,
    required this.recruiterId,
  });
}

@MappableEnum()
enum JobApplicationStatus {
  @MappableValue("pending")
  PENDING,
  @MappableValue("accepted")
  ACCEPTED,
  @MappableValue("rejected")
  REJECTED,
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class JobApplication with JobApplicationMappable {
  final String id;
  final DateTime createdAt;
  final JobApplicationStatus status;
  final String jobVacancyId, jobSeekerId;

  // TODO: CV?

  JobApplication({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.jobVacancyId,
    required this.jobSeekerId,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class JobVacancyAdvertiseRequest with JobVacancyAdvertiseRequestMappable {
  final String id;
  final DateTime createdAt;
  final String paymentId;
  final bool isApproved;

  JobVacancyAdvertiseRequest({
    required this.id,
    required this.createdAt,
    required this.paymentId,
    required this.isApproved,
  });
}

class JobApplicationWithVacancy {
  final JobApplication application;
  final JobVacancy vacancy;

  JobApplicationWithVacancy({required this.application, required this.vacancy});
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserJobSeekerMinimal with UserJobSeekerMinimalMappable {
  final String pictureUrl, name;

  UserJobSeekerMinimal({required this.pictureUrl, required this.name});
}

class JobApplicationWithSeeker {
  final JobApplication application;
  final UserJobSeekerMinimal seeker;

  JobApplicationWithSeeker({required this.application, required this.seeker});
}

class WorkshopWithRecruiter {
  final Workshop workshop;
  final UserRecruiter recruiter;

  WorkshopWithRecruiter({required this.workshop, required this.recruiter});
}


