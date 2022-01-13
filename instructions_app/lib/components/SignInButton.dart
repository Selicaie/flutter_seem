import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  TextStyle style;
  SignIn({this.style});
  @override
  Widget build(BuildContext context) {
    return 
     Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color.fromRGBO(247, 64, 106, 1.0),//Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // (new Container(
    //   width: 320.0,
    //   height: 60.0,
    //   alignment: FractionalOffset.center,
    //   decoration: new BoxDecoration(
    //     color: const Color.fromRGBO(247, 64, 106, 1.0),
    //     borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
    //   ),
    //   child: new Text(
    //     "Sign In",
    //     style: new TextStyle(
    //       color: Colors.white,
    //       fontSize: 20.0,
    //       fontWeight: FontWeight.w300,
    //       letterSpacing: 0.3,
    //     ),
    //   ),
    // ));
  }
}
