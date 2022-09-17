import 'package:you_choose/src/models/models.dart';

abstract class DatabaseRepository {
  Future<void> addUserData(UserModel user);
  Future<List<UserModel?>> getUserData();
  Future<UserModel?> getUser(UserModel user);
  Future<List<Restaurant?>> getRestaurantData();
  Future<List<Group?>> getUserGroupData(String uid);
  Future<Group> addGroup(Group group);
}
