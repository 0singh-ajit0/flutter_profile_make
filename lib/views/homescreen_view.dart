import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paypie_flutter/common/utils/get_assets.dart';
import 'package:paypie_flutter/common/utils/logout_dialog.dart';
import 'package:paypie_flutter/common/utils/snackbar.dart';
import 'package:paypie_flutter/common/utils/user_data.dart';
import 'package:paypie_flutter/common/widgets/custom_textformfield.dart';
import 'package:paypie_flutter/providers/profile_provider.dart';
import 'package:paypie_flutter/services/auth_service.dart';
import 'package:paypie_flutter/services/profile_service.dart';
import 'package:paypie_flutter/views/auth/verify_phone_view.dart';
import 'package:provider/provider.dart';

enum MenuAction { logout }

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  Uint8List? _image;
  final _profileKey = GlobalKey<FormState>();
  bool isNetworkImage = false;
  late String networkImageUrl;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    final profile = await loadCurrentUserData();
    context.read<ProfileProvider>().setProfile(profile);
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNum;
  }

  Future<void> selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
      isNetworkImage = false;
    });
  }

  Future<void> initializeProfilePic() async {
    final currentProfile = context.read<ProfileProvider>().currentProfile;
    if (currentProfile.profilePicUrl != "") {
      isNetworkImage = true;
      networkImageUrl = currentProfile.profilePicUrl;
    } else {
      isNetworkImage = false;
      final file = await getImageFromAssets("images/defaultProfilePic.png");
      _image = await file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadUserData(),
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          elevation: 3,
          actions: [
            PopupMenuButton<MenuAction>(
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ],
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      await AuthService.instance.logOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const VerifyPhoneView(),
                        ),
                      );
                    }
                    break;
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Stack(
                children: [
                  FutureBuilder(
                    future: initializeProfilePic(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return isNetworkImage
                            ? CircleAvatar(
                                radius: 64.0,
                                backgroundImage:
                                    Image.network(networkImageUrl).image,
                                backgroundColor: Colors.transparent,
                              )
                            : (_image != null
                                ? CircleAvatar(
                                    radius: 64.0,
                                    backgroundImage: MemoryImage(_image!),
                                    backgroundColor: Colors.transparent,
                                  )
                                : const CircleAvatar());
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () async {
                        await selectImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                      color: Colors.grey,
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(1),
                        shadowColor: MaterialStatePropertyAll(Colors.white38),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Form(
                key: _profileKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: "Enter your name",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        hintText: "Enter your email",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        hintText: "Enter your phone number",
                        controller: _phoneController,
                        enabled: false,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (_profileKey.currentState!.validate()) {
                            await ProfileService.instance.updatedProfile(
                              context: context,
                              name: _nameController.text,
                              email: _emailController.text,
                              image: _image,
                            );
                            showSnackbar(context, "Profile updated");
                          }
                        },
                        style: const ButtonStyle(
                          padding:
                              MaterialStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          )),
                        ),
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
