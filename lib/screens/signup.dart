import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'terms.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool isGoogleLoading = false;

  bool isChecked = false;
  bool isButtonClicked = false;

  void signUpWithGoogle() async {
    setState(() {
      isGoogleLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.signUpWithGoogle();

    if (result != null) {
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
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

  void submit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_formKey.currentState!.validate() && isChecked) {
      setState(() {
        isLoading = true;
      });
      final result = await authProvider.signup(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? 'Signup successful!'),
          backgroundColor: result == null ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      // clear fields if signup was successful
      if (result == null) {
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        Navigator.pop(context); // go back to login
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
                  const SizedBox(height: 30),
                  Text(
                    'Create Account',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: _inputDecoration('First Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? '* Required' : null,
                  ),
                  const SizedBox(height: 20),

                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: _inputDecoration('Last Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? '* Required' : null,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* Required';
                      } else if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value)) {
                        return '* Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: _inputDecoration(
                      'Password',
                      suffixIcon: IconButton(
                        iconSize: 20,
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* Required';
                      } else if (value.length < 6) {
                        return '* At least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Re-enter Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    decoration: _inputDecoration(
                      'Re-enter password',
                      suffixIcon: IconButton(
                        iconSize: 20,
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                            () => _showConfirmPassword = !_showConfirmPassword,
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* Required';
                      } else if (value != _passwordController.text) {
                        return '* Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // for giving privacy consent
                  Transform.translate(
                    offset: Offset(-12, 0),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(
                              color: Color(
                                0xFFEFEFEF,
                              ), // Light grey to match textfield border
                              width: 1.5,
                            ),
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color(
                                  0xFF55AC9F,
                                ); // Your custom checked color
                              }
                              return const Color(
                                0xFFF3F4F6,
                              ); // Grey when not selected
                            }),
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                        ),
                        DefaultTextStyle(
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              color: Color(0xFF494949),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Color(0xFF494949),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                              children: [
                                const TextSpan(
                                  text: "I acknowledge and accept the terms",
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TermsAndConditionsPage(),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.open_in_new_outlined,
                                        color: Color(0xFF5B84C2),
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isChecked && isButtonClicked)
                                  const TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Color(0xFFC14040),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Sign Up Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA42921),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              isButtonClicked = true;
                            });
                            submit();
                          },
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
                            'Sign up',
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
                    onPressed: isGoogleLoading ? null : signUpWithGoogle,
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

                  const SizedBox(height: 25),

                  // Already have an account?
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context); // Go back to login
                      },
                      child: DefaultTextStyle(
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xFF595959),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Already have an account?'),
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

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        textStyle: const TextStyle(color: Colors.black45, fontSize: 14),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 13.5,
        horizontal: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFC14040), width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFC14040), width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
