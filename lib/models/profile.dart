import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String email;
  String name;
  String profilePicUrl;
  String phoneNum;
  String id;

  Profile({
    required this.id,
    required this.name,
    required this.phoneNum,
    this.profilePicUrl = "",
    this.email = "",
  });

  static Profile fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Profile(
      id: snapshot["id"],
      name: snapshot["name"],
      phoneNum: snapshot["phoneNum"],
      email: snapshot["email"],
      profilePicUrl: snapshot["profilePicUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNum": phoneNum,
        "email": email,
        "profilePicUrl": profilePicUrl,
      };
}
