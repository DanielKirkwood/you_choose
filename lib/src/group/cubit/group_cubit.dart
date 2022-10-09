import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this._firestoreRepository) : super(const GroupState());

  final FirestoreRepository _firestoreRepository;

  Future<void> loadGroups(String uid) async {
    List<Group> groups = await _firestoreRepository.getUserGroupData(uid);

    emit(state.copyWith(groups: groups));
  }

  Future<void> addGroup(Group group, String uid) async {
    Group addedGroup = await _firestoreRepository.addGroup(group);

    if (addedGroup.id != null) {
      emit(state.copyWith(groups: [...state.groups, addedGroup]));
    }
  }
}
