import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit(this._firestoreRepository, this._groupID) : super(const TagState());

  final FirestoreRepository _firestoreRepository;
  final String _groupID;

  Future<void> loadTags() async {
    emit(state.copyWith(status: TagStatus.loading));

    try {
      List<Tag> tags =
          await _firestoreRepository.getGroupTags(groupID: _groupID);

      emit(state.copyWith(status: TagStatus.success, tags: tags));
    } catch (_) {
      emit(state.copyWith(status: TagStatus.failure));
    }
  }

  Future<void> addTag() async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));
    try {
      Tag newTag = Tag(name: state.name.value);

      Tag addedTag =
          await _firestoreRepository.addGroupTag(
          groupID: _groupID, tag: newTag);

      if (addedTag.id != null) {
        emit(state.copyWith(
            formStatus: FormzStatus.submissionSuccess,
            tags: [addedTag, ...state.tags]));
      }
    } catch (_) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }
}
