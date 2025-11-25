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

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserRecruiter with UserRecruiterMappable {
  final String id;
  final UserRecruiterType type;
  final String name;
  final String? pictureUrl;
  final String phoneNumber;

  UserRecruiter({
    required this.id,
    required this.type,
    required this.name,
    this.pictureUrl,
    required this.phoneNumber,
  });
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
  final String? jobType;
  final String? workPolicy;
  final String? salary;
  final String? minAge;
  final String? skill;
  final String? minEducation;

  JobVacancy({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.location,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.recruiterId,
    required this.jobType,
    required this.workPolicy,
    required this.salary,
    required this.minAge,
    required this.skill,
    required this.minEducation,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Workshop with WorkshopMappable {
  final String id;
  final DateTime createdAt;
  final String title, description, formUrl, recruiterId;
  final String? imageUrl;

  Workshop({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.formUrl,
    required this.recruiterId,
    this.imageUrl,
  });
}

@MappableEnum()
enum JobApplicationStatus {
  @MappableValue("pending")
  PENDING,
  @MappableValue("selection")
  SELECTION,
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

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Chat with ChatMappable {
  final String id;
  final DateTime createdAt;
  final String jobSeekerId;
  final String jobVacancyId;
  final String message;
  final bool isRecruiter;

  Chat({
    required this.id,
    required this.createdAt,
    required this.jobSeekerId,
    required this.jobVacancyId,
    required this.message,
    required this.isRecruiter,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class JobVacancyMinimal with JobVacancyMinimalMappable {
  final String title;

  JobVacancyMinimal({required this.title});
}

class JobSeekerMinimalWithChat {
  final UserJobSeekerMinimal seeker;
  final JobVacancyMinimal vacancy;
  final Chat chat;

  JobSeekerMinimalWithChat({
    required this.seeker,
    required this.vacancy,
    required this.chat,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserRecruiterMinimal with UserRecruiterMinimalMappable {
  final String name;
  final String? pictureUrl;

  UserRecruiterMinimal({required this.name, required this.pictureUrl});
}

class RecruiterMinimalWithChat {
  final UserRecruiterMinimal recruiter;
  final JobVacancyMinimal vacancy;
  final Chat chat;

  RecruiterMinimalWithChat({
    required this.recruiter,
    required this.vacancy,
    required this.chat,
  });
}
