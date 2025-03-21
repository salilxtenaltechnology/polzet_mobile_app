import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(email: ''),
      },
    );
  }
}

class SignupScreen extends StatefulWidget {
  final String email;
  const SignupScreen({Key? key, required this.email}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // Added username controller

  // State variables
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isLoading = false;
  String _errorText = '';
  String _selectedCountryCode = '+91';
  String _selectedGender = 'male';

  // API Configuration
  final String _signupUrl = 'http://44.211.191.16:8080/api/registration';

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  Future<void> _signUp() async {
    setState(() => _errorText = '');

    // Validation checks
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _usernameController.text.isEmpty) { // Added username validation
      setState(() => _errorText = "All fields are required");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorText = "Passwords do not match!");
      return;
    }

    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[^\s]{8,}$');
    if (!passwordRegex.hasMatch(_passwordController.text)) {
      setState(() => _errorText = "Password must have 8+ characters with 1 letter, 1 number");
      return;
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(_phoneController.text)) {
      setState(() => _errorText = "Invalid phone number format (10 digits required)");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(_signupUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "dob": _dobController.text,
          "gender": _selectedGender,
          "username": _usernameController.text, // Use username from the controller
          "email": _emailController.text,
          "mobile_number": _phoneController.text,
          "country_code": _selectedCountryCode.replaceAll('+', ''),
          "password": _passwordController.text,
          "confirm_password": _confirmPasswordController.text
        }),
      ).timeout(const Duration(seconds: 15));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              duration: Duration(seconds: 3),
            ));
            } else {
        setState(() => _errorText = responseData['error']?.toString() ??
        'Server error (${response.statusCode})');
        }
            } on SocketException {
        setState(() => _errorText = 'Network error: Check internet connection');
        } on TimeoutException {
        setState(() => _errorText = 'Connection timeout');
        } catch (e) {
          setState(() => _errorText = 'Error: ${e.toString().replaceAll('Exception: ', '')}');
        } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: isSmallScreen ? screenWidth * 0.9 : 380,
            decoration: BoxDecoration(
              boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 20)],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 37),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "POLZET",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Create your account",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                    const SizedBox(height: 29),
                    buildTextField("First Name", _firstNameController, Icons.person),
                    buildTextField("Last Name", _lastNameController, Icons.person),
                    buildTextField("Username", _usernameController, Icons.person), // Added username field
                    buildDateOfBirthField(),
                    buildGenderField(),
                    buildPhoneNumberField(),
                    buildEmailField(),
                    buildPasswordField("Password", _passwordController, _isPasswordHidden, () {
                      setState(() => _isPasswordHidden = !_isPasswordHidden);
                    }),
                    buildPasswordField("Confirm Password", _confirmPasswordController,
                        _isConfirmPasswordHidden, () {
                          setState(() => _isConfirmPasswordHidden = !_isConfirmPasswordHidden);
                        }),
                    if (_errorText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.5),
                        child: Text(
                          _errorText,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.5),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF9B3046)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: _isLoading ? null : _signUp,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Color(0xFF9B3046))
                                : Text(
                              "Sign Up",
                              style: TextStyle(
                                color: const Color(0xFF9B3046),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Date of Birth",
                    hintStyle: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                  ),
                  onTap: _selectDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    hintText: "Gender",
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() => _selectedGender = newValue!);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedCountryCode,
                items: ['+1', '+91', '+44', '+81'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() => _selectedCountryCode = newValue!);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.email, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildPasswordField(String hint, TextEditingController controller,
      bool isHidden, VoidCallback toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: isHidden,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: toggleVisibility,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen Content')),
    );
  }
}