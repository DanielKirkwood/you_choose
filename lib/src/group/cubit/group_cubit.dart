import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:models/models.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this._groupRepository) : super(const GroupState());

  final GroupRepository _groupRepository;

  Future<void> loadGroups({required String username}) async {
    emit(state.copyWith(status: GroupStatus.loading));

    final groups = await _groupRepository.getGroups(username: username);

    emit(state.copyWith(status: GroupStatus.success, groups: groups));
  }

  Future<void> addGroup({required String username}) async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));
    try {
      final membersList = <String>[];

      for (final element in state.members.value.split(',')) {
        membersList.add(element.trim());
      }

      final group =
          Group(name: state.name.value, members: [...membersList, username]);

      final addedGroup = await _groupRepository.addGroup(group: group);

      emit(
        state.copyWith(
            formStatus: FormzStatus.submissionSuccess,
          groups: [addedGroup, ...state.groups],
        ),
      );

    } catch (_) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }

  void nameChanged(String value) {
    final name = GroupName.dirty(value: value);
    emit(state.copyWith(
      name: name,
      formStatus: Formz.validate([name, state.members]),
      ),
    );
  }

  void membersChanged(String value) {
    final members = GroupMembers.dirty(value: value);
    emit(state.copyWith(
      members: members,
      formStatus: Formz.validate([state.name, members]),
      ),
    );
  }
}
