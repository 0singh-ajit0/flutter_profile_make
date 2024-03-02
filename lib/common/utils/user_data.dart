import 'package:paypie_flutter/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCurrentUserData(Profile profile) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("id", profile.id);
  await prefs.setString("name", profile.name);
  await prefs.setString("email", profile.email);
  await prefs.setString("phoneNum", profile.phoneNum);
  await prefs.setString("profilePicUrl", profile.profilePicUrl);
}

Future<Profile> loadCurrentUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final id = prefs.getString("id") ?? "";
  final name = prefs.getString("name") ?? "";
  final email = prefs.getString("email") ?? "";
  final phoneNum = prefs.getString("phoneNum") ?? "";
  final profilePicUrl = prefs.getString("profilePicUrl") ?? "";

  final profile = Profile(
    id: id,
    email: email,
    name: name,
    phoneNum: phoneNum,
    profilePicUrl: profilePicUrl,
  );
  return profile;
}
