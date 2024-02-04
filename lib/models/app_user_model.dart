import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AppUserModel {
  final String? userName;
  final String? userEmail;
  final String? userPhoto;
  final String? userUid;
  final String? userPhoneNumber;

  AppUserModel({
    this.userName,
    this.userEmail,
    this.userPhoto,
    this.userUid,
    this.userPhoneNumber,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      userName: json['userName'],
      userEmail: json['userEmail'],
      userPhoto: json['userPhoto'],
      userUid: json['userUid'],
      userPhoneNumber: json['userPhoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userPhoto': userPhoto,
      'userUid': userUid,
      'userPhoneNumber': userPhoneNumber,
    };
  }

  // Assuming `userCredential` comes from an authentication event,
  // this method can be used to create a User instance from it.
  // This is just a placeholder method, you might need to adjust
  // it based on your actual authentication flow.
  static AppUserModel fromUserCredential(dynamic userCredential) {
    return AppUserModel(
      userName: userCredential.user?.displayName,
      userEmail: userCredential.user?.email,
      userPhoto: userCredential.user?.photoURL,
      userUid: userCredential.user?.uid,
      userPhoneNumber: userCredential.user?.phoneNumber,
    );
  }

  static AppUserModel fromFirebaseUser(firebase_auth.User firebaseUser) {
    return AppUserModel(
      userName: firebaseUser.displayName,
      userEmail: firebaseUser.email,
      userPhoto: firebaseUser.photoURL,
      userUid: firebaseUser.uid,
      userPhoneNumber: firebaseUser.phoneNumber,
    );
  }

  @override
  String toString() {
    return 'User(userName: $userName, userEmail: $userEmail, userPhoto: $userPhoto, userUid: $userUid, userPhoneNumber: $userPhoneNumber)';
  }
}
