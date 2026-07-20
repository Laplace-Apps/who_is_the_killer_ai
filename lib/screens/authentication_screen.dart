import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import '../utils/auth_error_message.dart';
import '../widgets/auth_feedback_banner.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/mystery_background.dart';
import '../widgets/pre_auth_language_button.dart';
import '../widgets/social_auth_button.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({
    super.key,
    required this.authService,
    this.initialSignUp = false,
    this.onBack,
  });

  final AuthService authService;
  final bool initialSignUp;
  final VoidCallback? onBack;

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  late bool _isSignUp;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  String? _feedbackMessage;
  AuthFeedbackTone _feedbackTone = AuthFeedbackTone.error;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialSignUp;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final language = context.read<LanguageProvider>();
    final email = value?.trim() ?? '';
    if (email.isEmpty) return language.t('email_required');
    if (!_emailPattern.hasMatch(email)) return language.t('email_invalid');
    return null;
  }

  String? _validatePassword(String? value) {
    final language = context.read<LanguageProvider>();
    final password = value ?? '';
    if (password.isEmpty) return language.t('password_required');
    if (password.length < 8) return language.t('password_too_short');
    return null;
  }

  String? _validateConfirmation(String? value) {
    final language = context.read<LanguageProvider>();
    if (value != _passwordController.text) {
      return language.t('passwords_do_not_match');
    }
    return null;
  }

  void _showFeedback(String message, AuthFeedbackTone tone) {
    if (!mounted) return;
    setState(() {
      _feedbackMessage = message;
      _feedbackTone = tone;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _feedbackMessage = null;
    });
    try {
      if (_isSignUp) {
        await widget.authService.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await widget.authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      TextInput.finishAutofillContext();
    } catch (error) {
      if (!mounted) return;
      _showFeedback(
        authErrorMessage(error, context.read<LanguageProvider>()),
        AuthFeedbackTone.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final emailError = _validateEmail(_emailController.text);
    if (emailError != null) {
      _showFeedback(emailError, AuthFeedbackTone.error);
      _emailFocus.requestFocus();
      return;
    }

    setState(() {
      _isLoading = true;
      _feedbackMessage = null;
    });
    try {
      await widget.authService.sendPasswordResetEmail(
        _emailController.text.trim(),
      );
      if (!mounted) return;
      _showFeedback(
        context.read<LanguageProvider>().t('reset_email_sent'),
        AuthFeedbackTone.success,
      );
    } catch (error) {
      if (!mounted) return;
      _showFeedback(
        authErrorMessage(error, context.read<LanguageProvider>()),
        AuthFeedbackTone.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _runSocial(Future<AuthFlowResult> Function() signIn) async {
    setState(() {
      _isLoading = true;
      _feedbackMessage = null;
    });
    try {
      await signIn();
    } catch (error) {
      if (!mounted) return;
      _showFeedback(
        authErrorMessage(error, context.read<LanguageProvider>()),
        AuthFeedbackTone.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _feedbackMessage = null;
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();

    return Scaffold(
      body: MysteryBackground(
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 36,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              tooltip: language.t('back'),
                              onPressed: widget.onBack,
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                            const PreAuthLanguageButton(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: AutofillGroup(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const _AuthHeader(),
                                  const SizedBox(height: 24),
                                  Text(
                                    language.t(
                                      _isSignUp
                                          ? 'create_detective_account'
                                          : 'welcome_back',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    language.t(
                                      _isSignUp
                                          ? 'auth_sign_up_subtitle'
                                          : 'auth_sign_in_subtitle',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  if (widget
                                      .authService
                                      .isGoogleSignInAvailable) ...[
                                    SocialAuthButton(
                                      label: language.t('continue_with_google'),
                                      icon: SvgPicture.asset(
                                        'assets/logos/google_logo.svg',
                                        width: 21,
                                        height: 21,
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () => _runSocial(
                                              widget
                                                  .authService
                                                  .signInWithGoogle,
                                            ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  if (widget
                                      .authService
                                      .isAppleSignInAvailable) ...[
                                    SocialAuthButton(
                                      label: language.t('continue_with_apple'),
                                      icon: const Icon(
                                        Icons.apple,
                                        color: Colors.black,
                                      ),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      onPressed: _isLoading
                                          ? null
                                          : () => _runSocial(
                                              widget
                                                  .authService
                                                  .signInWithApple,
                                            ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  if (widget
                                          .authService
                                          .isGoogleSignInAvailable ||
                                      widget
                                          .authService
                                          .isAppleSignInAvailable) ...[
                                    _OrDivider(label: language.t('or')),
                                    const SizedBox(height: 20),
                                  ],
                                  AuthTextField(
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    label: language.t('email'),
                                    icon: Icons.mail_outline_rounded,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [
                                      AutofillHints.email,
                                      AutofillHints.username,
                                    ],
                                    validator: _validateEmail,
                                    onFieldSubmitted: (_) =>
                                        _passwordFocus.requestFocus(),
                                  ),
                                  const SizedBox(height: 14),
                                  AuthTextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    label: language.t('password'),
                                    icon: Icons.lock_outline_rounded,
                                    textInputAction: _isSignUp
                                        ? TextInputAction.next
                                        : TextInputAction.done,
                                    autofillHints: [
                                      _isSignUp
                                          ? AutofillHints.newPassword
                                          : AutofillHints.password,
                                    ],
                                    obscureText: _obscurePassword,
                                    validator: _validatePassword,
                                    suffixIcon: IconButton(
                                      tooltip: language.t(
                                        _obscurePassword
                                            ? 'show_password'
                                            : 'hide_password',
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                    onFieldSubmitted: (_) {
                                      if (_isSignUp) {
                                        _confirmPasswordFocus.requestFocus();
                                      } else {
                                        _submit();
                                      }
                                    },
                                  ),
                                  if (_isSignUp) ...[
                                    const SizedBox(height: 14),
                                    AuthTextField(
                                      controller: _confirmPasswordController,
                                      focusNode: _confirmPasswordFocus,
                                      label: language.t('confirm_password'),
                                      icon: Icons.lock_reset_rounded,
                                      textInputAction: TextInputAction.done,
                                      autofillHints: const [
                                        AutofillHints.newPassword,
                                      ],
                                      obscureText: _obscureConfirmation,
                                      validator: _validateConfirmation,
                                      suffixIcon: IconButton(
                                        tooltip: language.t(
                                          _obscureConfirmation
                                              ? 'show_password'
                                              : 'hide_password',
                                        ),
                                        onPressed: () => setState(
                                          () => _obscureConfirmation =
                                              !_obscureConfirmation,
                                        ),
                                        icon: Icon(
                                          _obscureConfirmation
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                      ),
                                      onFieldSubmitted: (_) => _submit(),
                                    ),
                                  ] else
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _resetPassword,
                                        child: Text(
                                          language.t('forgot_password'),
                                        ),
                                      ),
                                    ),
                                  if (_feedbackMessage != null) ...[
                                    const SizedBox(height: 12),
                                    AuthFeedbackBanner(
                                      message: _feedbackMessage!,
                                      tone: _feedbackTone,
                                    ),
                                  ],
                                  const SizedBox(height: 22),
                                  FilledButton(
                                    key: const Key('auth-submit'),
                                    onPressed: _isLoading ? null : _submit,
                                    child: _isLoading
                                        ? const SizedBox.square(
                                            dimension: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Text(
                                            language.t(
                                              _isSignUp
                                                  ? 'create_account'
                                                  : 'sign_in',
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: _isLoading ? null : _toggleMode,
                                    child: Text(
                                      language.t(
                                        _isSignUp
                                            ? 'already_have_account'
                                            : 'no_account_yet',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.13),
        ),
        child: Icon(
          Icons.fingerprint_rounded,
          size: 42,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
