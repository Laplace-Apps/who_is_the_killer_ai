import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthFlowResult { success, cancelled }

abstract interface class AuthService {
  bool get isAuthenticated;

  bool get isGoogleSignInAvailable;

  bool get isAppleSignInAvailable;

  Stream<bool> get authenticationChanges;

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<AuthFlowResult> signInWithGoogle();

  Future<AuthFlowResult> signInWithApple();

  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  Future<void>? _googleInitialization;

  @override
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  @override
  bool get isGoogleSignInAvailable =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  bool get isAppleSignInAvailable =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Stream<bool> get authenticationChanges =>
      _firebaseAuth.authStateChanges().map((user) => user != null);

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<AuthFlowResult> signInWithGoogle() async {
    if (!isGoogleSignInAvailable) {
      throw FirebaseAuthException(code: 'operation-not-allowed');
    }

    _googleInitialization ??= GoogleSignIn.instance.initialize();
    await _googleInitialization;

    final GoogleSignInAccount account;
    try {
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return AuthFlowResult.cancelled;
      }
      rethrow;
    }

    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(code: 'google-missing-token');
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await _firebaseAuth.signInWithCredential(credential);
    return AuthFlowResult.success;
  }

  @override
  Future<AuthFlowResult> signInWithApple() async {
    if (!isAppleSignInAvailable) {
      throw FirebaseAuthException(code: 'operation-not-allowed');
    }

    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        return AuthFlowResult.cancelled;
      }
      rethrow;
    }

    final idToken = appleCredential.identityToken;
    if (idToken == null) {
      throw FirebaseAuthException(code: 'apple-missing-token');
    }

    final credential = OAuthProvider(
      'apple.com',
    ).credential(idToken: idToken, rawNonce: rawNonce);
    await _firebaseAuth.signInWithCredential(credential);

    final displayName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().join(' ').trim();
    if (displayName.isNotEmpty &&
        (_firebaseAuth.currentUser?.displayName?.isEmpty ?? true)) {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    }

    return AuthFlowResult.success;
  }

  @override
  Future<void> signOut() async {
    if (_googleInitialization != null) {
      try {
        await _googleInitialization;
        await GoogleSignIn.instance.signOut();
      } on Object {
        // Firebase sign-out must still complete if the provider session fails.
      }
    }
    await _firebaseAuth.signOut();
  }

  String _generateNonce([int length = 32]) {
    const characters =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => characters[random.nextInt(characters.length)],
    ).join();
  }
}
