enum UserRole {
  RECRUITER,
  JOB_SEEKER
}

enum UserRecruiterType { COMPANY,INDIVIDUAL }

class UserRecruiter {
  final String id;
  final UserRecruiterType type;
  final String name;

  UserRecruiter({required this.id, required this.type, required this.name});
}

class UserJobSeeker {
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

class JobVacancy {
  final String id;
  final DateTime createdAt;
  final String title, location, description;
  final DateTime startDate;
  final DateTime? endDate;
  final String recruiterId;

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

class Workshop {
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

enum JobApplicationStatus { pending, accepted, rejected }

class JobApplication {
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

class JobVacancyAdvertiseRequest {
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
