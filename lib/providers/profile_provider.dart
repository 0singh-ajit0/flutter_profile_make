import 'package:flutter/material.dart';
import 'package:paypie_flutter/models/profile.dart';

class ProfileProvider extends ChangeNotifier {
  late Profile _currentProfile;

  void setProfile(Profile profile) {
    _currentProfile = profile;
  }

  Profile get currentProfile => _currentProfile;
}
