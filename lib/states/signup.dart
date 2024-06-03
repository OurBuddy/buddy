import 'dart:convert';

import 'package:buddy/data/profile.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_io/io.dart';

class SignupState {
  String? email;
  String? password;
  String? username;
  String? petName;
  String? personName;
  bool? hasPet;
  XFile? image;

  SignupState({
    this.email,
    this.password,
    this.username,
    this.petName,
    this.personName,
    this.hasPet,
    this.image,
  });

  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool get isValid => email != null &&
          email!.isNotEmpty &&
          email!.contains(_emailRegex) &&
          password != null &&
          password!.isNotEmpty &&
          username != null &&
          username!.isNotEmpty &&
          personName != null &&
          personName!.isNotEmpty &&
          image != null &&
          hasPet != null
      ? hasPet!
          ? petName != null && petName!.isNotEmpty
          : true
      : false;

  SignupState copyWith({
    ValueGetter<String?>? email,
    ValueGetter<String?>? password,
    ValueGetter<String?>? username,
    ValueGetter<String?>? petName,
    ValueGetter<String?>? personName,
    ValueGetter<bool>? hasPet,
    ValueGetter<XFile?>? image,
  }) {
    return SignupState(
      email: email != null ? email() : this.email,
      password: password != null ? password() : this.password,
      username: username != null ? username() : this.username,
      petName: petName != null ? petName() : this.petName,
      personName: personName != null ? personName() : this.personName,
      hasPet: hasPet != null ? hasPet() : this.hasPet,
      image: image != null ? image() : this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'petName': petName,
      'personName': personName,
      'hasPet': hasPet ?? 'false',
    };
  }

  factory SignupState.fromMap(Map<String, dynamic> map) {
    return SignupState(
      email: map['email'],
      password: map['password'],
      username: map['username'],
      petName: map['petName'],
      personName: map['personName'],
      hasPet: map['hasPet'] == 'true',
    );
  }

  String toJson() => json.encode(toMap());

  factory SignupState.fromJson(String source) =>
      SignupState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SignupState(email: $email, password: $password, username: $username, petName: $petName, personName: $personName, hasPet: $hasPet)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignupState &&
        other.email == email &&
        other.password == password &&
        other.username == username &&
        other.petName == petName &&
        other.personName == personName &&
        other.hasPet == hasPet;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        username.hashCode ^
        petName.hashCode ^
        personName.hashCode ^
        hasPet.hashCode;
  }
}

class SignupProvider extends StateNotifier<SignupState> {
  SignupProvider(this.ref)
      : super(SignupState(
          email: '',
          password: '',
          username: '',
          petName: '',
          personName: '',
          hasPet: false,
        ));

  final Ref ref;

  final SupabaseClient _client = Supabase.instance.client;

  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void setEmail(String email) {
    // check if email is valid
    if (email.isNotEmpty && email.contains(_emailRegex)) {
      state = state.copyWith(email: () => email);
    } else {
      throw Exception('Invalid email');
    }
  }

  void setPassword(String password) {
    // check if password is valid
    if (password.isNotEmpty && password.length >= 8) {
      state = state.copyWith(password: () => password);
    } else {
      throw Exception('Password must be at least 8 characters');
    }
  }

  void setUsername(String username) {
    state = state.copyWith(username: () => username);
  }

  void setPetName(String petName) {
    state = state.copyWith(petName: () => petName);
  }

  void setPersonName(String personName) {
    state = state.copyWith(personName: () => personName);
  }

  void setHasPet(bool hasPet) {
    state = state.copyWith(hasPet: () => hasPet);
  }

  void reset() {
    state = SignupState(
      email: '',
      password: '',
      username: '',
      petName: '',
      personName: '',
      hasPet: false,
    );
  }

  void set(SignupState newState) {
    state = newState;
  }

  Future<bool> setAndCheckUsername(String username) async {
    setUsername(username);
    return await checkUsername();
  }

  Future<void> setProfilePic(XFile? image) async {
    state = state.copyWith(image: () => image);
  }

  Future<bool> checkUsername({String? username}) async {
    username ??= state.username;
    if (username == null || username.isEmpty || username.length < 3) {
      return false;
    }

    final response =
        await _client.from('profile').count().eq('username', username);

    return response == 0;
  }

  Future<void> lastStep() async {
    await ref.read(userProvider.notifier).updateProfile(
          Profile(
            id: ref.read(authProvider).session!.user.id,
            personName: state.personName!,
            petName: state.petName!,
            username: state.username!,
            private: ProfilePrivate(
              public: false,
              pushIds: [],
              blockedUsers: [],
            ),
          ),
        );

    await ref.read(userProvider.notifier).updateProfilePic(
          File(state.image!.path),
        );
  }

  Future<void> createUser() async {
    // Verify all is valid
    if (!state.isValid) {
      throw Exception('Some information is missing, please check again.');
    }

    final response = await _client.auth.signUp(
      email: state.email!,
      password: state.password!,
    );

    ref.read(authProvider.notifier).setAuthenticated(response.session!);

    await Future.delayed(Duration.zero, () async {
      await ref.read(userProvider.notifier).updateProfile(
            Profile(
              id: response.user!.id,
              personName: state.personName!,
              petName: state.petName!,
              username: state.username!,
            ),
          );

      await ref.read(userProvider.notifier).updateProfilePic(
            File(state.image!.path),
          );
    });
  }
}
