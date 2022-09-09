import 'package:flutter/material.dart';
import 'package:you_choose/src/models/auth_result_status.dart';
import 'package:you_choose/src/services/auth.dart';
import 'package:you_choose/src/widgets/create_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _email = "";
  String _password = "";
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  void _goToHome() {
    Navigator.pushReplacementNamed(context, '/');
  }

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      AuthResultStatus status = await _authService
          .createUser(email: _email, username: _username, password: _password);

      if (status != AuthResultStatus.successful) {
        String errorMsg = AuthService.generateExceptionMessage(status);
        createSnackBar(message: errorMsg, error: true, context: context);
      }

      if (status == AuthResultStatus.successful) {
        _goToHome();
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "Create\nAccount",
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
                    top: MediaQuery.of(context).size.height * 0.27),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onFieldSubmitted: (String value) {
                      setState(() => _username = value);
                    },
                    onChanged: (String value) {
                      setState(() => _username = value);
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintText: 'Username',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    obscureText: true,
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
                      if (value.length < 8) {
                        return 'Password must have at least 8 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white),
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
                            color: Colors.white,
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
