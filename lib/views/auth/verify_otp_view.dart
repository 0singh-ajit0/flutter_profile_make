import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paypie_flutter/common/utils/snackbar.dart';
import 'package:paypie_flutter/common/widgets/custom_textformfield.dart';
import 'package:paypie_flutter/services/auth_service.dart';
import 'package:paypie_flutter/services/profile_service.dart';
import 'package:paypie_flutter/views/homescreen_view.dart';

class VerifyOTPView extends StatefulWidget {
  final String name;
  final String phoneNum;
  final String verificationId;
  const VerifyOTPView({
    super.key,
    required this.verificationId,
    required this.name,
    required this.phoneNum,
  });

  @override
  State<VerifyOTPView> createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  late final TextEditingController _otpController;
  final _otpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("user: ${AuthService.instance.currentUser}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        elevation: 3,
      ),
      body: Center(
        child: Form(
          key: _otpFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  hintText: "Enter the OTP",
                  keyboardType: TextInputType.number,
                  suffixIcon: const Icon(Icons.password_outlined),
                  controller: _otpController,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_otpFormKey.currentState!.validate()) {
                      await AuthService.instance.verifyOTP(
                        verificationId: widget.verificationId,
                        smsCode: _otpController.text,
                      );
                      await ProfileService.instance.createProfile(
                        context: context,
                        phoneNum: widget.phoneNum,
                        name: widget.name,
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
                child: const Text("Verify OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
