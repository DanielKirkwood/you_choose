import 'package:flutter/material.dart';
import 'package:you_choose/src/models/auth_result_status.dart';
import 'package:you_choose/src/services/auth.dart';
import 'package:you_choose/src/widgets/create_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      AuthResultStatus status = await _authService.signInWithEmailAndPassword(
          email: _email, password: _password);

      if (status != AuthResultStatus.successful) {
        String errorMsg = AuthService.generateExceptionMessage(status);
        createSnackBar(message: errorMsg, error: true, context: context);
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "Welcome\nBack",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(children: [
                  TextFormField(
                    onFieldSubmitted: (String value) {
                      setState(() => _email = value);
                    },
                    onChanged: (String value) {
                      setState(() => _email = value);
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide an email address';
                      }
                      if (!_authService.isValidEmail(value)) {
                        return 'Please provide a valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onFieldSubmitted: (String value) {
                      setState(() => _password = value);
                    },
                    onChanged: (String value) {
                      setState(() => _password = value);
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xff4c505b),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: _isLoading ? null : _submit,
                          icon: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Color(0xff4c505b),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Color(0xff4c505b),
                            ),
                          ),
                        ),
                      ]),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
