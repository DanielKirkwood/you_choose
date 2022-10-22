import 'package:you_choose/src/data/data.dart';

abstract class DatabaseRepository {
  Future<void> addUserData(UserModel user);
  Future<UserModel> getUser({required String email});
  Future<List<Restaurant>> getRestaurantData(String groupID);
  Future<List<Group?>> getUserGroupData(String uid);
  Future<Group> addGroup(Group group);
  Future<void> addRestaurant(
      {required Restaurant restaurant, required List<Group> groups});
}
