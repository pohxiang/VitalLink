import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:vitallinkv2/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitallinkv2/screens/forgetpass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Demo',
      home: const getstarted(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class getstarted extends StatefulWidget {
  const getstarted({Key? key}) : super(key: key);

  @override
  State<getstarted> createState() => _getstartedState();
}

class _getstartedState extends State<getstarted> {
  final _formKey = GlobalKey<FormState>();
  final SingleValueDropDownController _cnt = SingleValueDropDownController();

  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  // Password validation booleans
  bool _isLengthValid = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _isLengthValid = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _cnt.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildPasswordRequirement(
      {required bool condition, required String text}) {
    return Row(
      children: [
        Icon(
          condition ? Icons.check_circle : Icons.radio_button_unchecked,
          color: condition ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      controller: _passwordController,
                      border: PasswordBorder(
                        border: OutlineInputBorder(),
                      ),
                      hintText: 'Password',
                      errorMessage: 'Password must meet requirements',
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.grey.shade200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Password must contain:"),
                          _buildPasswordRequirement(
                              condition: _isLengthValid,
                              text: "At least 8 characters"),
                          _buildPasswordRequirement(
                              condition: _hasUppercase,
                              text: "One uppercase letter"),
                          _buildPasswordRequirement(
                              condition: _hasLowercase,
                              text: "One lowercase letter"),
                          _buildPasswordRequirement(
                              condition: _hasDigit, text: "One number"),
                          _buildPasswordRequirement(
                              condition: _hasSpecialChar,
                              text: "One special character"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // PasswordField(
                    //   controller: _confirmPasswordController,
                    //   border: PasswordBorder(
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   hintText: 'Confirm Password',
                    //   errorMessage: 'Passwords do not match',
                    // ),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropDownTextField(
                      controller: _cnt,
                      clearOption: true,
                      enableSearch: true,
                      textFieldDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Country',
                      ),
                      dropDownList: const [
                        DropDownValueModel(name: 'Australia', value: '1'),
                        DropDownValueModel(name: 'Brazil', value: '2'),
                        DropDownValueModel(name: 'Canada', value: '3'),
                        DropDownValueModel(name: 'China', value: '4'),
                        DropDownValueModel(name: 'France', value: '5'),
                        DropDownValueModel(name: 'Germany', value: '6'),
                        DropDownValueModel(name: 'India', value: '7'),
                        DropDownValueModel(name: 'Italy', value: '8'),
                        DropDownValueModel(name: 'Japan', value: '9'),
                        DropDownValueModel(name: 'Malaysia', value: '10'),
                        DropDownValueModel(name: 'South Korea', value: '11'),
                        DropDownValueModel(name: 'United Kingdom', value: '12'),
                        DropDownValueModel(name: 'United States', value: '13'),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a country';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Added Login button above Sign Up button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const loginpage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 35),
                      ),
                      child: const Text('Login Instead'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // check for confirm password
                        // if (_formKey.currentState!.validate()) {
                        //   if (_passwordController.text !=
                        //       _confirmPasswordController.text) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text('Passwords do not match'),
                        //       ),
                        //     );
                        //   } else {
                        //     // TODO: Implement sign up logic
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text('Processing Sign Up'),
                        //       ),
                        //     );
                        //   }
                        // }

                        // Firebase sign up
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Sign Up'),
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
}
