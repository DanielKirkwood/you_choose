import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/repositories/repositories.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._firestoreRepository)
      : super(const FriendsState(
            friends: [],
            friendRequests: [],
            status: FriendCubitStatus.initial));

  final FirestoreRepository _firestoreRepository;

  Future<void> sendFriendRequest(String userID, String friendID) async {
    emit(state.copyWith(status: FriendCubitStatus.loading));

    try {
      await _firestoreRepository.sendFriendRequest(
          friendID: friendID, userID: userID);

      emit(state.copyWith(status: FriendCubitStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendCubitStatus.failure));
    }
  }

  Future<void> acceptFriendRequest(String userID, String friendID) async {
    emit(state.copyWith(status: FriendCubitStatus.loading));

    try {
      await _firestoreRepository.acceptFriendRequest(
          friendID: friendID, userID: userID);

      emit(state.copyWith(status: FriendCubitStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendCubitStatus.failure));
    }
  }

  Future<void> declineFriendRequest(String userID, String friendID) async {
    emit(state.copyWith(status: FriendCubitStatus.loading));

    try {
      await _firestoreRepository.declineFriendRequest(
          friendID: friendID, userID: userID);

      emit(state.copyWith(status: FriendCubitStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendCubitStatus.failure));
    }
  }
}
