// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_response.model.dart';

class UserResponseMapper extends ClassMapperBase<UserResponse> {
  UserResponseMapper._();

  static UserResponseMapper? _instance;
  static UserResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserResponse';

  static String _$id(UserResponse v) => v.id;
  static const Field<UserResponse, String> _f$id = Field('id', _$id);
  static String _$email(UserResponse v) => v.email;
  static const Field<UserResponse, String> _f$email = Field('email', _$email);
  static bool _$emailVerified(UserResponse v) => v.emailVerified;
  static const Field<UserResponse, bool> _f$emailVerified = Field(
    'emailVerified',
    _$emailVerified,
    key: r'email_verified',
  );
  static DateTime _$joinedAt(UserResponse v) => v.joinedAt;
  static const Field<UserResponse, DateTime> _f$joinedAt = Field(
    'joinedAt',
    _$joinedAt,
    key: r'joined_at',
  );
  static DateTime _$updatedAt(UserResponse v) => v.updatedAt;
  static const Field<UserResponse, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static Map<String, dynamic> _$metadata(UserResponse v) => v.metadata;
  static const Field<UserResponse, Map<String, dynamic>> _f$metadata = Field(
    'metadata',
    _$metadata,
  );
  static String? _$activeOrganizationId(UserResponse v) =>
      v.activeOrganizationId;
  static const Field<UserResponse, String> _f$activeOrganizationId = Field(
    'activeOrganizationId',
    _$activeOrganizationId,
    key: r'active_organization_id',
  );

  @override
  final MappableFields<UserResponse> fields = const {
    #id: _f$id,
    #email: _f$email,
    #emailVerified: _f$emailVerified,
    #joinedAt: _f$joinedAt,
    #updatedAt: _f$updatedAt,
    #metadata: _f$metadata,
    #activeOrganizationId: _f$activeOrganizationId,
  };

  static UserResponse _instantiate(DecodingData data) {
    return UserResponse(
      id: data.dec(_f$id),
      email: data.dec(_f$email),
      emailVerified: data.dec(_f$emailVerified),
      joinedAt: data.dec(_f$joinedAt),
      updatedAt: data.dec(_f$updatedAt),
      metadata: data.dec(_f$metadata),
      activeOrganizationId: data.dec(_f$activeOrganizationId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserResponse>(map);
  }

  static UserResponse fromJson(String json) {
    return ensureInitialized().decodeJson<UserResponse>(json);
  }
}

mixin UserResponseMappable {
  String toJson() {
    return UserResponseMapper.ensureInitialized().encodeJson<UserResponse>(
      this as UserResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return UserResponseMapper.ensureInitialized().encodeMap<UserResponse>(
      this as UserResponse,
    );
  }

  UserResponseCopyWith<UserResponse, UserResponse, UserResponse> get copyWith =>
      _UserResponseCopyWithImpl<UserResponse, UserResponse>(
        this as UserResponse,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserResponseMapper.ensureInitialized().stringifyValue(
      this as UserResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserResponseMapper.ensureInitialized().equalsValue(
      this as UserResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return UserResponseMapper.ensureInitialized().hashValue(
      this as UserResponse,
    );
  }
}

extension UserResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserResponse, $Out> {
  UserResponseCopyWith<$R, UserResponse, $Out> get $asUserResponse =>
      $base.as((v, t, t2) => _UserResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserResponseCopyWith<$R, $In extends UserResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata;
  $R call({
    String? id,
    String? email,
    bool? emailVerified,
    DateTime? joinedAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    String? activeOrganizationId,
  });
  UserResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserResponse, $Out>
    implements UserResponseCopyWith<$R, UserResponse, $Out> {
  _UserResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserResponse> $mapper =
      UserResponseMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get metadata => MapCopyWith(
    $value.metadata,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(metadata: v),
  );
  @override
  $R call({
    String? id,
    String? email,
    bool? emailVerified,
    DateTime? joinedAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    Object? activeOrganizationId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (email != null) #email: email,
      if (emailVerified != null) #emailVerified: emailVerified,
      if (joinedAt != null) #joinedAt: joinedAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (metadata != null) #metadata: metadata,
      if (activeOrganizationId != $none)
        #activeOrganizationId: activeOrganizationId,
    }),
  );
  @override
  UserResponse $make(CopyWithData data) => UserResponse(
    id: data.get(#id, or: $value.id),
    email: data.get(#email, or: $value.email),
    emailVerified: data.get(#emailVerified, or: $value.emailVerified),
    joinedAt: data.get(#joinedAt, or: $value.joinedAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    metadata: data.get(#metadata, or: $value.metadata),
    activeOrganizationId: data.get(
      #activeOrganizationId,
      or: $value.activeOrganizationId,
    ),
  );

  @override
  UserResponseCopyWith<$R2, UserResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

