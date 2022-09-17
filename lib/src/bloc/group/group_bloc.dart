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
      : super(GroupLoading()) {
    on<GroupEvent>((event, emit) async {
      if (event is LoadGroups) {
        print('event LoadGroups');
        UserModel user = await _authenticationRepository.getCurrentUser().first;

        String? username = await _authenticationRepository.getUsername(user);

        if (username != null) {
          print('getting groups with username: $username');
          List<Group> groups = await _dbRepository.getUserGroupData(username);

          emit(GroupLoaded(groups: groups));
        } else {
          emit(const GroupError());
        }
      } else if (event is AddGroup) {
        try {
          Group updatedGroup = await _dbRepository.addGroup(event.newGroup);
          if (updatedGroup.id != null) {
            emit(GroupLoaded(groups: [updatedGroup]));
          } else {
            emit(GroupError(errorGroup: event.newGroup));
          }
        } catch (e) {
          emit(GroupError(errorGroup: event.newGroup));
        }
      }
    });
  }
}
