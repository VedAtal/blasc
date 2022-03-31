import 'package:blasc/global_vars/mobile_message.dart';
import 'package:blasc/routes/noTransitionRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/desktop_layouts/desktop_dashboard.dart';
import 'package:blasc/responsive/responsive_layout.dart';

class DesktopCreateAccount extends StatefulWidget {
  const DesktopCreateAccount({Key? key}) : super(key: key);

  @override
  State<DesktopCreateAccount> createState() => DesktopCreateAccountState();
}

class DesktopCreateAccountState extends State<DesktopCreateAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // create account method
  void _createAccount() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      dispose();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'The password provided is too weak.',
              ),
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'The account already exists for that email.',
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

  // verify that user is signed in
  void _verifyCredentials() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Constants.user = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('users')
            .doc(Constants.user!.uid)
            .set({
          'UID': Constants.user!.uid,
          'Email': Constants.user!.email,
        });
        Navigator.push(
          context,
          noTransitionRoute(
            builder: ((context) => const ResponsiveLayout(
                  DesktopDashboard(),
                  MobileMessage(),
                )),
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
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                // confirm password input
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                    ((currentWidth * 0.4) * 0.7) * 0.1,
                    ((currentHeight * 0.4) * 0.25) * 0.1,
                  ),
                  width: (currentWidth * 0.4) * 0.7,
                  child: TextField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                // create button
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
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text(
                                'The passwords do not match.',
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                        return;
                      }
                      _createAccount();
                      _verifyCredentials();
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontSize: (currentHeight * 0.075) * 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
