import 'package:blasc/global_vars/mobile_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blasc/responsive/responsive_layout.dart';
import 'package:blasc/desktop_layouts/desktop_homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCLN1ghb9ay7ayj1UWA_IjIz5tfPGJ0PrU",
      authDomain: "blasc-bs.firebaseapp.com",
      projectId: "blasc-bs",
      storageBucket: "gs://blasc-bs.appspot.com",
      messagingSenderId: "1000735333353",
      appId: "1:1000735333353:web:99a38bf6d298f565210978",
      measurementId: "G-21883JDWQP"
    ),
  );

  runApp(const BLASC());
}

class BLASC extends StatelessWidget {
  const BLASC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLASC',
      theme: ThemeData(
        textTheme: GoogleFonts.lexendTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const ResponsiveLayout(DesktopHomepage(), MobileMessage()),
    );
  }
}
