import 'package:maqueta/core/resources/data_state.dart';
import 'package:maqueta/features/auth/data/models/auth.dart';
import 'package:maqueta/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<DataState<AuthModel>> authenticateUser() {
    
    throw UnimplementedError();
  }
}