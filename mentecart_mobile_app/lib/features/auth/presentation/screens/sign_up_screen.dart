import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/social_login_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    context.read<AuthBloc>().add(AuthRegisterRequested(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          password: _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 18),
                const Text('Create account', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                const SizedBox(height: 6),
                const Text('Sign up to book trusted services easily', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                const SizedBox(height: 30),
                AuthInputField(label: 'Full Name', hintText: 'Enter your full name', icon: Icons.person_outline_rounded, controller: _fullNameController, keyboardType: TextInputType.name),
                const SizedBox(height: 16),
                AuthInputField(label: 'Email', hintText: 'Enter your email', icon: Icons.mail_outline_rounded, controller: _emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                AuthInputField(label: 'Phone Number', hintText: 'Enter your phone number', icon: Icons.phone_outlined, controller: _phoneNumberController, keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Password',
                  hintText: 'Create a password',
                  icon: Icons.lock_outline_rounded,
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                    icon: Icon(_isPasswordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: const Color(0xFF6B7280)),
                  ),
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  icon: Icons.lock_outline_rounded,
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmPasswordHidden,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _isConfirmPasswordHidden = !_isConfirmPasswordHidden),
                    icon: Icon(_isConfirmPasswordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: const Color(0xFF6B7280)),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                        activeColor: AppColors.primary,
                        side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.4),
                          children: [
                            TextSpan(text: 'Terms & Conditions', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                            TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (_acceptTerms && !isLoading) ? () => _handleSignUp(context) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: const Color(0xFFB8C7F5),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: isLoading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                            : const Text('Create Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 26),
                Row(children: [
                  const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('or sign up with', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                ]),
                const SizedBox(height: 22),
                SocialLoginButton(
                  title: 'Continue with Google',
                  onPressed: () {},
                  icon: const Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF4285F4))),
                ),
                const SizedBox(height: 14),
                SocialLoginButton(
                  title: 'Continue with Apple',
                  onPressed: () {},
                  icon: const Icon(Icons.apple_rounded, size: 24, color: Colors.black),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?', style: TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.only(left: 4),
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Sign In', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
