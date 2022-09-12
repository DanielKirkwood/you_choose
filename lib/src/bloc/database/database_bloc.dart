import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/models/user.dart';
import 'package:you_choose/src/services/database/database_repository_impl.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository _databaseRepository;

  DatabaseBloc(this._databaseRepository) : super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
  }

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    List<UserModel?> userList = await _databaseRepository.retrieveUserData();

    emit(DatabaseSuccess(userList, event.username));
  }
}
