import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:empire_ios/auth.dart';
import '../main.dart';
import 'DesktopLoginSystem/DesktopLoginSystem.dart';

class DesktopVersionMain extends StatefulWidget {
  const DesktopVersionMain({Key? key}) : super(key: key);

  @override
  State<DesktopVersionMain> createState() => _DesktopVersionMainState();
}

class _DesktopVersionMainState extends State<DesktopVersionMain> {
  @override
  Widget build(BuildContext context) {
    // double fontSize = MediaQuery.of(context).size.width + MediaQuery.of(context).size.height;
    TextTheme _textTheme = Theme.of(context).textTheme.apply(fontSizeFactor: 1);
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UNIQUE',
        theme: ThemeData(
          textTheme: _textTheme,
        ),
        home: DesktopHomePage(),
      ),
    );
  }
}

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({Key? key}) : super(key: key);

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  late DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Somthing went wrong"),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              firebaseLoginuser = FirebaseAuth.instance.currentUser;
              return DesktopLoginSystem();
            } else {
              firebaseAuthfunction.SignInEmail("$firebEmail", "$firebpass");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading "),
                    Text("Please wait ", style: TextStyle(color: jsmColor)),
                  ],
                ),
              );
            }
          }),
    );
  }
}
