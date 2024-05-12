import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupState {
  String? email;
  String? password;
  String? username;
  String? petName;
  String? personName;
  bool? hasPet;

  SignupState({
    this.email,
    this.password,
    this.username,
    this.petName,
    this.personName,
    this.hasPet,
  });

  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool get isValid =>
      email != null &&
      email!.isNotEmpty &&
      email!.contains(_emailRegex) &&
      password != null &&
      password!.isNotEmpty &&
      username != null &&
      username!.isNotEmpty &&
      petName != null &&
      petName!.isNotEmpty &&
      personName != null &&
      personName!.isNotEmpty;

  SignupState copyWith({
    ValueGetter<String?>? email,
    ValueGetter<String?>? password,
    ValueGetter<String?>? username,
    ValueGetter<String?>? petName,
    ValueGetter<String?>? personName,
    ValueGetter<bool>? hasPet,
  }) {
    return SignupState(
      email: email != null ? email() : this.email,
      password: password != null ? password() : this.password,
      username: username != null ? username() : this.username,
      petName: petName != null ? petName() : this.petName,
      personName: personName != null ? personName() : this.personName,
      hasPet: hasPet != null ? hasPet() : this.hasPet,
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

  Future<bool> checkUsername({String? username}) async {
    username ??= state.username;
    if (username == null || username.isEmpty || username.length < 3) {
      return false;
    }

    final response =
        await _client.from('profile').select().eq('username', state.username!);

    return response.isEmpty;
  }
}
