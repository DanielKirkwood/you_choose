import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:you_choose/src/login/view/login_page.dart';
import 'package:you_choose/src/sign_up/sign_up.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: WelcomePage());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Constants.kPrimaryColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Constants.statusBarColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: Constants.textIntro1,
                          style: TextStyle(
                            color: Constants.kBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          )),
                      TextSpan(
                          text: Constants.textIntro2,
                          style: TextStyle(
                              color: Constants.kDarkBlueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0)),
                      TextSpan(
                          text: Constants.textIntroDesc,
                          style: TextStyle(
                              color: Constants.kDarkGreyColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0)),
                    ])),
                SizedBox(height: size.height * 0.05),
                const Text(
                  Constants.textSmallSignUp,
                  style: TextStyle(color: Constants.kDarkGreyColor),
                ),
                SizedBox(
                  width: size.width * 0.8,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Constants.kPrimaryColor),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Constants.kBlackColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: const Text(Constants.textStart),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.8,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Constants.kGreyColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: const Text(
                      Constants.textSignUpBtn,
                      style: TextStyle(color: Constants.kBlackColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
