import 'package:maqueta/features/auth/domain/entities/auth.dart';

class AuthModel extends AuthEntity {
  const AuthModel(super.document, super.roles);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      json['document'] ?? "",
      json['roles'] ?? "",
    );
  }
}
