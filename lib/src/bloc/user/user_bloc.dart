import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/models/user.dart';
import 'package:you_choose/src/services/database/database_repository_impl.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseRepository _databaseRepository;

  UserBloc(this._databaseRepository) : super(UserInitial()) {
    on<UserFetched>(_fetchUserData);
  }

  _fetchUserData(UserFetched event, Emitter<UserState> emit) async {
    List<UserModel?> userList = await _databaseRepository.retrieveUserData();

    emit(UserSuccess(userList, event.username));
  }
}
