import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/util/constants/constants.dart';
import 'package:you_choose/src/widgets/appbar_widget.dart';
import 'package:you_choose/src/widgets/button_widget.dart';
import 'package:you_choose/src/widgets/create_snackbar.dart';
import 'package:you_choose/src/widgets/profile_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  bool _isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  Future<XFile?> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      return image;
    } catch (e) {
      return null;
    }
  }

  String? _newUsername;
  String? _newPassword;
  XFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: true),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  uid: state.user.uid,
                  isEdit: true,
                  useDefault: state.user.useDefaultProfileImage,

                  onClicked: () async {
                    XFile? image = await _pickImage();

                    if (image == null) {
                      createSnackBar(
                          message: "Could not update image",
                          error: true,
                          context: context);
                      return;
                    }

                    setState(() {
                      _profileImage = image;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextFormField(
                        initialValue: state.user.username,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        decoration: Constants.formInputDecoration(
                            labelText: 'Username', errorText: null),
                        onChanged: (String value) {
                          setState(() {
                            _newUsername = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        maxLines: 1,
                        decoration: Constants.formInputDecoration(
                            labelText: 'Password', errorText: null),
                        onChanged: (String value) {
                          setState(() {
                            _newPassword = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (!_isPasswordValid(value)) {
                            return 'Password is not valid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ButtonWidget(
                  text: 'Save',
                  onClicked: () {
                    // profile image changed
                    if (_profileImage != null) {

                      BlocProvider.of<AuthenticationBloc>(context).add(
                          AuthenticationProfileImageChanged(
                              newImage: _profileImage!, uid: state.user.uid));

                      CachedFirestorage.instance
                          .removeCacheEntry(mapKey: state.user.uid);
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
