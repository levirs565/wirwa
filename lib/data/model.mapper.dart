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

  @override
  final MappableFields<UserRecruiter> fields = const {
    #id: _f$id,
    #type: _f$type,
    #name: _f$name,
  };

  static UserRecruiter _instantiate(DecodingData data) {
    return UserRecruiter(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      name: data.dec(_f$name),
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
  $R call({String? id, UserRecruiterType? type, String? name});
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
  $R call({String? id, UserRecruiterType? type, String? name}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (type != null) #type: type,
      if (name != null) #name: name,
    }),
  );
  @override
  UserRecruiter $make(CopyWithData data) => UserRecruiter(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    name: data.get(#name, or: $value.name),
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

  @override
  final MappableFields<Workshop> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #title: _f$title,
    #description: _f$description,
    #formUrl: _f$formUrl,
    #recruiterId: _f$recruiterId,
  };

  static Workshop _instantiate(DecodingData data) {
    return Workshop(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      formUrl: data.dec(_f$formUrl),
      recruiterId: data.dec(_f$recruiterId),
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
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (formUrl != null) #formUrl: formUrl,
      if (recruiterId != null) #recruiterId: recruiterId,
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

