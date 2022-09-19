import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/repositories/repositories.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final FirestoreRepository _dbRepository;
  final FirebaseAuthRepository _authenticationRepository;


  GroupBloc(this._dbRepository, this._authenticationRepository)
      : super(GroupInitial()) {
    on<LoadGroups>(_onLoadedGroups);
    on<AddGroup>(_onAddGroups);
  }

  _onLoadedGroups(LoadGroups event, Emitter emit) async {
    UserModel user = await _authenticationRepository.getCurrentUser().first;

    if (user.uid != 'uid') {
      List<Group> groups = await _dbRepository.getUserGroupData(user.uid!);

      emit(GroupLoaded(groups: groups));
    } else {
      emit(const GroupError());

    }

  }

  _onAddGroups(AddGroup event, Emitter emit) async {
    try {
      Group updatedGroup = await _dbRepository.addGroup(event.newGroup);
      if (updatedGroup.id != null) {
        emit(GroupAdded(newGroup: updatedGroup));
      } else {
        emit(GroupError(errorGroup: event.newGroup));
      }
    } catch (e) {
      emit(GroupError(errorGroup: event.newGroup));
    }
  }
}
