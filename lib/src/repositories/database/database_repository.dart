import 'package:you_choose/src/models/models.dart';

abstract class DatabaseRepository {
  Future<void> addUserData(UserModel user);
  Future<List<UserModel?>> getUserData();
  Future<UserModel> getUser({required String email});
  Future<List<Restaurant>> getRestaurantData(String groupID);
  Future<List<Group?>> getUserGroupData(String uid);
  Future<Group> addGroup(Group group);
  Future<void> addRestaurant(Restaurant restaurant, List<Group> groups);
}
