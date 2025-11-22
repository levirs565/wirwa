import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/key.dart';
import 'package:wirwa/data/repositories.dart';

class AuthDataSource implements AuthRepository {
  final client = Get.find<SupabaseClient>();

  @override
  Stream<String?> userChangedStream() {
    return client.auth.onAuthStateChange.map((event) => event.session?.user.id);
  }

  @override
  String? getUserId() {
    return client.auth.currentUser?.id;
  }

  @override
  String? getUserEmail() {
    return client.auth.currentUser?.email;
  }

  @override
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
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await GoogleSignIn.instance.disconnect();
    await Supabase.instance.client.auth.signOut();
  }
}
