import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/key.dart';
import 'package:wirwa/data/model.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/job_seeker/new_profile.dart';
import 'package:wirwa/screen/recruiter/new_profile.dart';
import 'package:wirwa/screen/recruiter/main.dart';

import 'job_seeker/main.dart';

class LoginController extends GetxController {
  var _currentUserId = Supabase.instance.client.auth.currentUser?.id ?? "";
  final UserRepository userRepository = Get.find();
  StreamSubscription<AuthState>? _authListener;

  @override
  void onInit() {
    super.onInit();
    _authListener = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      if (data.event == AuthChangeEvent.signedIn) {
        _currentUserId = Supabase.instance.client.auth.currentUser?.id ?? "";
        _ensureRole();
      }
    });
  }

  Future<void> _ensureRole() async {
    final role = await userRepository.getUserRole(_currentUserId);
    if (role == null) {
      final role = await Get.bottomSheet<UserRole>(
        Container(
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                title: Text("Job Seeker"),
                onTap: () => Get.back(result: UserRole.JOB_SEEKER),
              ),
              ListTile(
                title: Text("Recruiter"),
                onTap: () => Get.back(result: UserRole.RECRUITER),
              ),
            ],
          ),
        ),
        isDismissible: false,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
      await userRepository.setUserRole(_currentUserId, role!);
    }

    if (role == UserRole.RECRUITER) {
      final profile = await userRepository.getRecruiterProfile(_currentUserId);
      if (profile == null) Get.off(RecruiterNewProfilePage());
      else Get.off(RecruiterPage());
    }
    if (role == UserRole.JOB_SEEKER) {
      final profile = await userRepository.getJobSeekerProfile(_currentUserId);
      if (profile == null) Get.off(JobSeekerNewProfilePage());
      else Get.off(JobSeekerPage());
    }
  }

  Future<void> login() async {
    const webClientId = GOOGLE_OAUTH_CLIENT_ID;
    final scopes = ["email", "profile"];
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(serverClientId: webClientId);

    final googleUser = await googleSignIn.attemptLightweightAuthentication();

    if (googleUser == null) {
      throw AuthException("Failed to sign in");
    }

    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw AuthException("No ID Token found");
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
  }

  @override
  void onClose() {
    _authListener?.cancel();
    super.onClose();
  }
}

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: OutlinedButton(
          onPressed: controller.login,
          child: const Text("Login"),
        ),
      ),
    );
  }
}
