import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit(this._firestoreRepository) : super(const TagState());

  final FirestoreRepository _firestoreRepository;

  Future<void> loadTags(String groupID) async {
    emit(state.copyWith(status: TagStatus.loading));

    try {
      List<Tag> tags =
          await _firestoreRepository.getGroupTags(groupID: groupID);

      emit(state.copyWith(status: TagStatus.success, tags: tags));
    } catch (_) {
      emit(state.copyWith(status: TagStatus.failure));
    }
  }

  Future<void> addTag(String groupID) async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));
    try {
      Tag newTag = Tag(name: state.name.value);

      Tag addedTag =
          await _firestoreRepository.addGroupTag(groupID: groupID, tag: newTag);

      if (addedTag.id != null) {
        emit(state.copyWith(
            formStatus: FormzStatus.submissionSuccess,
            tags: [addedTag, ...state.tags]));
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
    ));
  }

  void groupsChanged(List<Group> value) {
    final groups = GroupsList.dirty(value: value);
    emit(state.copyWith(
      groups: groups,
      formStatus: Formz.validate([state.name, groups]),
    ));
  }
}
