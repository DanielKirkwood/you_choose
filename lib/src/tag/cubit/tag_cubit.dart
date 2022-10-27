import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:models/models.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit(this._groupRepository) : super(const TagState());

  final GroupRepository _groupRepository;

  Future<void> loadTags({required String groupID}) async {
    emit(state.copyWith(status: TagStatus.loading));

    try {
      final tags = await _groupRepository.getGroupTags(groupID: groupID);

      emit(state.copyWith(status: TagStatus.success, tags: tags));
    } catch (_) {
      emit(state.copyWith(status: TagStatus.failure));
    }
  }

  Future<void> addTag({required String groupID}) async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));
    try {
      final newTag = Tag(name: state.name.value);

      final addedTag =
          await _groupRepository.addGroupTag(groupID: groupID, tag: newTag);

      if (addedTag.id != null) {
        emit(state.copyWith(
            formStatus: FormzStatus.submissionSuccess,
            tags: [addedTag, ...state.tags],
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }

  void nameChanged(String value) {
    final name = TagName.dirty(value: value);
    emit(state.copyWith(
      name: name,
      formStatus: Formz.validate([name]),
      ),
    );
  }

  void groupsChanged(List<Group> value) {
    final groups = GroupsList.dirty(value: value);
    emit(state.copyWith(
      groups: groups,
      formStatus: Formz.validate([state.name, groups]),
      ),
    );
  }
}
