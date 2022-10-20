import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._firestoreRepository) : super(const FriendsState());

  final FirestoreRepository _firestoreRepository;

  Future<void> sendFriendRequest(
      {required String userID}) async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));

    try {
      await _firestoreRepository.sendFriendRequest(
          friendUsername: state.username.value, userID: userID);

      emit(state.copyWith(formStatus: FormzStatus.submissionSuccess));
    } catch (error) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }

  Future<void> acceptFriendRequest(
      {required String userID, required String friendID}) async {
    emit(state.copyWith(status: FriendStatus.loading));

    try {
      await _firestoreRepository.acceptFriendRequest(
          friendID: friendID, userID: userID);

      emit(state.copyWith(status: FriendStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendStatus.failure));
    }
  }

  Future<void> declineFriendRequest(
      {required String userID, required String friendID}) async {
    emit(state.copyWith(status: FriendStatus.loading));

    try {
      await _firestoreRepository.declineFriendRequest(
          friendID: friendID, userID: userID);

      emit(state.copyWith(status: FriendStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendStatus.failure));
    }
  }

  Future<void> removeFriend(
      {required String userID, required String friendID}) async {
    emit(state.copyWith(status: FriendStatus.loading));

    try {
      await _firestoreRepository.removeFriend(
          friendID: friendID, userID: userID);

      emit(state.copyWith(status: FriendStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendStatus.failure));
    }
  }

  void usernameChanged(String value) {
    final username = Username.dirty(value: value);
    emit(state.copyWith(
        username: username, formStatus: Formz.validate([username])));
  }
}
