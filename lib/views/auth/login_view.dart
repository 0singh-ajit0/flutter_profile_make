import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paypie_flutter/common/utils/snackbar.dart';
import 'package:paypie_flutter/common/widgets/custom_textformfield.dart';
import 'package:paypie_flutter/services/auth_service.dart';
import 'package:paypie_flutter/services/profile_service.dart';
import 'package:paypie_flutter/views/auth/signup_view.dart';
import 'package:paypie_flutter/views/homescreen_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final _signInFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        elevation: 3,
      ),
      body: Center(
        child: Form(
          key: _signInFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(Icons.email_outlined),
                  controller: _emailController,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  hintText: "Enter a password",
                  keyboardType: TextInputType.visiblePassword,
                  isObscureText: true,
                  suffixIcon: const Icon(Icons.password_outlined),
                  controller: _passwordController,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_signInFormKey.currentState!.validate()) {
                      await AuthService.instance.logIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      await ProfileService.instance
                          .loadProfile(context: context);
                      if (AuthService.instance.currentUser != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreenView(),
                          ),
                        );
                        showSnackbar(
                          context,
                          "You're logged in now",
                        );
                      }
                    }
                  } on FirebaseAuthException catch (err) {
                    switch (err.code) {
                      case "user-disabled":
                        showSnackbar(
                          context,
                          "Your account is disabled. Contact your administrator.",
                        );
                        break;
                      case "invalid-email":
                      case "user-not-found":
                      case "weak-password":
                      case "invalid-credential":
                        showSnackbar(
                          context,
                          "Incorrect email or password",
                        );
                        break;
                      default:
                        showSnackbar(
                          context,
                          "Something went wrong.\n${err.code} : ${err.message}",
                        );
                    }
                  } catch (err) {
                    showSnackbar(
                      context,
                      "Something went wrong.\n${err.toString()}",
                    );
                  }
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  )),
                ),
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                },
                child: const Text("Not registered? Register Here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
