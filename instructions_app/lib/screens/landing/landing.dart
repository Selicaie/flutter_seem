import 'package:flutter/material.dart';
import 'package:instructions_app/data/database_helper.dart';
import 'package:instructions_app/models/users.dart';
import 'package:instructions_app/services/pushNotificationsManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _username = "";
 //final PushNotificationsManager pushNotificationsManager =  PushNotificationsManager();
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }
// _redirect() async {
//   var db = new DatabaseHelper();
//     var isLoggedIn = await db.isLoggedIn();
//     if(isLoggedIn)
//      Navigator.pushNamedAndRemoveUntil(
//           context, '/login', ModalRoute.withName('/login'));
//     else
//        Navigator.pushNamedAndRemoveUntil(
//           context, '/home', ModalRoute.withName('/home'));
// }
  _loadUserInfo() async {
    // await pushNotificationsManager.init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('name') ?? "");
    if (_username == "") {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else {     
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'));
    }
  }

  @override
  Widget build(BuildContext context) {  
    //  final user = Provider.of<User>(context);
    //   print(user);
    
    // return either the Home or Authenticate widget
    // if (user == null){
    //   return Authenticate();
    // } else {
    //   return Home();
    // }
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}