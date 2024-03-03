import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paypie_flutter/common/utils/user_data.dart';
import 'package:paypie_flutter/models/profile.dart';
import 'package:paypie_flutter/providers/profile_provider.dart';
import 'package:paypie_flutter/services/auth_service.dart';
import 'package:paypie_flutter/services/storage_service.dart';
import 'package:provider/provider.dart';

class ProfileService {
  static final ProfileService _singleton = ProfileService._internal();
  factory ProfileService() {
    return _singleton;
  }
  ProfileService._internal();

  static ProfileService get instance => ProfileService();
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<void> createProfile({
    required BuildContext context,
    required String phoneNum,
    required String name,
  }) async {
    String profileId = AuthService
        .instance.currentUser!.uid; // Creates unique id based on time
    Profile profile = Profile(
      id: profileId,
      name: name,
      phoneNum: phoneNum,
    );
    await _firestore
        .collection("profiles")
        .doc(profileId)
        .set(profile.toJson());

    context.read<ProfileProvider>().setProfile(profile);
    await saveCurrentUserData(profile);
  }

  Future<void> loadProfile({
    required BuildContext context,
  }) async {
    String profileId = AuthService.instance.currentUser!.uid;
    final snap = await _firestore.collection("profiles").doc(profileId).get();
    final profile = Profile.fromSnapshot(snap);
    context.read<ProfileProvider>().setProfile(profile);
    await saveCurrentUserData(profile);
  }

  Future<void> updatedProfile({
    required BuildContext context,
    String? name,
    String? email,
    Uint8List? image,
  }) async {
    final currentProfile = context.read<ProfileProvider>().currentProfile;
    final id = currentProfile.id;

    if (image != null) {
      final newImageUrl =
          await StorageService.instance.uploadProfileImageToStorage(
        userId: id,
        file: image,
      );
      currentProfile.profilePicUrl = newImageUrl;
    }

    if (name != null) {
      currentProfile.name = name;
    }

    if (email != null) {
      currentProfile.email = email;
    }

    await _firestore
        .collection("profiles")
        .doc(id)
        .set(currentProfile.toJson());
    context.read<ProfileProvider>().setProfile(currentProfile);
    await saveCurrentUserData(currentProfile);
  }
}
