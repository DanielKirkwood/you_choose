import 'package:you_choose/src/models/user.dart';
import 'package:you_choose/src/util/logger/logger.dart';

import 'database_service.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  DatabaseService service = DatabaseService();
  var logger = getLogger('DatabaseRepositoryImpl');

  @override
  Future<void> saveUserData(UserModel user) {
    logger.i('saveUserData');
    return service.addUserData(user);
  }

  @override
  Future<List<UserModel?>> retrieveUserData() {
    logger.i('retrieveUserData');
    return service.retrieveUserData();
  }
}

abstract class DatabaseRepository {
  Future<void> saveUserData(UserModel user);
  Future<List<UserModel?>> retrieveUserData();
}
