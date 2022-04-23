import 'package:blasc/global_vars/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DesktopPasswordRecovery extends StatefulWidget {
  const DesktopPasswordRecovery({Key? key}) : super(key: key);

  @override
  State<DesktopPasswordRecovery> createState() =>
      _DesktopPasswordRecoveryState();
}

class _DesktopPasswordRecoveryState extends State<DesktopPasswordRecovery> {
  Future<void> resetPassword(String email) async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text(
            'A password recovery has been sent to your email. Click\n'
            'the link to change your password to be able to login.',
            textAlign: TextAlign.center,
          ),
        );
      },
    ).then((value) => Navigator.pop(context));
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  final _emailController = TextEditingController();

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
                        (currentWidth * 0.1),
                        (currentHeight * 0.075) * 0.6,
                      ),
                    ),
                    onPressed: () {
                      if (_emailController.text.trim() == '') {
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
                      } else {
                        resetPassword(_emailController.text.trim());
                      }
                    },
                    child: Text(
                      'Continue',
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
