// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'model.dart';

class UserRoleMapper extends EnumMapper<UserRole> {
  UserRoleMapper._();

  static UserRoleMapper? _instance;
  static UserRoleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserRoleMapper._());
    }
    return _instance!;
  }

  static UserRole fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserRole decode(dynamic value) {
    switch (value) {
      case "recruiter":
        return UserRole.RECRUITER;
      case "job_seeker":
        return UserRole.JOB_SEEKER;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserRole self) {
    switch (self) {
      case UserRole.RECRUITER:
        return "recruiter";
      case UserRole.JOB_SEEKER:
        return "job_seeker";
    }
  }
}

extension UserRoleMapperExtension on UserRole {
  dynamic toValue() {
    UserRoleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserRole>(this);
  }
}

class UserRecruiterTypeMapper extends EnumMapper<UserRecruiterType> {
  UserRecruiterTypeMapper._();

  static UserRecruiterTypeMapper? _instance;
  static UserRecruiterTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserRecruiterTypeMapper._());
    }
    return _instance!;
  }

  static UserRecruiterType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserRecruiterType decode(dynamic value) {
    switch (value) {
      case "company":
        return UserRecruiterType.COMPANY;
      case "individual":
        return UserRecruiterType.INDIVIDUAL;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserRecruiterType self) {
    switch (self) {
      case UserRecruiterType.COMPANY:
        return "company";
      case UserRecruiterType.INDIVIDUAL:
        return "individual";
    }
  }
}

extension UserRecruiterTypeMapperExtension on UserRecruiterType {
  dynamic toValue() {
    UserRecruiterTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserRecruiterType>(this);
  }
}

class JobApplicationStatusMapper extends EnumMapper<JobApplicationStatus> {
  JobApplicationStatusMapper._();

  static JobApplicationStatusMapper? _instance;
  static JobApplicationStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JobApplicationStatusMapper._());
    }
    return _instance!;
  }

  static JobApplicationStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  JobApplicationStatus decode(dynamic value) {
    switch (value) {
      case "pending":
        return JobApplicationStatus.PENDING;
      case "selection":
        return JobApplicationStatus.SELECTION;
      case "accepted":
        return JobApplicationStatus.ACCEPTED;
      case "rejected":
        return JobApplicationStatus.REJECTED;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(JobApplicationStatus self) {
    switch (self) {
      case JobApplicationStatus.PENDING:
        return "pending";
      case JobApplicationStatus.SELECTION:
        return "selection";
      case JobApplicationStatus.ACCEPTED:
        return "accepted";
      case JobApplicationStatus.REJECTED:
        return "rejected";
    }
  }
}

extension JobApplicationStatusMapperExtension on JobApplicationStatus {
  dynamic toValue() {
    JobApplicationStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<JobApplicationStatus>(this);
  }
}

class UserRecruiterMapper extends ClassMapperBase<UserRecruiter> {
  UserRecruiterMapper._();

  static UserRecruiterMapper? _instance;
  static UserRecruiterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserRecruiterMapper._());
      UserRecruiterTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserRecruiter';

  static String _$id(UserRecruiter v) => v.id;
  static const Field<UserRecruiter, String> _f$id = Field('id', _$id);
  static UserRecruiterType _$type(UserRecruiter v) => v.type;
  static const Field<UserRecruiter, UserRecruiterType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$name(UserRecruiter v) => v.name;
  static const Field<UserRecruiter, String> _f$name = Field('name', _$name);
  static String? _$pictureUrl(UserRecruiter v) => v.pictureUrl;
  static const Field<UserRecruiter, String> _f$pictureUrl = Field(
    'pictureUrl',
    _$pictureUrl,
    key: r'picture_url',
    opt: true,
  );
  static String _$phoneNumber(UserRecruiter v) => v.phoneNumber;
  static const Field<UserRecruiter, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    key: r'phone_number',
  );

  @override
  final MappableFields<UserRecruiter> fields = const {
    #id: _f$id,
    #type: _f$type,
    #name: _f$name,
    #pictureUrl: _f$pictureUrl,
    #phoneNumber: _f$phoneNumber,
  };

  static UserRecruiter _instantiate(DecodingData data) {
    return UserRecruiter(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      name: data.dec(_f$name),
      pictureUrl: data.dec(_f$pictureUrl),
      phoneNumber: data.dec(_f$phoneNumber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserRecruiter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserRecruiter>(map);
  }

  static UserRecruiter fromJson(String json) {
    return ensureInitialized().decodeJson<UserRecruiter>(json);
  }
}

mixin UserRecruiterMappable {
  String toJson() {
    return UserRecruiterMapper.ensureInitialized().encodeJson<UserRecruiter>(
      this as UserRecruiter,
    );
  }

  Map<String, dynamic> toMap() {
    return UserRecruiterMapper.ensureInitialized().encodeMap<UserRecruiter>(
      this as UserRecruiter,
    );
  }

  UserRecruiterCopyWith<UserRecruiter, UserRecruiter, UserRecruiter>
  get copyWith => _UserRecruiterCopyWithImpl<UserRecruiter, UserRecruiter>(
    this as UserRecruiter,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UserRecruiterMapper.ensureInitialized().stringifyValue(
      this as UserRecruiter,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserRecruiterMapper.ensureInitialized().equalsValue(
      this as UserRecruiter,
      other,
    );
  }

  @override
  int get hashCode {
    return UserRecruiterMapper.ensureInitialized().hashValue(
      this as UserRecruiter,
    );
  }
}

extension UserRecruiterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserRecruiter, $Out> {
  UserRecruiterCopyWith<$R, UserRecruiter, $Out> get $asUserRecruiter =>
      $base.as((v, t, t2) => _UserRecruiterCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserRecruiterCopyWith<$R, $In extends UserRecruiter, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    UserRecruiterType? type,
    String? name,
    String? pictureUrl,
    String? phoneNumber,
  });
  UserRecruiterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserRecruiterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserRecruiter, $Out>
    implements UserRecruiterCopyWith<$R, UserRecruiter, $Out> {
  _UserRecruiterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserRecruiter> $mapper =
      UserRecruiterMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    UserRecruiterType? type,
    String? name,
    Object? pictureUrl = $none,
    String? phoneNumber,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (type != null) #type: type,
      if (name != null) #name: name,
      if (pictureUrl != $none) #pictureUrl: pictureUrl,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
    }),
  );
  @override
  UserRecruiter $make(CopyWithData data) => UserRecruiter(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    name: data.get(#name, or: $value.name),
    pictureUrl: data.get(#pictureUrl, or: $value.pictureUrl),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
  );

  @override
  UserRecruiterCopyWith<$R2, UserRecruiter, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserRecruiterCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserJobSeekerMapper extends ClassMapperBase<UserJobSeeker> {
  UserJobSeekerMapper._();

  static UserJobSeekerMapper? _instance;
  static UserJobSeekerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserJobSeekerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserJobSeeker';

  static String _$id(UserJobSeeker v) => v.id;
  static const Field<UserJobSeeker, String> _f$id = Field('id', _$id);
  static String _$pictureUrl(UserJobSeeker v) => v.pictureUrl;
  static const Field<UserJobSeeker, String> _f$pictureUrl = Field(
    'pictureUrl',
    _$pictureUrl,
    key: r'picture_url',
  );
  static DateTime _$birthDate(UserJobSeeker v) => v.birthDate;
  static const Field<UserJobSeeker, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    key: r'birth_date',
  );
  static String _$domisili(UserJobSeeker v) => v.domisili;
  static const Field<UserJobSeeker, String> _f$domisili = Field(
    'domisili',
    _$domisili,
  );
  static String _$name(UserJobSeeker v) => v.name;
  static const Field<UserJobSeeker, String> _f$name = Field('name', _$name);
  static String _$phoneNumber(UserJobSeeker v) => v.phoneNumber;
  static const Field<UserJobSeeker, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    key: r'phone_number',
  );

  @override
  final MappableFields<UserJobSeeker> fields = const {
    #id: _f$id,
    #pictureUrl: _f$pictureUrl,
    #birthDate: _f$birthDate,
    #domisili: _f$domisili,
    #name: _f$name,
    #phoneNumber: _f$phoneNumber,
  };

  static UserJobSeeker _instantiate(DecodingData data) {
    return UserJobSeeker(
      id: data.dec(_f$id),
      pictureUrl: data.dec(_f$pictureUrl),
      birthDate: data.dec(_f$birthDate),
      domisili: data.dec(_f$domisili),
      name: data.dec(_f$name),
      phoneNumber: data.dec(_f$phoneNumber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserJobSeeker fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserJobSeeker>(map);
  }

  static UserJobSeeker fromJson(String json) {
    return ensureInitialized().decodeJson<UserJobSeeker>(json);
  }
}

mixin UserJobSeekerMappable {
  String toJson() {
    return UserJobSeekerMapper.ensureInitialized().encodeJson<UserJobSeeker>(
      this as UserJobSeeker,
    );
  }

  Map<String, dynamic> toMap() {
    return UserJobSeekerMapper.ensureInitialized().encodeMap<UserJobSeeker>(
      this as UserJobSeeker,
    );
  }

  UserJobSeekerCopyWith<UserJobSeeker, UserJobSeeker, UserJobSeeker>
  get copyWith => _UserJobSeekerCopyWithImpl<UserJobSeeker, UserJobSeeker>(
    this as UserJobSeeker,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UserJobSeekerMapper.ensureInitialized().stringifyValue(
      this as UserJobSeeker,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserJobSeekerMapper.ensureInitialized().equalsValue(
      this as UserJobSeeker,
      other,
    );
  }

  @override
  int get hashCode {
    return UserJobSeekerMapper.ensureInitialized().hashValue(
      this as UserJobSeeker,
    );
  }
}

extension UserJobSeekerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserJobSeeker, $Out> {
  UserJobSeekerCopyWith<$R, UserJobSeeker, $Out> get $asUserJobSeeker =>
      $base.as((v, t, t2) => _UserJobSeekerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserJobSeekerCopyWith<$R, $In extends UserJobSeeker, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? pictureUrl,
    DateTime? birthDate,
    String? domisili,
    String? name,
    String? phoneNumber,
  });
  UserJobSeekerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserJobSeekerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserJobSeeker, $Out>
    implements UserJobSeekerCopyWith<$R, UserJobSeeker, $Out> {
  _UserJobSeekerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserJobSeeker> $mapper =
      UserJobSeekerMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? pictureUrl,
    DateTime? birthDate,
    String? domisili,
    String? name,
    String? phoneNumber,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (pictureUrl != null) #pictureUrl: pictureUrl,
      if (birthDate != null) #birthDate: birthDate,
      if (domisili != null) #domisili: domisili,
      if (name != null) #name: name,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
    }),
  );
  @override
  UserJobSeeker $make(CopyWithData data) => UserJobSeeker(
    id: data.get(#id, or: $value.id),
    pictureUrl: data.get(#pictureUrl, or: $value.pictureUrl),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    domisili: data.get(#domisili, or: $value.domisili),
    name: data.get(#name, or: $value.name),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
  );

  @override
  UserJobSeekerCopyWith<$R2, UserJobSeeker, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserJobSeekerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class JobVacancyMapper extends ClassMapperBase<JobVacancy> {
  JobVacancyMapper._();

  static JobVacancyMapper? _instance;
  static JobVacancyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JobVacancyMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'JobVacancy';

  static String _$id(JobVacancy v) => v.id;
  static const Field<JobVacancy, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(JobVacancy v) => v.createdAt;
  static const Field<JobVacancy, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String _$title(JobVacancy v) => v.title;
  static const Field<JobVacancy, String> _f$title = Field('title', _$title);
  static String _$location(JobVacancy v) => v.location;
  static const Field<JobVacancy, String> _f$location = Field(
    'location',
    _$location,
  );
  static String _$description(JobVacancy v) => v.description;
  static const Field<JobVacancy, String> _f$description = Field(
    'description',
    _$description,
  );
  static DateTime _$startDate(JobVacancy v) => v.startDate;
  static const Field<JobVacancy, DateTime> _f$startDate = Field(
    'startDate',
    _$startDate,
    key: r'start_date',
  );
  static DateTime? _$endDate(JobVacancy v) => v.endDate;
  static const Field<JobVacancy, DateTime> _f$endDate = Field(
    'endDate',
    _$endDate,
    key: r'end_date',
  );
  static String _$recruiterId(JobVacancy v) => v.recruiterId;
  static const Field<JobVacancy, String> _f$recruiterId = Field(
    'recruiterId',
    _$recruiterId,
    key: r'recruiter_id',
  );
  static String? _$jobType(JobVacancy v) => v.jobType;
  static const Field<JobVacancy, String> _f$jobType = Field(
    'jobType',
    _$jobType,
    key: r'job_type',
  );
  static String? _$workPolicy(JobVacancy v) => v.workPolicy;
  static const Field<JobVacancy, String> _f$workPolicy = Field(
    'workPolicy',
    _$workPolicy,
    key: r'work_policy',
  );
  static String? _$salary(JobVacancy v) => v.salary;
  static const Field<JobVacancy, String> _f$salary = Field('salary', _$salary);
  static String? _$minAge(JobVacancy v) => v.minAge;
  static const Field<JobVacancy, String> _f$minAge = Field(
    'minAge',
    _$minAge,
    key: r'min_age',
  );
  static String? _$skill(JobVacancy v) => v.skill;
  static const Field<JobVacancy, String> _f$skill = Field('skill', _$skill);
  static String? _$minEducation(JobVacancy v) => v.minEducation;
  static const Field<JobVacancy, String> _f$minEducation = Field(
    'minEducation',
    _$minEducation,
    key: r'min_education',
  );

  @override
  final MappableFields<JobVacancy> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #title: _f$title,
    #location: _f$location,
    #description: _f$description,
    #startDate: _f$startDate,
    #endDate: _f$endDate,
    #recruiterId: _f$recruiterId,
    #jobType: _f$jobType,
    #workPolicy: _f$workPolicy,
    #salary: _f$salary,
    #minAge: _f$minAge,
    #skill: _f$skill,
    #minEducation: _f$minEducation,
  };

  static JobVacancy _instantiate(DecodingData data) {
    return JobVacancy(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      title: data.dec(_f$title),
      location: data.dec(_f$location),
      description: data.dec(_f$description),
      startDate: data.dec(_f$startDate),
      endDate: data.dec(_f$endDate),
      recruiterId: data.dec(_f$recruiterId),
      jobType: data.dec(_f$jobType),
      workPolicy: data.dec(_f$workPolicy),
      salary: data.dec(_f$salary),
      minAge: data.dec(_f$minAge),
      skill: data.dec(_f$skill),
      minEducation: data.dec(_f$minEducation),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JobVacancy fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JobVacancy>(map);
  }

  static JobVacancy fromJson(String json) {
    return ensureInitialized().decodeJson<JobVacancy>(json);
  }
}

mixin JobVacancyMappable {
  String toJson() {
    return JobVacancyMapper.ensureInitialized().encodeJson<JobVacancy>(
      this as JobVacancy,
    );
  }

  Map<String, dynamic> toMap() {
    return JobVacancyMapper.ensureInitialized().encodeMap<JobVacancy>(
      this as JobVacancy,
    );
  }

  JobVacancyCopyWith<JobVacancy, JobVacancy, JobVacancy> get copyWith =>
      _JobVacancyCopyWithImpl<JobVacancy, JobVacancy>(
        this as JobVacancy,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return JobVacancyMapper.ensureInitialized().stringifyValue(
      this as JobVacancy,
    );
  }

  @override
  bool operator ==(Object other) {
    return JobVacancyMapper.ensureInitialized().equalsValue(
      this as JobVacancy,
      other,
    );
  }

  @override
  int get hashCode {
    return JobVacancyMapper.ensureInitialized().hashValue(this as JobVacancy);
  }
}

extension JobVacancyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JobVacancy, $Out> {
  JobVacancyCopyWith<$R, JobVacancy, $Out> get $asJobVacancy =>
      $base.as((v, t, t2) => _JobVacancyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class JobVacancyCopyWith<$R, $In extends JobVacancy, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    DateTime? createdAt,
    String? title,
    String? location,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? recruiterId,
    String? jobType,
    String? workPolicy,
    String? salary,
    String? minAge,
    String? skill,
    String? minEducation,
  });
  JobVacancyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _JobVacancyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JobVacancy, $Out>
    implements JobVacancyCopyWith<$R, JobVacancy, $Out> {
  _JobVacancyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JobVacancy> $mapper =
      JobVacancyMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    String? title,
    String? location,
    String? description,
    DateTime? startDate,
    Object? endDate = $none,
    String? recruiterId,
    Object? jobType = $none,
    Object? workPolicy = $none,
    Object? salary = $none,
    Object? minAge = $none,
    Object? skill = $none,
    Object? minEducation = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (title != null) #title: title,
      if (location != null) #location: location,
      if (description != null) #description: description,
      if (startDate != null) #startDate: startDate,
      if (endDate != $none) #endDate: endDate,
      if (recruiterId != null) #recruiterId: recruiterId,
      if (jobType != $none) #jobType: jobType,
      if (workPolicy != $none) #workPolicy: workPolicy,
      if (salary != $none) #salary: salary,
      if (minAge != $none) #minAge: minAge,
      if (skill != $none) #skill: skill,
      if (minEducation != $none) #minEducation: minEducation,
    }),
  );
  @override
  JobVacancy $make(CopyWithData data) => JobVacancy(
    id: data.get(#id, or: $value.id),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    title: data.get(#title, or: $value.title),
    location: data.get(#location, or: $value.location),
    description: data.get(#description, or: $value.description),
    startDate: data.get(#startDate, or: $value.startDate),
    endDate: data.get(#endDate, or: $value.endDate),
    recruiterId: data.get(#recruiterId, or: $value.recruiterId),
    jobType: data.get(#jobType, or: $value.jobType),
    workPolicy: data.get(#workPolicy, or: $value.workPolicy),
    salary: data.get(#salary, or: $value.salary),
    minAge: data.get(#minAge, or: $value.minAge),
    skill: data.get(#skill, or: $value.skill),
    minEducation: data.get(#minEducation, or: $value.minEducation),
  );

  @override
  JobVacancyCopyWith<$R2, JobVacancy, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JobVacancyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class WorkshopMapper extends ClassMapperBase<Workshop> {
  WorkshopMapper._();

  static WorkshopMapper? _instance;
  static WorkshopMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkshopMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Workshop';

  static String _$id(Workshop v) => v.id;
  static const Field<Workshop, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(Workshop v) => v.createdAt;
  static const Field<Workshop, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String _$title(Workshop v) => v.title;
  static const Field<Workshop, String> _f$title = Field('title', _$title);
  static String _$description(Workshop v) => v.description;
  static const Field<Workshop, String> _f$description = Field(
    'description',
    _$description,
  );
  static String _$formUrl(Workshop v) => v.formUrl;
  static const Field<Workshop, String> _f$formUrl = Field(
    'formUrl',
    _$formUrl,
    key: r'form_url',
  );
  static String _$recruiterId(Workshop v) => v.recruiterId;
  static const Field<Workshop, String> _f$recruiterId = Field(
    'recruiterId',
    _$recruiterId,
    key: r'recruiter_id',
  );
  static String? _$imageUrl(Workshop v) => v.imageUrl;
  static const Field<Workshop, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    key: r'image_url',
    opt: true,
  );

  @override
  final MappableFields<Workshop> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #title: _f$title,
    #description: _f$description,
    #formUrl: _f$formUrl,
    #recruiterId: _f$recruiterId,
    #imageUrl: _f$imageUrl,
  };

  static Workshop _instantiate(DecodingData data) {
    return Workshop(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      formUrl: data.dec(_f$formUrl),
      recruiterId: data.dec(_f$recruiterId),
      imageUrl: data.dec(_f$imageUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Workshop fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Workshop>(map);
  }

  static Workshop fromJson(String json) {
    return ensureInitialized().decodeJson<Workshop>(json);
  }
}

mixin WorkshopMappable {
  String toJson() {
    return WorkshopMapper.ensureInitialized().encodeJson<Workshop>(
      this as Workshop,
    );
  }

  Map<String, dynamic> toMap() {
    return WorkshopMapper.ensureInitialized().encodeMap<Workshop>(
      this as Workshop,
    );
  }

  WorkshopCopyWith<Workshop, Workshop, Workshop> get copyWith =>
      _WorkshopCopyWithImpl<Workshop, Workshop>(
        this as Workshop,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return WorkshopMapper.ensureInitialized().stringifyValue(this as Workshop);
  }

  @override
  bool operator ==(Object other) {
    return WorkshopMapper.ensureInitialized().equalsValue(
      this as Workshop,
      other,
    );
  }

  @override
  int get hashCode {
    return WorkshopMapper.ensureInitialized().hashValue(this as Workshop);
  }
}

extension WorkshopValueCopy<$R, $Out> on ObjectCopyWith<$R, Workshop, $Out> {
  WorkshopCopyWith<$R, Workshop, $Out> get $asWorkshop =>
      $base.as((v, t, t2) => _WorkshopCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WorkshopCopyWith<$R, $In extends Workshop, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    DateTime? createdAt,
    String? title,
    String? description,
    String? formUrl,
    String? recruiterId,
    String? imageUrl,
  });
  WorkshopCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WorkshopCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Workshop, $Out>
    implements WorkshopCopyWith<$R, Workshop, $Out> {
  _WorkshopCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Workshop> $mapper =
      WorkshopMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    String? title,
    String? description,
    String? formUrl,
    String? recruiterId,
    Object? imageUrl = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (formUrl != null) #formUrl: formUrl,
      if (recruiterId != null) #recruiterId: recruiterId,
      if (imageUrl != $none) #imageUrl: imageUrl,
    }),
  );
  @override
  Workshop $make(CopyWithData data) => Workshop(
    id: data.get(#id, or: $value.id),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    formUrl: data.get(#formUrl, or: $value.formUrl),
    recruiterId: data.get(#recruiterId, or: $value.recruiterId),
    imageUrl: data.get(#imageUrl, or: $value.imageUrl),
  );

  @override
  WorkshopCopyWith<$R2, Workshop, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _WorkshopCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class JobApplicationMapper extends ClassMapperBase<JobApplication> {
  JobApplicationMapper._();

  static JobApplicationMapper? _instance;
  static JobApplicationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JobApplicationMapper._());
      JobApplicationStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'JobApplication';

  static String _$id(JobApplication v) => v.id;
  static const Field<JobApplication, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(JobApplication v) => v.createdAt;
  static const Field<JobApplication, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static JobApplicationStatus _$status(JobApplication v) => v.status;
  static const Field<JobApplication, JobApplicationStatus> _f$status = Field(
    'status',
    _$status,
  );
  static String _$jobVacancyId(JobApplication v) => v.jobVacancyId;
  static const Field<JobApplication, String> _f$jobVacancyId = Field(
    'jobVacancyId',
    _$jobVacancyId,
    key: r'job_vacancy_id',
  );
  static String _$jobSeekerId(JobApplication v) => v.jobSeekerId;
  static const Field<JobApplication, String> _f$jobSeekerId = Field(
    'jobSeekerId',
    _$jobSeekerId,
    key: r'job_seeker_id',
  );

  @override
  final MappableFields<JobApplication> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #status: _f$status,
    #jobVacancyId: _f$jobVacancyId,
    #jobSeekerId: _f$jobSeekerId,
  };

  static JobApplication _instantiate(DecodingData data) {
    return JobApplication(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      status: data.dec(_f$status),
      jobVacancyId: data.dec(_f$jobVacancyId),
      jobSeekerId: data.dec(_f$jobSeekerId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JobApplication fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JobApplication>(map);
  }

  static JobApplication fromJson(String json) {
    return ensureInitialized().decodeJson<JobApplication>(json);
  }
}

mixin JobApplicationMappable {
  String toJson() {
    return JobApplicationMapper.ensureInitialized().encodeJson<JobApplication>(
      this as JobApplication,
    );
  }

  Map<String, dynamic> toMap() {
    return JobApplicationMapper.ensureInitialized().encodeMap<JobApplication>(
      this as JobApplication,
    );
  }

  JobApplicationCopyWith<JobApplication, JobApplication, JobApplication>
  get copyWith => _JobApplicationCopyWithImpl<JobApplication, JobApplication>(
    this as JobApplication,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return JobApplicationMapper.ensureInitialized().stringifyValue(
      this as JobApplication,
    );
  }

  @override
  bool operator ==(Object other) {
    return JobApplicationMapper.ensureInitialized().equalsValue(
      this as JobApplication,
      other,
    );
  }

  @override
  int get hashCode {
    return JobApplicationMapper.ensureInitialized().hashValue(
      this as JobApplication,
    );
  }
}

extension JobApplicationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JobApplication, $Out> {
  JobApplicationCopyWith<$R, JobApplication, $Out> get $asJobApplication =>
      $base.as((v, t, t2) => _JobApplicationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class JobApplicationCopyWith<$R, $In extends JobApplication, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    DateTime? createdAt,
    JobApplicationStatus? status,
    String? jobVacancyId,
    String? jobSeekerId,
  });
  JobApplicationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _JobApplicationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JobApplication, $Out>
    implements JobApplicationCopyWith<$R, JobApplication, $Out> {
  _JobApplicationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JobApplication> $mapper =
      JobApplicationMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    JobApplicationStatus? status,
    String? jobVacancyId,
    String? jobSeekerId,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (status != null) #status: status,
      if (jobVacancyId != null) #jobVacancyId: jobVacancyId,
      if (jobSeekerId != null) #jobSeekerId: jobSeekerId,
    }),
  );
  @override
  JobApplication $make(CopyWithData data) => JobApplication(
    id: data.get(#id, or: $value.id),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    status: data.get(#status, or: $value.status),
    jobVacancyId: data.get(#jobVacancyId, or: $value.jobVacancyId),
    jobSeekerId: data.get(#jobSeekerId, or: $value.jobSeekerId),
  );

  @override
  JobApplicationCopyWith<$R2, JobApplication, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JobApplicationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class JobVacancyAdvertiseRequestMapper
    extends ClassMapperBase<JobVacancyAdvertiseRequest> {
  JobVacancyAdvertiseRequestMapper._();

  static JobVacancyAdvertiseRequestMapper? _instance;
  static JobVacancyAdvertiseRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = JobVacancyAdvertiseRequestMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'JobVacancyAdvertiseRequest';

  static String _$id(JobVacancyAdvertiseRequest v) => v.id;
  static const Field<JobVacancyAdvertiseRequest, String> _f$id = Field(
    'id',
    _$id,
  );
  static DateTime _$createdAt(JobVacancyAdvertiseRequest v) => v.createdAt;
  static const Field<JobVacancyAdvertiseRequest, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String _$paymentId(JobVacancyAdvertiseRequest v) => v.paymentId;
  static const Field<JobVacancyAdvertiseRequest, String> _f$paymentId = Field(
    'paymentId',
    _$paymentId,
    key: r'payment_id',
  );
  static bool _$isApproved(JobVacancyAdvertiseRequest v) => v.isApproved;
  static const Field<JobVacancyAdvertiseRequest, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    key: r'is_approved',
  );

  @override
  final MappableFields<JobVacancyAdvertiseRequest> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #paymentId: _f$paymentId,
    #isApproved: _f$isApproved,
  };

  static JobVacancyAdvertiseRequest _instantiate(DecodingData data) {
    return JobVacancyAdvertiseRequest(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      paymentId: data.dec(_f$paymentId),
      isApproved: data.dec(_f$isApproved),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JobVacancyAdvertiseRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JobVacancyAdvertiseRequest>(map);
  }

  static JobVacancyAdvertiseRequest fromJson(String json) {
    return ensureInitialized().decodeJson<JobVacancyAdvertiseRequest>(json);
  }
}

mixin JobVacancyAdvertiseRequestMappable {
  String toJson() {
    return JobVacancyAdvertiseRequestMapper.ensureInitialized()
        .encodeJson<JobVacancyAdvertiseRequest>(
          this as JobVacancyAdvertiseRequest,
        );
  }

  Map<String, dynamic> toMap() {
    return JobVacancyAdvertiseRequestMapper.ensureInitialized()
        .encodeMap<JobVacancyAdvertiseRequest>(
          this as JobVacancyAdvertiseRequest,
        );
  }

  JobVacancyAdvertiseRequestCopyWith<
    JobVacancyAdvertiseRequest,
    JobVacancyAdvertiseRequest,
    JobVacancyAdvertiseRequest
  >
  get copyWith =>
      _JobVacancyAdvertiseRequestCopyWithImpl<
        JobVacancyAdvertiseRequest,
        JobVacancyAdvertiseRequest
      >(this as JobVacancyAdvertiseRequest, $identity, $identity);
  @override
  String toString() {
    return JobVacancyAdvertiseRequestMapper.ensureInitialized().stringifyValue(
      this as JobVacancyAdvertiseRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return JobVacancyAdvertiseRequestMapper.ensureInitialized().equalsValue(
      this as JobVacancyAdvertiseRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return JobVacancyAdvertiseRequestMapper.ensureInitialized().hashValue(
      this as JobVacancyAdvertiseRequest,
    );
  }
}

extension JobVacancyAdvertiseRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JobVacancyAdvertiseRequest, $Out> {
  JobVacancyAdvertiseRequestCopyWith<$R, JobVacancyAdvertiseRequest, $Out>
  get $asJobVacancyAdvertiseRequest => $base.as(
    (v, t, t2) => _JobVacancyAdvertiseRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class JobVacancyAdvertiseRequestCopyWith<
  $R,
  $In extends JobVacancyAdvertiseRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    DateTime? createdAt,
    String? paymentId,
    bool? isApproved,
  });
  JobVacancyAdvertiseRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _JobVacancyAdvertiseRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JobVacancyAdvertiseRequest, $Out>
    implements
        JobVacancyAdvertiseRequestCopyWith<
          $R,
          JobVacancyAdvertiseRequest,
          $Out
        > {
  _JobVacancyAdvertiseRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JobVacancyAdvertiseRequest> $mapper =
      JobVacancyAdvertiseRequestMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    String? paymentId,
    bool? isApproved,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (paymentId != null) #paymentId: paymentId,
      if (isApproved != null) #isApproved: isApproved,
    }),
  );
  @override
  JobVacancyAdvertiseRequest $make(CopyWithData data) =>
      JobVacancyAdvertiseRequest(
        id: data.get(#id, or: $value.id),
        createdAt: data.get(#createdAt, or: $value.createdAt),
        paymentId: data.get(#paymentId, or: $value.paymentId),
        isApproved: data.get(#isApproved, or: $value.isApproved),
      );

  @override
  JobVacancyAdvertiseRequestCopyWith<$R2, JobVacancyAdvertiseRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _JobVacancyAdvertiseRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserJobSeekerMinimalMapper extends ClassMapperBase<UserJobSeekerMinimal> {
  UserJobSeekerMinimalMapper._();

  static UserJobSeekerMinimalMapper? _instance;
  static UserJobSeekerMinimalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserJobSeekerMinimalMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserJobSeekerMinimal';

  static String _$pictureUrl(UserJobSeekerMinimal v) => v.pictureUrl;
  static const Field<UserJobSeekerMinimal, String> _f$pictureUrl = Field(
    'pictureUrl',
    _$pictureUrl,
    key: r'picture_url',
  );
  static String _$name(UserJobSeekerMinimal v) => v.name;
  static const Field<UserJobSeekerMinimal, String> _f$name = Field(
    'name',
    _$name,
  );

  @override
  final MappableFields<UserJobSeekerMinimal> fields = const {
    #pictureUrl: _f$pictureUrl,
    #name: _f$name,
  };

  static UserJobSeekerMinimal _instantiate(DecodingData data) {
    return UserJobSeekerMinimal(
      pictureUrl: data.dec(_f$pictureUrl),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserJobSeekerMinimal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserJobSeekerMinimal>(map);
  }

  static UserJobSeekerMinimal fromJson(String json) {
    return ensureInitialized().decodeJson<UserJobSeekerMinimal>(json);
  }
}

mixin UserJobSeekerMinimalMappable {
  String toJson() {
    return UserJobSeekerMinimalMapper.ensureInitialized()
        .encodeJson<UserJobSeekerMinimal>(this as UserJobSeekerMinimal);
  }

  Map<String, dynamic> toMap() {
    return UserJobSeekerMinimalMapper.ensureInitialized()
        .encodeMap<UserJobSeekerMinimal>(this as UserJobSeekerMinimal);
  }

  UserJobSeekerMinimalCopyWith<
    UserJobSeekerMinimal,
    UserJobSeekerMinimal,
    UserJobSeekerMinimal
  >
  get copyWith =>
      _UserJobSeekerMinimalCopyWithImpl<
        UserJobSeekerMinimal,
        UserJobSeekerMinimal
      >(this as UserJobSeekerMinimal, $identity, $identity);
  @override
  String toString() {
    return UserJobSeekerMinimalMapper.ensureInitialized().stringifyValue(
      this as UserJobSeekerMinimal,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserJobSeekerMinimalMapper.ensureInitialized().equalsValue(
      this as UserJobSeekerMinimal,
      other,
    );
  }

  @override
  int get hashCode {
    return UserJobSeekerMinimalMapper.ensureInitialized().hashValue(
      this as UserJobSeekerMinimal,
    );
  }
}

extension UserJobSeekerMinimalValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserJobSeekerMinimal, $Out> {
  UserJobSeekerMinimalCopyWith<$R, UserJobSeekerMinimal, $Out>
  get $asUserJobSeekerMinimal => $base.as(
    (v, t, t2) => _UserJobSeekerMinimalCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UserJobSeekerMinimalCopyWith<
  $R,
  $In extends UserJobSeekerMinimal,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? pictureUrl, String? name});
  UserJobSeekerMinimalCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserJobSeekerMinimalCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserJobSeekerMinimal, $Out>
    implements UserJobSeekerMinimalCopyWith<$R, UserJobSeekerMinimal, $Out> {
  _UserJobSeekerMinimalCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserJobSeekerMinimal> $mapper =
      UserJobSeekerMinimalMapper.ensureInitialized();
  @override
  $R call({String? pictureUrl, String? name}) => $apply(
    FieldCopyWithData({
      if (pictureUrl != null) #pictureUrl: pictureUrl,
      if (name != null) #name: name,
    }),
  );
  @override
  UserJobSeekerMinimal $make(CopyWithData data) => UserJobSeekerMinimal(
    pictureUrl: data.get(#pictureUrl, or: $value.pictureUrl),
    name: data.get(#name, or: $value.name),
  );

  @override
  UserJobSeekerMinimalCopyWith<$R2, UserJobSeekerMinimal, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserJobSeekerMinimalCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatMapper extends ClassMapperBase<Chat> {
  ChatMapper._();

  static ChatMapper? _instance;
  static ChatMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Chat';

  static String _$id(Chat v) => v.id;
  static const Field<Chat, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(Chat v) => v.createdAt;
  static const Field<Chat, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String _$jobSeekerId(Chat v) => v.jobSeekerId;
  static const Field<Chat, String> _f$jobSeekerId = Field(
    'jobSeekerId',
    _$jobSeekerId,
    key: r'job_seeker_id',
  );
  static String _$jobVacancyId(Chat v) => v.jobVacancyId;
  static const Field<Chat, String> _f$jobVacancyId = Field(
    'jobVacancyId',
    _$jobVacancyId,
    key: r'job_vacancy_id',
  );
  static String _$message(Chat v) => v.message;
  static const Field<Chat, String> _f$message = Field('message', _$message);
  static bool _$isRecruiter(Chat v) => v.isRecruiter;
  static const Field<Chat, bool> _f$isRecruiter = Field(
    'isRecruiter',
    _$isRecruiter,
    key: r'is_recruiter',
  );

  @override
  final MappableFields<Chat> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #jobSeekerId: _f$jobSeekerId,
    #jobVacancyId: _f$jobVacancyId,
    #message: _f$message,
    #isRecruiter: _f$isRecruiter,
  };

  static Chat _instantiate(DecodingData data) {
    return Chat(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      jobSeekerId: data.dec(_f$jobSeekerId),
      jobVacancyId: data.dec(_f$jobVacancyId),
      message: data.dec(_f$message),
      isRecruiter: data.dec(_f$isRecruiter),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Chat fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Chat>(map);
  }

  static Chat fromJson(String json) {
    return ensureInitialized().decodeJson<Chat>(json);
  }
}

mixin ChatMappable {
  String toJson() {
    return ChatMapper.ensureInitialized().encodeJson<Chat>(this as Chat);
  }

  Map<String, dynamic> toMap() {
    return ChatMapper.ensureInitialized().encodeMap<Chat>(this as Chat);
  }

  ChatCopyWith<Chat, Chat, Chat> get copyWith =>
      _ChatCopyWithImpl<Chat, Chat>(this as Chat, $identity, $identity);
  @override
  String toString() {
    return ChatMapper.ensureInitialized().stringifyValue(this as Chat);
  }

  @override
  bool operator ==(Object other) {
    return ChatMapper.ensureInitialized().equalsValue(this as Chat, other);
  }

  @override
  int get hashCode {
    return ChatMapper.ensureInitialized().hashValue(this as Chat);
  }
}

extension ChatValueCopy<$R, $Out> on ObjectCopyWith<$R, Chat, $Out> {
  ChatCopyWith<$R, Chat, $Out> get $asChat =>
      $base.as((v, t, t2) => _ChatCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatCopyWith<$R, $In extends Chat, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    DateTime? createdAt,
    String? jobSeekerId,
    String? jobVacancyId,
    String? message,
    bool? isRecruiter,
  });
  ChatCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Chat, $Out>
    implements ChatCopyWith<$R, Chat, $Out> {
  _ChatCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Chat> $mapper = ChatMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    String? jobSeekerId,
    String? jobVacancyId,
    String? message,
    bool? isRecruiter,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (jobSeekerId != null) #jobSeekerId: jobSeekerId,
      if (jobVacancyId != null) #jobVacancyId: jobVacancyId,
      if (message != null) #message: message,
      if (isRecruiter != null) #isRecruiter: isRecruiter,
    }),
  );
  @override
  Chat $make(CopyWithData data) => Chat(
    id: data.get(#id, or: $value.id),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    jobSeekerId: data.get(#jobSeekerId, or: $value.jobSeekerId),
    jobVacancyId: data.get(#jobVacancyId, or: $value.jobVacancyId),
    message: data.get(#message, or: $value.message),
    isRecruiter: data.get(#isRecruiter, or: $value.isRecruiter),
  );

  @override
  ChatCopyWith<$R2, Chat, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ChatCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class JobVacancyMinimalMapper extends ClassMapperBase<JobVacancyMinimal> {
  JobVacancyMinimalMapper._();

  static JobVacancyMinimalMapper? _instance;
  static JobVacancyMinimalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JobVacancyMinimalMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'JobVacancyMinimal';

  static String _$title(JobVacancyMinimal v) => v.title;
  static const Field<JobVacancyMinimal, String> _f$title = Field(
    'title',
    _$title,
  );

  @override
  final MappableFields<JobVacancyMinimal> fields = const {#title: _f$title};

  static JobVacancyMinimal _instantiate(DecodingData data) {
    return JobVacancyMinimal(title: data.dec(_f$title));
  }

  @override
  final Function instantiate = _instantiate;

  static JobVacancyMinimal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JobVacancyMinimal>(map);
  }

  static JobVacancyMinimal fromJson(String json) {
    return ensureInitialized().decodeJson<JobVacancyMinimal>(json);
  }
}

mixin JobVacancyMinimalMappable {
  String toJson() {
    return JobVacancyMinimalMapper.ensureInitialized()
        .encodeJson<JobVacancyMinimal>(this as JobVacancyMinimal);
  }

  Map<String, dynamic> toMap() {
    return JobVacancyMinimalMapper.ensureInitialized()
        .encodeMap<JobVacancyMinimal>(this as JobVacancyMinimal);
  }

  JobVacancyMinimalCopyWith<
    JobVacancyMinimal,
    JobVacancyMinimal,
    JobVacancyMinimal
  >
  get copyWith =>
      _JobVacancyMinimalCopyWithImpl<JobVacancyMinimal, JobVacancyMinimal>(
        this as JobVacancyMinimal,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return JobVacancyMinimalMapper.ensureInitialized().stringifyValue(
      this as JobVacancyMinimal,
    );
  }

  @override
  bool operator ==(Object other) {
    return JobVacancyMinimalMapper.ensureInitialized().equalsValue(
      this as JobVacancyMinimal,
      other,
    );
  }

  @override
  int get hashCode {
    return JobVacancyMinimalMapper.ensureInitialized().hashValue(
      this as JobVacancyMinimal,
    );
  }
}

extension JobVacancyMinimalValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JobVacancyMinimal, $Out> {
  JobVacancyMinimalCopyWith<$R, JobVacancyMinimal, $Out>
  get $asJobVacancyMinimal => $base.as(
    (v, t, t2) => _JobVacancyMinimalCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class JobVacancyMinimalCopyWith<
  $R,
  $In extends JobVacancyMinimal,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? title});
  JobVacancyMinimalCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _JobVacancyMinimalCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JobVacancyMinimal, $Out>
    implements JobVacancyMinimalCopyWith<$R, JobVacancyMinimal, $Out> {
  _JobVacancyMinimalCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JobVacancyMinimal> $mapper =
      JobVacancyMinimalMapper.ensureInitialized();
  @override
  $R call({String? title}) =>
      $apply(FieldCopyWithData({if (title != null) #title: title}));
  @override
  JobVacancyMinimal $make(CopyWithData data) =>
      JobVacancyMinimal(title: data.get(#title, or: $value.title));

  @override
  JobVacancyMinimalCopyWith<$R2, JobVacancyMinimal, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JobVacancyMinimalCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserRecruiterMinimalMapper extends ClassMapperBase<UserRecruiterMinimal> {
  UserRecruiterMinimalMapper._();

  static UserRecruiterMinimalMapper? _instance;
  static UserRecruiterMinimalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserRecruiterMinimalMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserRecruiterMinimal';

  static String _$name(UserRecruiterMinimal v) => v.name;
  static const Field<UserRecruiterMinimal, String> _f$name = Field(
    'name',
    _$name,
  );
  static String? _$pictureUrl(UserRecruiterMinimal v) => v.pictureUrl;
  static const Field<UserRecruiterMinimal, String> _f$pictureUrl = Field(
    'pictureUrl',
    _$pictureUrl,
    key: r'picture_url',
  );

  @override
  final MappableFields<UserRecruiterMinimal> fields = const {
    #name: _f$name,
    #pictureUrl: _f$pictureUrl,
  };

  static UserRecruiterMinimal _instantiate(DecodingData data) {
    return UserRecruiterMinimal(
      name: data.dec(_f$name),
      pictureUrl: data.dec(_f$pictureUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserRecruiterMinimal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserRecruiterMinimal>(map);
  }

  static UserRecruiterMinimal fromJson(String json) {
    return ensureInitialized().decodeJson<UserRecruiterMinimal>(json);
  }
}

mixin UserRecruiterMinimalMappable {
  String toJson() {
    return UserRecruiterMinimalMapper.ensureInitialized()
        .encodeJson<UserRecruiterMinimal>(this as UserRecruiterMinimal);
  }

  Map<String, dynamic> toMap() {
    return UserRecruiterMinimalMapper.ensureInitialized()
        .encodeMap<UserRecruiterMinimal>(this as UserRecruiterMinimal);
  }

  UserRecruiterMinimalCopyWith<
    UserRecruiterMinimal,
    UserRecruiterMinimal,
    UserRecruiterMinimal
  >
  get copyWith =>
      _UserRecruiterMinimalCopyWithImpl<
        UserRecruiterMinimal,
        UserRecruiterMinimal
      >(this as UserRecruiterMinimal, $identity, $identity);
  @override
  String toString() {
    return UserRecruiterMinimalMapper.ensureInitialized().stringifyValue(
      this as UserRecruiterMinimal,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserRecruiterMinimalMapper.ensureInitialized().equalsValue(
      this as UserRecruiterMinimal,
      other,
    );
  }

  @override
  int get hashCode {
    return UserRecruiterMinimalMapper.ensureInitialized().hashValue(
      this as UserRecruiterMinimal,
    );
  }
}

extension UserRecruiterMinimalValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserRecruiterMinimal, $Out> {
  UserRecruiterMinimalCopyWith<$R, UserRecruiterMinimal, $Out>
  get $asUserRecruiterMinimal => $base.as(
    (v, t, t2) => _UserRecruiterMinimalCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UserRecruiterMinimalCopyWith<
  $R,
  $In extends UserRecruiterMinimal,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? pictureUrl});
  UserRecruiterMinimalCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserRecruiterMinimalCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserRecruiterMinimal, $Out>
    implements UserRecruiterMinimalCopyWith<$R, UserRecruiterMinimal, $Out> {
  _UserRecruiterMinimalCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserRecruiterMinimal> $mapper =
      UserRecruiterMinimalMapper.ensureInitialized();
  @override
  $R call({String? name, Object? pictureUrl = $none}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (pictureUrl != $none) #pictureUrl: pictureUrl,
    }),
  );
  @override
  UserRecruiterMinimal $make(CopyWithData data) => UserRecruiterMinimal(
    name: data.get(#name, or: $value.name),
    pictureUrl: data.get(#pictureUrl, or: $value.pictureUrl),
  );

  @override
  UserRecruiterMinimalCopyWith<$R2, UserRecruiterMinimal, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserRecruiterMinimalCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

