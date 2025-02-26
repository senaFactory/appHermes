import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? document;
  final Map<String, String> roles;

  const AuthEntity(this.document, this.roles);
  
  @override  
  List<Object?> get props {
    return[
      document,
      roles
    ];
  }
}
