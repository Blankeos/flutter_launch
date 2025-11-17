import 'package:dart_mappable/dart_mappable.dart';

part 'user_response.model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class UserResponse with UserResponseMappable {
  final String id;
  final String email;
  final bool emailVerified;
  final DateTime joinedAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;
  final String? activeOrganizationId;

  UserResponse({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.joinedAt,
    required this.updatedAt,
    required this.metadata,
    required this.activeOrganizationId,
  });

  static final fromMap = UserResponseMapper.fromMap;
  static final fromJson = UserResponseMapper.fromJson;
}
