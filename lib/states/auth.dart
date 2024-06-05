import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'providers.dart';

class AuthState {
  final sb.Session? session;
  final bool isLoading;
  final bool isInitialized;
  final bool isMagicLinkSent;
  final bool isInRecovery;
  final String? error;

  bool get isSignedIn => session != null;

  const AuthState({
    this.session,
    this.isLoading = false,
    this.isInitialized = false,
    this.isMagicLinkSent = false,
    this.isInRecovery = false,
    this.error,
  });

  factory AuthState.preInit() => const AuthState(isInitialized: false);
  factory AuthState.initial() => const AuthState(isInitialized: true);
  factory AuthState.loading() => const AuthState(isLoading: true);
  factory AuthState.authenticated(sb.Session session) =>
      AuthState(session: session);
  factory AuthState.recovery(sb.Session session) =>
      AuthState(isInRecovery: true, session: session);
  factory AuthState.magicLinkSent() => const AuthState(isMagicLinkSent: true);
  factory AuthState.error(String error) => AuthState(error: error);
}

class AuthProvider extends StateNotifier<AuthState> {
  final sb.GoTrueClient _client = sb.Supabase.instance.client.auth;

  final Ref ref;

  // on init
  AuthProvider(this.ref) : super(AuthState.preInit()) {
    _client.onAuthStateChange.listen((event) {
      if (event.event == sb.AuthChangeEvent.signedIn) {
        if (event.session != null &&
            event.session?.accessToken != state.session?.accessToken) {
          setAuthenticated(event.session!);
        }
      } else if (event.event == sb.AuthChangeEvent.signedOut) {
        setInitial();
      } else if (event.event == sb.AuthChangeEvent.userUpdated) {
        setAuthenticated(event.session!);
      } else if (event.event == sb.AuthChangeEvent.passwordRecovery) {
        setRecovery(event.session!);
      } else if (event.event == sb.AuthChangeEvent.userDeleted) {
        setInitial();
      } else if (event.event == sb.AuthChangeEvent.initialSession) {
        // Check if the user is already signed in
        if (state.isSignedIn) {
          setAuthenticated(state.session!);
        } else {
          setInitial();
        }
      }
    });

    final initialSession = _client.currentSession;
    if (initialSession != null) {
      setAuthenticated(initialSession);
    } else {
      final currentSession = sb.Supabase.instance.client.auth.currentSession;
      if (currentSession != null) {
        setAuthenticated(currentSession);
      } else {
        setInitial();
      }
    }
  }

  void setAuthenticated(sb.Session session) {
    state = AuthState.authenticated(session);
    Future.delayed(Duration.zero, () {
      ref.read(userProvider.notifier).setUser(session.user);
      ref.read(userProvider.notifier).getProfile();
      ref.read(chatProvider.notifier).loginUser();
    });
  }

  Future<void> setInitial() async {
    state = AuthState.initial();
    Future.delayed(Duration.zero, () {
      ref.read(userProvider.notifier).setUser(null);
      ref.read(userProvider.notifier).logout();
    });
  }

  void setRecovery(sb.Session session) {
    state = AuthState.recovery(session);
  }

  void setError(String error) {
    state = AuthState.error(error);
  }

  void setLoading() {
    state = AuthState.loading();
  }

  void setMagicLinkSent() {
    state = AuthState.magicLinkSent();
  }

  Future<void> logOut() async {
    await _client.signOut();
    setInitial();
  }

  Future<void> sendMagicLink(String email, {bool continueSetup = false}) async {
    setLoading();

    try {
      final uri =
          "${Uri.base.scheme}://${Uri.base.host}${Uri.base.hasPort ? ":${Uri.base.port}" : ""}";
      if (continueSetup) {
        await _client.resetPasswordForEmail(
          email,
          redirectTo:
              kIsWeb ? "$uri/reset-password" : "sh.edm.buddy://reset-password",
        );
      } else {
        await _client.signInWithOtp(
          email: email,
          emailRedirectTo: kIsWeb ? uri : "sh.edm.buddy://login-callback",
        );
      }

      setMagicLinkSent();
    } on sb.AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<bool> logInWithPassword(String email, String password) async {
    setLoading();

    try {
      final response = await _client.signInWithPassword(
        email: email,
        password: password,
      );

      response.session != null
          ? setAuthenticated(response.session!)
          : setError("Invalid email or password");

      return response.session != null;
    } on sb.AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(e.toString());
    }
    return false;
  }

  Future<bool> setPassword(String password) async {
    setLoading();

    try {
      await _client.updateUser(sb.UserAttributes(password: password));
      setAuthenticated(_client.currentSession!);
      return true;
    } on sb.AuthException catch (e) {
      setError(e.message);
      return false;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    setLoading();

    try {
      final response = await _client.signUp(
        email: email,
        password: password,
        emailRedirectTo: kIsWeb
            ? "${Uri.base.scheme}://${Uri.base.host}${Uri.base.hasPort ? ":${Uri.base.port}" : ""}/welcome"
            : "net.mindgasm.app://welcome",
      );
      response.session != null
          ? setAuthenticated(response.session!)
          : setError("Unknown error");

      return response.session != null;
    } on sb.AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(e.toString());
    }
    return false;
  }

  Future<void> deleteAccount() async {
    await sb.Supabase.instance.client.from("deletion_requests").insert({
      "user_id": state.session!.user.id,
    });
    await logOut();
  }
}
