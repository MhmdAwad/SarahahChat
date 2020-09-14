import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sarahah_chat/ui/screens/AccountScreen.dart';
import 'package:sarahah_chat/ui/screens/AuthScreen.dart';
import 'package:sarahah_chat/ui/widgets/BottomNavItem.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) =>
              snapshot.hasData ? BottomNavItem() : AuthScreen()),
      routes: {
        AccountScreen.ROUTE_NAME: (ctx) => AccountScreen()
      },
    );
  }
}
