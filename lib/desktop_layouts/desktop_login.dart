import 'package:blasc/desktop_layouts/desktop_create_account.dart';
import 'package:blasc/desktop_layouts/desktop_password_reset.dart';
import 'package:blasc/global_vars/mobile_message.dart';
import 'package:blasc/routes/noTransitionRoute.dart';
import 'package:blasc/routes/popUpRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/desktop_layouts/desktop_dashboard.dart';
import 'package:blasc/responsive/responsive_layout.dart';

class DesktopLogin extends StatefulWidget {
  const DesktopLogin({Key? key}) : super(key: key);

  @override
  State<DesktopLogin> createState() => DesktopLoginState();
}

class DesktopLoginState extends State<DesktopLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // sing in method
  void _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
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

  // check if user is logged in
  void _verifyCredentials() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        if (!user.emailVerified) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text(
                  'That email has not been verified.',
                ),
              );
            },
          );
          return;
        }
        Constants.user = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('users')
            .doc(Constants.user!.uid)
            .update({
          'Verified': true,
        });
        dispose();
        Navigator.push(
          context,
          noTransitionRoute(
            builder: (context) => const ResponsiveLayout(
              DesktopDashboard(),
              MobileMessage(),
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
        currentWidth * 0.3,
        currentHeight * 0.3,
        currentWidth * 0.3,
        currentHeight * 0.3,
      ),
      child: Material(
        child: Center(
          child: FittedBox(
            child: Column(
              children: [
                // BLASC title
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                  ),
                  child: Text(
                    'BLASC',
                    style: TextStyle(
                      color: Constants.teal2,
                      fontSize: (currentHeight * 0.4) * 0.17,
                    ),
                  ),
                ),
                // email input
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                  ),
                  width: (currentWidth * 0.4) * 0.7,
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
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                  ),
                  width: (currentWidth * 0.4) * 0.7,
                  child: TextField(
                    obscureText: _hidePassword,
                    obscuringCharacter: '*',
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                        icon: Icon(_hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                // login button
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.15,
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
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
                        (currentWidth * 0.4) * 0.6 * 0.1,
                        (currentHeight * 0.4) * 0.25 * 0.15,
                        (currentWidth * 0.4) * 0.6 * 0.15,
                        (currentHeight * 0.4) * 0.25 * 0.15,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PopUpRoute(
                              builder: (context) => const ResponsiveLayout(
                                DesktopPasswordRecovery(),
                                MobileMessage(),
                              ),
                            ),
                          );
                        },
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
                        (currentWidth * 0.4) * 0.6 * 0.15,
                        (currentHeight * 0.4) * 0.25 * 0.15,
                        (currentWidth * 0.4) * 0.6 * 0.1,
                        (currentHeight * 0.4) * 0.25 * 0.15,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PopUpRoute(
                              builder: (context) => const ResponsiveLayout(
                                DesktopCreateAccount(),
                                MobileMessage(),
                              ),
                            ),
                          );
                        },
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
