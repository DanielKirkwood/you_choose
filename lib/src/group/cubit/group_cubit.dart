import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this._firestoreRepository) : super(const GroupState());

  final FirestoreRepository _firestoreRepository;

  Future<void> loadGroups(String uid) async {
    emit(state.copyWith(status: GroupStatus.loading));

    List<Group> groups = await _firestoreRepository.getUserGroupData(uid);

    emit(state.copyWith(status: GroupStatus.success, groups: groups));
  }

  Future<void> addGroup(String uid) async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));
    try {
      List<String> membersList = [];

      for (var element in state.members.value.split(',')) {
        membersList.add(element.trim());
      }

      Group group =
          Group(id: "", name: state.name.value, members: [...membersList, uid]);

      Group addedGroup = await _firestoreRepository.addGroup(group);
      if (addedGroup.id != "") {
        emit(state.copyWith(
            formStatus: FormzStatus.submissionSuccess,
            groups: [addedGroup, ...state.groups]));
      }
    } catch (_) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }

  void nameChanged(String value) {
    final name = GroupName.dirty(value);
    emit(state.copyWith(
      name: name,
      formStatus: Formz.validate([name, state.members]),
    ));
  }

  void membersChanged(String value) {
    final members = GroupMembers.dirty(value);
    emit(state.copyWith(
      members: members,
      formStatus: Formz.validate([state.name, members]),
    ));
  }
}
