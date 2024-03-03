import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paypie_flutter/common/utils/snackbar.dart';
import 'package:paypie_flutter/common/widgets/custom_textformfield.dart';
import 'package:paypie_flutter/services/auth_service.dart';
import 'package:paypie_flutter/views/homescreen_view.dart';

class VerifyPhoneView extends StatefulWidget {
  const VerifyPhoneView({super.key});

  @override
  State<VerifyPhoneView> createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  final _phoneVerifyFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register / Log in"),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _phoneVerifyFormKey,
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
                    hintText: "Enter your phone number",
                    keyboardType: TextInputType.phone,
                    suffixIcon: const Icon(Icons.phone_outlined),
                    controller: _phoneController,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_phoneVerifyFormKey.currentState!.validate()) {
                        await AuthService.instance.phoneSignIn(
                          context: context,
                          name: _nameController.text,
                          phoneNum: _phoneController.text,
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
                        }
                      }
                    } on FirebaseAuthException catch (err) {
                      log("Error code: ${err.code}");
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
                  child: const Text("Verify Phone number"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
