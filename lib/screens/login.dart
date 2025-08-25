import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  final OutlineInputBorder _defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFFC14040), width: 1.0),
  );

  final OutlineInputBorder _focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFFC14040), width: 2.0),
  );

  bool isLoading = false;
  bool isGoogleLoading = false;

  void signInWithGoogle() async {
    setState(() {
      isGoogleLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.signInWithGoogle();

    if (result != null) {
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else {
      // Navigate or show success
      Navigator.pushReplacementNamed(context, '/navbar');
    }

    setState(() {
      isGoogleLoading = false;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result != null) {
        // Show snackbar on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        // Success: Navigate or show success
        Navigator.pushReplacementNamed(context, '/navbar');
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Hello there!',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Please sign in to your account',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* Email is required';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return '* Enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email address',
                      hintStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13.5,
                        horizontal: 20,
                      ),
                      border: _defaultBorder,
                      errorBorder: _errorBorder,
                      focusedErrorBorder: _focusedErrorBorder,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* Password is required';
                      }
                      if (value.length < 6) {
                        return '* Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13.5,
                        horizontal: 20,
                      ),
                      border: _defaultBorder,
                      errorBorder: _errorBorder,
                      focusedErrorBorder: _focusedErrorBorder,
                      suffixIcon: IconButton(
                        iconSize: 20,
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black45,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign In Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA42921),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 4,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Expanded(
                        child: Divider(thickness: 1, color: Color(0xFFDADADA)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Or',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(thickness: 1, color: Color(0xFFDADADA)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: isGoogleLoading ? null : signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0xFFECECEC)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: isGoogleLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 4,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/google_logo.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Continue with Google',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 18),

                  // Create Account
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: DefaultTextStyle(
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xFF595959),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Create new account'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
