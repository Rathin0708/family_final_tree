import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    bool? emailVerified,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? lastSignInTime,
    String? token,
    String? profilePicture,
  }) : super(
          id: id,
          email: email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          photoURL: photoURL,
          emailVerified: emailVerified,
          isAnonymous: isAnonymous,
          createdAt: createdAt,
          lastSignInTime: lastSignInTime,
          token: token,
          profilePicture: profilePicture,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      photoURL: json['photoURL'] ?? json['profilePicture'], // Fallback to profilePicture if photoURL is null
      emailVerified: json['emailVerified'] ?? false,
      isAnonymous: json['isAnonymous'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastSignInTime: json['lastSignInTime'] != null ? DateTime.parse(json['lastSignInTime']) : null,
      token: json['token'],
      profilePicture: json['profilePicture'] ?? json['photoURL'], // Fallback to photoURL if profilePicture is null
    );
  }

  factory UserModel.fromFirebaseUser(dynamic user, {String? token}) {
    return UserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      profilePicture: user.photoURL, // Use photoURL as profilePicture initially
      emailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      createdAt: user.metadata.creationTime,
      lastSignInTime: user.metadata.lastSignInTime,
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
      'token': token,
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    bool? emailVerified,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? lastSignInTime,
    String? token,
    String? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      token: token ?? this.token,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
