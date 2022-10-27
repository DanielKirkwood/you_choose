import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._storageRepository) : super(const ProfileState());

  final StorageRepository _storageRepository;

  Future<void> changeAvatarImage(XFile image, String username) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final task =
        await _storageRepository.uploadFile(file: image, username: username);

    emit(state.copyWith(status: ProfileStatus.success));
  }

  Future<void> getProfileUrl({required String username}) async {
    final url = await _storageRepository.getProfileImage(username: username);

    emit(state.copyWith(imageURL: url));
  }
}
