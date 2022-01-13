import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:instructions_app/auth.dart';
import 'package:instructions_app/routes.dart';
import 'dart:async';


//void main() => runApp(new LoginApp());
Future<void> main() async {
   runApp(LoginApp());
 
}

class LoginApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instructions',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }


}


