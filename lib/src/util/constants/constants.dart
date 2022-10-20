import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colours
  static const kPrimaryColor = Color(0xFFFFFFFF);
  static const kGreyColor = Color(0xFFEEEEEE);
  static const kBlackColor = Color(0xFF000000);
  static const kDarkGreyColor = Color(0xFF9E9E9E);
  static const kDarkBlueColor = Color(0xFF6057FF);
  static const kBorderColor = Color(0xFFEFEFEF);

  //text
  static const title = "Google Sign In";
  static const textIntro1 = "You";
  static const textIntro2 = "Choose";
  static const textIntroDesc = "\n Simple answers to complex decisions";
  static const textSmallSignUp = "Sign up takes only 2 minutes!";
  static const textSignIn = "Sign In";
  static const textSignUpBtn = "Sign Up";
  static const textStart = "Get Started";
  static const textSignInTitle = "Welcome back!";
  static const textRegister = "Register Below!";
  static const textSmallSignIn = "You've been missed!";
  static const textSignInGoogle = "Sign In With Google";
  static const textAcc = "Don't have an account? ";
  static const textSignUp = "Sign Up here";
  static const textHome = "Home";
  static const textNoData = "No Data Available!";
  static const textFixIssues = "Please fill the data correctly!";
  static const textGroupAdded = "New group successfully created";
  static const textAddGroupTitle = "Create new group";
  static const textAddGroupBtn = "Create Group";
  static const textAddRestaurantTitle = "Add new restaurant";
  static const textAddRestaurantBtn = "Add restaurant";
  static const textAddTagTitle = "Create a tag";
  static const textAddTagBtn = "Create tag";
  static const textAddFriendTitle = "Add a Friend";
  static const textAddFriendBtn = "Send friend request";


  //navigate
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kPrimaryColor,
      statusBarIconBrightness: Brightness.dark);

  // forms
  static BoxDecoration formMultiSelect = BoxDecoration(
      border: Border.all(color: Constants.kBorderColor, width: 3.0),
      borderRadius: const BorderRadius.all(Radius.circular(4.0)));

  static const formInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));

  static formInputDecoration({helperText, labelText, errorText}) =>
      InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: Constants.formInputBorder,
        helperText: helperText,
        helperMaxLines: 2,
        labelText: labelText,
        errorMaxLines: 2,
        errorText: errorText,
      );

  // data
  static const pricesInputs = ['£', '££', '£££', "££££"];
  static const tags = [
    "Fancy",
    "Chinese",
    "Indian",
    "Fast Food",
    "Date Night",
    "Casual",
    "Steak",
    "Pizza",
  ];
  static const defaultProfileImage =
      "gs://restaurant-picker-flutter.appspot.com/user/profile/default_profile.jpg";
}
