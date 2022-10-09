import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this._firestoreRepository) : super(const GroupState());

  final FirestoreRepository _firestoreRepository;

  Future<void> loadGroups(String uid) async {
    emit(state.copyWith(status: GroupStatus.loading));

    List<Group> groups = await _firestoreRepository.getUserGroupData(uid);

    emit(state.copyWith(status: GroupStatus.success, groups: groups));
  }

  Future<void> addGroup(Group group, String uid) async {
    emit(state.copyWith(status: GroupStatus.loading));

    Group addedGroup = await _firestoreRepository.addGroup(group);

    if (addedGroup.id != "") {
      emit(state.copyWith(
          status: GroupStatus.success, groups: [...state.groups, addedGroup]));
    } else {
      emit(state.copyWith(status: GroupStatus.failure));
    }
  }
}
