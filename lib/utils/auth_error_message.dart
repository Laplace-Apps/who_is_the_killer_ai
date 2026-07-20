import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../providers/language_provider.dart';

String authErrorMessage(Object error, LanguageProvider language) {
  if (error is GoogleSignInException ||
      error is SignInWithAppleAuthorizationException) {
    return language.t('auth_error_unknown');
  }

  if (error is! FirebaseAuthException) {
    return language.t('auth_error_unknown');
  }

  switch (error.code) {
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
    case 'invalid-email':
      return language.t('auth_error_invalid_credential');
    case 'email-already-in-use':
      return language.t('auth_error_email_in_use');
    case 'weak-password':
      return language.t('auth_error_weak_password');
    case 'user-disabled':
      return language.t('auth_error_disabled');
    case 'too-many-requests':
      return language.t('auth_error_too_many_requests');
    case 'network-request-failed':
      return language.t('auth_error_network');
    case 'operation-not-allowed':
      return language.t('auth_error_provider_disabled');
    default:
      return language.t('auth_error_unknown');
  }
}
