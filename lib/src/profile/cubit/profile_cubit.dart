import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_choose/src/repositories/database/firestore_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._firestoreRepository) : super(const ProfileState());

  final FirestoreRepository _firestoreRepository;

  Future<void> changeAvatarImage(XFile image, String uid) async {
    await _firestoreRepository.updateProfileImage(image, uid);
  }
}
