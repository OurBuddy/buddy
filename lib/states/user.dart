import 'dart:convert';

import 'package:buddy/data/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_io/io.dart';

import 'providers.dart';

class UserState {
  final Profile? profile;
  final Profile? targetProfile;
  final User? user;
  final bool loading;

  UserState({
    this.profile,
    this.targetProfile,
    this.user,
    this.loading = false,
  });

  bool isConfigured() {
    final profile =
        Hive.box(UserProvider.boxName).get("private", defaultValue: {});
    return profile != null;
  }

  bool get isInSync => targetProfile == null;

  UserState copyWith({
    Profile? profile,
    Profile? targetProfile,
    User? user,
    bool? loading,
  }) {
    return UserState(
      profile: profile ?? this.profile,
      targetProfile: targetProfile ?? this.targetProfile,
      user: user ?? this.user,
      loading: loading ?? this.loading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profile': profile?.toMap(),
      'targetProfile': targetProfile?.toMap(),
      'loading': loading,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      profile: map['profile'] != null ? Profile.fromMap(map['profile']) : null,
      targetProfile: map['targetProfile'] != null
          ? Profile.fromMap(map['targetProfile'])
          : null,
      user: map['user'] != null ? User.fromJson(map['user']) : null,
      loading: map['loading'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) =>
      UserState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserState(profile: $profile, targetProfile: $targetProfile, user: $user, loading: $loading)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserState &&
        other.profile == profile &&
        other.targetProfile == targetProfile &&
        other.user == user &&
        other.loading == loading;
  }

  @override
  int get hashCode {
    return profile.hashCode ^
        targetProfile.hashCode ^
        user.hashCode ^
        loading.hashCode;
  }
}

class UserProvider extends StateNotifier<UserState> {
  final Ref ref;

  static String boxName = "userProfile";

  UserProvider(this.ref) : super(UserState()) {
    init();
  }

//...

  Future<void> init() async {
    state = state.copyWith(
      profile: getLocalProfile(),
    );
  }

  void setUser(User? user) {
    if (user == null) {
      state = UserState(
        profile: state.profile,
        loading: state.loading,
      );
      return;
    }
    if (mounted) state = state.copyWith(user: user);
  }

  void setLoading(bool loading) {
    if (mounted) state = state.copyWith(loading: loading);
  }

  void clear() {
    state = UserState();
  }

  // Get Notification Status
  /*Future<AuthorizationStatus> getNotificationStatus() async {
    // Should look for token check
    if (!Hive.box(boxName).get("shouldLookForToken", defaultValue: true)) {
      return AuthorizationStatus.denied;
    }

    // Uses Firebase Messaging
    final status = await FirebaseMessaging.instance.getNotificationSettings();
    return status.authorizationStatus;
  }

  // Request Notification Permissions
  Future<AuthorizationStatus> requestNotificationPermissions() async {
    // Should look for token check
    if (!Hive.box(boxName).get("shouldLookForToken", defaultValue: true)) {
      // Set on-device flag to start looking for new tokens
      Hive.box(boxName).put("shouldLookForToken", true);
    }

    // Uses Firebase Messaging
    final status = await FirebaseMessaging.instance.requestPermission();

    if (status.authorizationStatus == AuthorizationStatus.authorized) {
      // Update token in supabase using the UpdateUser with the listener
      updateToken(
          await FirebaseMessaging.instance.getToken(vapidKey: vapId) ?? "");
    }

    return status.authorizationStatus;
  }

  // Remove notification permissions
  Future<void> removeNotificationPermissions() async {
    // Uses Firebase Messaging
    await FirebaseMessaging.instance.deleteToken();

    // Update token in supabase using the UpdateUser with the listener
    updateToken("");

    // Set on-device flag to prevent new tokens from being generated
    Hive.box(boxName).put("shouldLookForToken", false);
  }

  // Update token in supabase using the UpdateUser with the listener
  void updateToken(String token) {
    // Check if should look for token
    if (!Hive.box(boxName).get("shouldLookForToken", defaultValue: true) ||
        !mounted) {
      return;
    }

    if (state.user != null) {
      // Check is list is null
      if (state.profile?.private?.pushIds == null) {
        state = state.copyWith(
          profile: state.profile?.copyWith(
            private: state.profile?.private?.copyWith(
              pushIds: [],
            ),
          ),
        );
      }
      // Remove old token
      state.profile?.private?.pushIds?.remove(_lastPushId);
      if (token.isNotEmpty) {
        state.profile?.private?.pushIds?.add(token);
      }

      // Update token
      updateProfile(state.profile!);
    }
  }*/

  Profile getLocalProfile({bool set = false}) {
    final localState = Map<String, dynamic>.from(Hive.box(boxName).toMap());
    if (localState.isNotEmpty && localState["id"] != null) {
      final profile = Profile.fromMap(localState);
      if (set) {
        state = state.copyWith(
          profile: profile,
        );
      }
      return profile;
    } else {
      // Create a new profile, temporary
      final profile = Profile(
        id: "local",
        personName: "",
        petName: "",
        username: "",
      );
      if (set) {
        state = state.copyWith(
          profile: profile,
        );
      }
      return profile;
    }
  }

  Future<Profile?> fetchProfileNoUpdate({String? id}) async {
    setLoading(true);
    final loggedInId = ref.read(authProvider).session?.user.id;
    Profile? profile;

    if (id == null) {
      if (loggedInId == null) {
        setLoading(false);
        throw "No session or ID found";
      }
      id = loggedInId;
    }

    if (loggedInId == id) {
      profile = state.profile;
    } else {
      profile = await getProfile(id: id);
    }

    setLoading(false);
    return profile;
  }

  Future getProfileStats({String? id}) async {
    final loggedInId = ref.read(authProvider).session?.user.id;

    if (id == null) {
      if (loggedInId == null) {
        setLoading(false);
        throw "No session or ID found";
      }
      id = loggedInId;
    }

    // Get the profile stats
    final res = await Supabase.instance.client.functions
        .invoke("getProfileDetails", body: {"reqUserId": id});

    print(res.data);

    return res.data;
  }

  Future<Profile?> getProfile({String? id}) async {
    setLoading(true);
    final loggedInId = ref.read(authProvider).session?.user.id;

    if (id == null) {
      if (loggedInId == null) {
        setLoading(false);
        throw "No session or ID found";
      }
      id = loggedInId;
    }

    final localState = Map<String, dynamic>.from(Hive.box(boxName).toMap());
    if (id == loggedInId &&
        localState.isNotEmpty &&
        localState["id"] != null &&
        localState["id"] == id) {
      getLocalProfile(set: true);
    }

    var publicProfileResponse = await Supabase.instance.client
        .from('profile')
        .select()
        .eq('id', id)
        .maybeSingle();

    // If the user is not the same as the logged in user or an admin then don't run the private queries.
    if (loggedInId != id) {
      if (publicProfileResponse == null) {
        setLoading(false);
        return null;
      } else {
        final profile = Profile.fromMap(publicProfileResponse);
        setLoading(false);
        return profile;
      }
    }

    final privateProfileResponse = await Supabase.instance.client
        .from('profile_private')
        .select()
        .eq('id', id)
        .maybeSingle();

    final privateUserResponse = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (publicProfileResponse == null &&
        privateProfileResponse == null &&
        privateUserResponse == null) {
      setLoading(false);
      return null;
    } else {
      final profile = Profile.fromMap({
        ...publicProfileResponse ?? {"id": id},
        "private": privateProfileResponse,
        "userDetails": privateUserResponse,
      });
      if (loggedInId == id) {
        if (profile.private == null) {
          state = state.copyWith(profile: profile);
          setLoading(false);
          return profile;
        }
        final newProfile = profile.toMap();
        if (newProfile != localState) {
          Hive.box(boxName).putAll(newProfile);
        }

        // Update the token if it's not the same - notifs
        /*if (!(profile.private?.pushIds?.contains(_lastPushId) ?? false)) {
          updateToken(_lastPushId);
        }*/
      }
      setLoading(false);
      return profile;
    }
  }

  Future<Profile?> updateProfile(Profile userAccount) async {
    state = state.copyWith(
      loading: true,
      targetProfile: userAccount,
    );
    Map<String, dynamic>? newUser;
    Profile? newProfile;

    if (!ref.read(authProvider).isSignedIn) {
      Hive.box(boxName).putAll(userAccount.toMap());
      if (kDebugMode) print("Updated local profile");
      state = state.copyWith(
        loading: false,
        profile: userAccount,
        targetProfile: null,
      );
      return userAccount;
    }

    if (state.user == null) {
      state = state.copyWith(
        loading: false,
        targetProfile: null,
      );
      throw "Must be logged in to update online profiles";
    } else {
      // This is also enforced on the backend. (Good try tho <3).
      if (userAccount.id != state.user!.id &&
          (state.profile?.userDetails?.role != Role.admin)) {
        state = state.copyWith(
          loading: false,
          targetProfile: null,
        );
        throw "User is not authorized to update this user's profile";
      }

      List<Future> futures = [];

      try {
        final publicProfileResponse = Supabase.instance.client
            .from('profile')
            .upsert(userAccount.toDBMap())
            .eq('id', userAccount.id)
            .select()
            .single();

        futures.add(publicProfileResponse);

        final privateProfileResponse = Supabase.instance.client
            .from('profile_private')
            .upsert(userAccount.private?.toDBMap(userAccount.id) ?? {})
            .eq('id', userAccount.id)
            .select()
            .single();

        futures.add(privateProfileResponse);

        // Only update the user details if the user is an admin.
        if (state.profile?.userDetails?.role == Role.admin) {
          final privateUserResponse = Supabase.instance.client
              .from('users')
              .upsert(userAccount.userDetails?.toDBMap(userAccount.id) ?? {})
              .eq('id', userAccount.id)
              .select()
              .single();

          futures.add(privateUserResponse);

          final res = await Future.wait(futures);

          newUser = {
            ...res[0] ?? {"id": userAccount.id},
            "private": res[1],
            "userDetails": res[2],
          };
        } else {
          final res = await Future.wait(futures);

          newUser = {
            ...res[0] ?? {"id": userAccount.id},
            "private": res[1],
            if (res.length == 2)
              "userDetails": state.profile?.userDetails?.toMap(),
          };
        }

        newProfile = Profile.fromMap(newUser);

        if (userAccount.id == state.user?.id) {
          state = state.copyWith(
            loading: false,
            profile: newProfile,
            targetProfile: null,
          );
          Hive.box(boxName).putAll(newUser);
        }
      } catch (e) {
        state = state.copyWith(
          loading: false,
          targetProfile: null,
        );
        rethrow;
      }

      return newProfile;
    }
  }

  Future<void> updateProfilePic(File image) async {
    Configuration config = const Configuration(
      outputType: ImageOutputType.jpg,
      quality: 40,
    );

    final compImg = await compressor.compress(ImageFileConfiguration(
      input: ImageFile(
        filePath: image.absolute.path,
        rawBytes: image.readAsBytesSync(),
      ),
      config: config,
    ));

    // Print size
    print("Original size: ${image.lengthSync()}");
    print("Compressed size: ${compImg.rawBytes.length}");

    await Supabase.instance.client.storage.from("profile-pics").uploadBinary(
          "${state.profile!.id}/profile.jpg",
          compImg.rawBytes,
          fileOptions: const FileOptions(
            cacheControl: "3600",
            contentType: "image/jpg",
          ),
        );

    await updateProfile(state.profile!.copyWith(
        imageUrl: Supabase.instance.client.storage
            .from("profile-pics")
            .getPublicUrl("${state.profile!.id}/profile.png")));
  }

  void logout() {
    final sanitizedProfile = Profile(
      id: "local",
      username: "",
      personName: "",
      petName: "",
      bio: "",
      private: null,
      userDetails: null,
    );

    // Set on Hive
    Hive.box(boxName).putAll(sanitizedProfile.toMap());
  }
}
