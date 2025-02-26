import 'package:maqueta/core/resources/data_state.dart';
import 'package:maqueta/features/auth/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<DataState<AuthEntity>> authenticateUser();
}
