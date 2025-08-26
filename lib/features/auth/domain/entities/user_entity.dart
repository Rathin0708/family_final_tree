import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final bool? emailVerified;
  final bool? isAnonymous;
  final DateTime? createdAt;
  final DateTime? lastSignInTime;
  final String? token;
  final String? profilePicture;

  const UserEntity({
    this.id,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.emailVerified = false,
    this.isAnonymous = false,
    this.createdAt,
    this.lastSignInTime,
    this.token,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        phoneNumber,
        photoURL,
        emailVerified,
        isAnonymous,
        createdAt,
        lastSignInTime,
        token,
        profilePicture,
      ];

  UserEntity copyWith({
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
    return UserEntity(
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

  bool get isAuthenticated => id != null && id!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'profilePicture': profilePicture,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
      'token': token,
    };
  }
}
