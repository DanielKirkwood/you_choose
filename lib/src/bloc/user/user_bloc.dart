import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreRepository _databaseRepository;

  UserBloc(this._databaseRepository) : super(UserInitial()) {
    on<UserFetched>(_fetchUserData);
  }

  _fetchUserData(UserFetched event, Emitter<UserState> emit) async {
    List<UserModel?> userList = await _databaseRepository.getUserData();

    emit(UserSuccess(userList, event.username));
  }
}
