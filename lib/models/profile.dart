import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String email;
  String name;
  String profilePicUrl;
  String phoneNum;
  String id;

  Profile({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicUrl = "",
    this.phoneNum = "",
  });

  static Profile fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Profile(
      id: snapshot["id"],
      email: snapshot["email"],
      name: snapshot["name"],
      profilePicUrl: snapshot["profilePicUrl"],
      phoneNum: snapshot["phoneNum"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "profilePicUrl": profilePicUrl,
        "phoneNum": phoneNum,
      };
}
