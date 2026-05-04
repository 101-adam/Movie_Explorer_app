import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/auth_cubit.dart';
import 'home_screen.dart';
import '../../core/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(
                  email: state.user.email ?? '',
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.movie_creation_outlined, size: 32, color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'MOVIE EXPLORER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin ? 'Welcome Back' : 'Create Account',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin
                            ? 'Enter your credentials to access your private screening room.'
                            : 'Sign up to start exploring cinematic masterpieces.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      _buildLabel('EMAIL ADDRESS'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'name@example.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('PASSWORD'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureText,
                      ),
                      const SizedBox(height: 12),
                      if (_isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )
                      else
                        const SizedBox(height: 12),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = _passwordController.text.trim();
                          if (_isLogin) {
                            context.read<AuthCubit>().logIn(email: email, password: password);
                          } else {
                            context.read<AuthCubit>().signUp(email: email, password: password);
                          }
                        },
                        child: Text(_isLogin ? 'Log In' : 'Sign Up'),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? "Don't have an account? " : "Already have an account? ",
                            style: const TextStyle(color: AppTheme.textSecondaryColor),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? "Register" : "Log In",
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }
}
