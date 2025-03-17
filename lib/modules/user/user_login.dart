// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'user_home_page.dart'; // Import your UserHomePage

// class UserLoginPage extends StatefulWidget {
//   const UserLoginPage({super.key});

//   @override
//   State<UserLoginPage> createState() => _UserLoginPageState();
// }

// class _UserLoginPageState extends State<UserLoginPage> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//   String _email = '';
//   String _password = '';
//   String _errorMessage = '';

//   Future<void> _loginUser() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       try {
//         // Authenticate user with Firebase Authentication
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: _email,
//           password: _password,
//         );

//         // Verify the user exists in the Firestore 'user' collection
//         DocumentSnapshot userDoc = await _firestore
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .get();

//         if (userDoc.exists) {
//           // Navigate to User Home Page
//           Navigator.pushReplacement(
//             // ignore: use_build_context_synchronously
//             context,
//             MaterialPageRoute(builder: (context) => UserHomePage()),
//           );
//         } else {
//           setState(() {
//             _errorMessage = 'No user record found. Contact admin.';
//           });
//         }
//       } on FirebaseAuthException catch (e) {
//         setState(() {
//           _errorMessage = e.message ?? 'Login failed. Please try again.';
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   'Welcome Back!',
//                   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                         color: Colors.green.shade700,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               SizedBox(height: 20),
//               Image.asset(
//                 'asset/image/personal growth-bro.png',
//                 height: 250,
//               ),
//               // Email Field
//               const SizedBox(height: 20),
//               TextFormField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.email, color: Colors.teal),
//                   hintText: 'Email',
//                   filled: true,
//                   fillColor: Colors.green[50],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null ||
//                       !RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//                           .hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _email = value!,
//               ),
//               const SizedBox(height: 16),

//               // Password Field
//               const SizedBox(height: 8),

//               TextFormField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.lock, color: Colors.teal),
//                   suffixIcon: Icon(Icons.visibility, color: Colors.grey),
//                   hintText: 'Password',
//                   filled: true,
//                   fillColor: Colors.green[50],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty || value.length < 6) {
//                     return 'Password must be at least 6 characters long';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _password = value!,
//               ),
//               const SizedBox(height: 16),

//               // Error Message
//               if (_errorMessage.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: Text(
//                     _errorMessage,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ),

//               // Login Button
//               Center(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 130,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   onPressed: _loginUser,
//                   child: const Text(
//                     "Login",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 50,
//               //   child: ElevatedButton(
//               //     onPressed: _loginUser,
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: Colors.green,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(30),
//               //       ),
//               //     ),
//               //     child: Text(
//               //       'LOGIN',
//               //       style: TextStyle(
//               //           color: Colors.white,
//               //           fontSize: 18,
//               //           fontWeight: FontWeight.bold),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/modules/user/user_home_page.dart';
import 'package:plantcare/modules/user/user_signup.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _loginHandler() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found in records.')),
        );
        return;
      }

      // Navigate to User Home Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'Milky',
                    fontSize: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'asset/image/personal growth-bro.png',
                  height: 250,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.green),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.green[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.green[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.green),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Colors.green[300],
                          ),
                          onPressed: _isLoading ? null : _loginHandler,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('LOGIN',
                                  style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.green[400],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserSignupScreen(),
                        ),
                      );
                    },
                    child: const Text('SIGN UP',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
