import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._friendRepository) : super(const FriendsState());

  final FriendRepository _friendRepository;

  Future<void> sendFriendRequest(
      {
    required String username,
  }) async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));

    try {
      await _friendRepository.sendFriendRequest(
        friendUsername: state.username.value,
        currentUserUsername: username,
      );

      emit(state.copyWith(formStatus: FormzStatus.submissionSuccess));
    } catch (error) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }

  Future<void> acceptFriendRequest(
      {
    required String username,
    required String friendUsername,
  }) async {
    emit(state.copyWith(status: FriendStatus.loading));

    try {
      await _friendRepository.acceptFriendRequest(
        friendUsername: friendUsername,
        currentUserUsername: username,
      );

      emit(state.copyWith(status: FriendStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendStatus.failure));
    }
  }

  Future<void> removeFriend(
      {
    required String username,
    required String friendUsername,
  }) async {
    emit(state.copyWith(status: FriendStatus.loading));

    try {
      await _friendRepository.removeFriend(
        friendUsername: friendUsername,
        currentUserUsername: username,
      );

      emit(state.copyWith(status: FriendStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FriendStatus.failure));
    }
  }

  void usernameChanged(String value) {
    final username = Username.dirty(value: value);
    emit(state.copyWith(
        username: username,
        formStatus: Formz.validate([username]),
      ),
    );
  }
}
