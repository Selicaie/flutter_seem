// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:instructions_app/components/InputFields.dart';
// import 'package:instructions_app/components/SignInButton.dart';
// import 'package:instructions_app/components/WhiteTick.dart';
// import 'package:instructions_app/data/database_helper.dart';
// import 'package:instructions_app/models/users.dart';

// import '../../auth.dart';
// import 'package:instructions_app/utils/connect_screen_presenter.dart';

// class LoginScreen2 extends StatefulWidget {
//   LoginScreen2({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   LoginScreenState2 createState() => LoginScreenState2();
// }

// class LoginScreenState2 extends State<LoginScreen2>  implements ConnectScreenContract, AuthStateListener {
//   BuildContext _ctx;
//   // Initially password is obscure
//   bool _obscureText = true;
//   bool _isLoading = false;
//   final formKey = new GlobalKey<FormState>();
//   final scaffoldKey = new GlobalKey<ScaffoldState>();
//   String _password, _username;

//   ConnectScreenPresenter _presenter;
//   LoginScreenState2() {
//     _presenter = new ConnectScreenPresenter(this);
//     var authStateProvider = new AuthStateProvider();
//     authStateProvider.subscribe(this);
//   }
//   void _submit() {
//     final form = formKey.currentState;

//     if (form.validate()) {
//       setState(() => _isLoading = true);
//       form.save();
//       _presenter.doLogin(_username, _password);
//     }
//   }

//   void _showSnackBar(String text) {
//     scaffoldKey.currentState
//         .showSnackBar(new SnackBar(content: new Text(text)));
//   }
 


//   // Toggles the password show status
//   void _toggle() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
//   TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
// //TextStyle textStyle = Theme.of(context).textTheme.title;
//  @override
//   Widget build(BuildContext context) {
//     _ctx = context;
//     var loginBtn = new RaisedButton(
//       onPressed: _submit,
//       child: new Text("LOGIN"),
//       color: Colors.primaries[0],
//     );
//     var loginForm = new Column(
//       children: <Widget>[
//         new Text(
//           "Login App",
//           textScaleFactor: 2.0,
//         ),
//         new Form(
//           key: formKey,
//           child: new Column(
//             children: <Widget>[
//               new Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: new TextFormField(
//                   onSaved: (val) => _username = val,
//                   validator: (val) {
//                     return val.length < 2
//                         ? "Username must have atleast 3 chars"
//                         : null;
//                   },
//                   decoration: new InputDecoration(labelText: "Username"),
//                 ),
//               ),
//               new Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: new TextFormField(
//                   onSaved: (val) => _password = val,
//                   decoration: new InputDecoration(labelText: "Password"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         _isLoading ? new CircularProgressIndicator() : loginBtn
//       ],
//       crossAxisAlignment: CrossAxisAlignment.center,
//     );

//     return new Scaffold(
//       appBar: null,
//       key: scaffoldKey,
//       body: new Container(
//         decoration: new BoxDecoration(
//           image: new DecorationImage(
//               image: new AssetImage("assets/login.jpg"),
//               fit: BoxFit.cover),
//         ),
//         child: new Center(
//           child: new ClipRect(
//             child: new BackdropFilter(
//               filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//               child: new Container(
//                 child: loginForm,
//                 height: 300.0,
//                 width: 300.0,
//                 decoration: new BoxDecoration(
//                     color: Colors.grey.shade200.withOpacity(0.5)),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }


//   @override
//   onAuthStateChanged(AuthState state) {
   
//     // if(state == AuthState.LOGGED_IN)
//     //   Navigator.of(_ctx).pushReplacementNamed("/home");
//   }

// @override
//   void onError(String errorTxt) {

//     if(errorTxt == null)
//       errorTxt = "Error!! Login Faild";
//     _showSnackBar(errorTxt);
//     setState(() => _isLoading = false);
//   }

//   @override
//   void onSuccess(dynamic user) async {    
//     _showSnackBar("Welcome back "+user.username);
//     setState(() => _isLoading = false);
//     var db = new DatabaseHelper();
//     await db.saveUser(user);
//     var authStateProvider = new AuthStateProvider();
//     authStateProvider.notify(AuthState.LOGGED_IN);       
//   }
// }
