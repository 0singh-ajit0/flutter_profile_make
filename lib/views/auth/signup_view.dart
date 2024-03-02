import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paypie_flutter/common/utils/snackbar.dart';
import 'package:paypie_flutter/common/widgets/custom_textformfield.dart';
import 'package:paypie_flutter/services/auth_service.dart';
import 'package:paypie_flutter/services/profile_service.dart';
import 'package:paypie_flutter/views/auth/login_view.dart';
import 'package:paypie_flutter/views/homescreen_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    hintText: "Enter your name",
                    keyboardType: TextInputType.name,
                    suffixIcon: const Icon(Icons.person_outlined),
                    controller: _nameController,
                  ),
                ),
                const SizedBox(height: 8),
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
                      if (_signUpFormKey.currentState!.validate()) {
                        await AuthService.instance.signUp(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        await ProfileService.instance.createProfile(
                          context: context,
                          email: _emailController.text,
                          name: _nameController.text,
                        );
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
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                          );
                        }
                      }
                    } on FirebaseAuthException catch (err) {
                      switch (err.code) {
                        case "email-already-in-use":
                          showSnackbar(
                            context,
                            "Email already registered. Login with the same email.",
                          );
                          break;
                        case "invalid-email":
                          showSnackbar(
                            context,
                            "Email badly formatted",
                          );
                          break;
                        case "weak-password":
                          showSnackbar(
                            context,
                            "Weak password. Strengthen your account with a strong password.",
                          );
                          break;
                        default:
                          showSnackbar(
                            context,
                            "Something went wrong.\n${err.message}",
                          );
                          break;
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
                    "Sign Up",
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
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Text("Already registered? Login Here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
