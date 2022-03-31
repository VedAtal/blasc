import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/desktop_layouts/desktop_dashboard.dart';
import 'package:blasc/mobile_layouts/mobile_dashboard.dart';
import 'package:blasc/responsive/responsive_layout.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({Key? key}) : super(key: key);

  @override
  State<MobileLogin> createState() => MobileLoginState();
}

class MobileLoginState extends State<MobileLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      dispose();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'No user found for that email.',
              ),
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Wrong password provided for that user.',
              ),
            );
          },
        );
      } else if (_emailController.text == '') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Email cannot be blank.',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }
    }
  }

  void _verifyCredentials() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              DesktopDashboard(),
              MobileDashboard(),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: currentWidth * 0.01,
          )
        ],
        border: Border.all(
          color: Colors.black,
          width: 5,
        ),
      ),
      margin: EdgeInsets.fromLTRB(
        currentWidth * 0.1,
        currentHeight * 0.35,
        currentWidth * 0.1,
        currentHeight * 0.35,
      ),
      child: Material(
        child: Center(
          child: FittedBox(
            child: Column(
              children: [
                // BLASC title
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.1,
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.1,
                  ),
                  child: Text(
                    'BLASC',
                    style: TextStyle(
                      color: Constants.teal2,
                      fontSize: (currentHeight * 0.3) * 0.18,
                    ),
                  ),
                ),
                // username input
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.1,
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.1,
                  ),
                  width: (currentWidth * 0.8) * 0.85,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                // password input
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.1,
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.1,
                  ),
                  width: (currentWidth * 0.8) * 0.85,
                  child: TextField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                // login button
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.15,
                    ((currentWidth * 0.8) * 0.7) * 0.1,
                    ((currentHeight * 0.3) * 0.25) * 0.1,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Constants.teal2,
                      minimumSize: Size(
                        (currentWidth * 0.05),
                        (currentHeight * 0.075) * 0.6,
                      ),
                      maximumSize: Size(
                        (currentWidth * 0.2),
                        (currentHeight * 0.075) * 0.6,
                      ),
                    ),
                    onPressed: () {
                      _signIn();
                      _verifyCredentials();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: (currentHeight * 0.075) * 0.3,
                      ),
                    ),
                  ),
                ),
                // forgot password and create account
                Row(
                  children: [
                    // forgot password
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        (currentWidth * 0.8) * 0.6 * 0.1,
                        (currentHeight * 0.2) * 0.25 * 0.10,
                        (currentWidth * 0.8) * 0.7 * 0.1,
                        (currentHeight * 0.2) * 0.25 * 0.15,
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: (currentHeight * 0.4) * 0.04,
                          ),
                        ),
                      ),
                    ),
                    // create account
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        (currentWidth * 0.8) * 0.6 * 0.1,
                        (currentHeight * 0.3) * 0.25 * 0.10,
                        (currentWidth * 0.8) * 0.7 * 0.1,
                        (currentHeight * 0.3) * 0.25 * 0.15,
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: (currentHeight * 0.4) * 0.04,
                          ),
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
  }
}
