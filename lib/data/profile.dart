import 'dart:convert';

import 'package:flutter/foundation.dart';

class Profile {
  final String id;

  // Public properties
  final String personName;
  final String petName;
  final String username;
  final String? bio;
  final String? imageUrl;

  // Private properties
  final ProfilePrivate? private;

  // Secure properties
  final UserDetails? userDetails;

  Profile({
    required this.id,
    required this.personName,
    required this.petName,
    required this.username,
    this.bio,
    this.private,
    this.userDetails,
    this.imageUrl,
  });

  Profile copyWith({
    String? id,
    String? personName,
    String? petName,
    String? username,
    String? bio,
    ProfilePrivate? private,
    UserDetails? userDetails,
    String? imageUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      petName: petName ?? this.petName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      private: private ?? this.private,
      userDetails: userDetails ?? this.userDetails,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  bool get hasPet => petName.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personName': personName,
      'petName': petName,
      'username': username,
      'bio': bio,
      'private': private?.toMap(),
      'userDetails': userDetails?.toMap(),
      'profilePic': imageUrl,
    };
  }

  Map<String, dynamic> toDBMap() {
    return {
      'id': id,
      'personName': personName,
      'petName': petName,
      'username': username,
      'bio': bio,
      'lastModifiedAt': DateTime.now().toUtc().toUtc().toIso8601String(),
      'profilePic': imageUrl,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] ?? '',
      personName: map['personName'],
      petName: map['petName'],
      username: map['username'],
      bio: map['bio'],
      private: map['private'] != null
          ? ProfilePrivate.fromMap(Map<String, dynamic>.from(map['private']))
          : null,
      userDetails: map['userDetails'] != null
          ? UserDetails.fromMap(Map<String, dynamic>.from(map['userDetails']))
          : null,
      imageUrl: map['profilePic'] ?? map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(id: $id, personName: $personName, petName: $petName, username: $username, bio: $bio, private: $private, userDetails: $userDetails, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.id == id &&
        other.personName == personName &&
        other.petName == petName &&
        other.username == username &&
        other.bio == bio &&
        other.private == private &&
        other.userDetails == userDetails &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        personName.hashCode ^
        petName.hashCode ^
        username.hashCode ^
        bio.hashCode ^
        private.hashCode ^
        userDetails.hashCode ^
        imageUrl.hashCode;
  }
}

class ProfilePrivate {
  // Private properties
  final List<String> pushIds;
  final List<String> blockedUsers;
  final bool public;

  ProfilePrivate({
    required this.pushIds,
    required this.blockedUsers,
    required this.public,
  });

  ProfilePrivate copyWith({
    List<String>? pushIds,
    List<String>? blockedUsers,
    bool? public,
  }) {
    return ProfilePrivate(
      pushIds: pushIds ?? this.pushIds,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      public: public ?? this.public,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pushIds': pushIds,
      'blockedUsers': blockedUsers,
      'public': public,
    };
  }

  // To DB Map
  Map<String, dynamic> toDBMap(String id) {
    return {
      'id': id,
      'pushIds': pushIds,
      'blockedUsers': blockedUsers,
      'public': public,
      'lastUpdatedAt': DateTime.now().toUtc().toUtc().toIso8601String(),
    };
  }

  factory ProfilePrivate.fromMap(Map<String, dynamic> map) {
    return ProfilePrivate(
      public: map['public'] ?? false,
      blockedUsers: List<String>.from(map["blockedUsers"] ?? []),
      pushIds: List<String>.from(map["pushIds"] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfilePrivate.fromJson(String source) =>
      ProfilePrivate.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfilePrivate(pushIds: $pushIds, blockedUsers: $blockedUsers, public: $public)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfilePrivate &&
        listEquals(other.pushIds, pushIds) &&
        listEquals(other.blockedUsers, blockedUsers) &&
        other.public == public;
  }

  @override
  int get hashCode {
    return pushIds.hashCode ^ blockedUsers.hashCode ^ public.hashCode;
  }
}

class UserDetails {
  final Role role;

  UserDetails({
    required this.role,
  });

  UserDetails copyWith({
    Role? role,
  }) {
    return UserDetails(
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role.toString().toUpperCase(),
    };
  }

  Map<String, dynamic> toDBMap(String id) {
    return {
      'id': id,
      'role': role.toString().toUpperCase(),
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      role: Role.values
          .firstWhere((e) => e.toString().toUpperCase() == map['role']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source));

  @override
  String toString() => 'UserDetails(role: $role)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserDetails && other.role == role;
  }

  @override
  int get hashCode => role.hashCode;
}

// Role enum
enum Role {
  admin,
  mod,
  user,
  verified,
  org,
}
