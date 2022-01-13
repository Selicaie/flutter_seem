import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instructions_app/components/InputFields.dart';
import 'package:instructions_app/components/SignInButton.dart';
import 'package:instructions_app/components/WhiteTick.dart';
import 'package:instructions_app/data/database_helper.dart';
import 'package:instructions_app/models/UserResponse.dart';
import 'package:instructions_app/models/user.dart';
import 'package:instructions_app/models/users.dart';
import 'package:instructions_app/screens/home/home_screen.dart';
import 'package:instructions_app/services/database.dart';
import 'package:instructions_app/services/firebaseAuth.dart';
import 'package:instructions_app/services/local_auth_api.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alice/alice.dart';
import '../../auth.dart';
import 'package:instructions_app/utils/connect_screen_presenter.dart';

import '../../globals.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);
  AuthASP auth = new AuthASP(new Alice(showNotification: false));
  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

// class LoginScreenState extends State<LoginScreen>  implements ConnectScreenContract , AuthStateListener {
  class LoginScreenState extends State<LoginScreen>  implements ConnectScreenContract  {
  //BuildContext _ctx;
  // Initially password is obscure
  bool _obscureText = true;
  bool _isLoading = false;
  bool _isAuth = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _username;
  final AuthService _auth = AuthService();
  UserIdentity _user = new UserIdentity();
 
@override
void initState(){
  super.initState();
  //change activity orintiation
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
  ]);
}
  ConnectScreenPresenter _presenter;
  LoginScreenState() {
    _presenter = new ConnectScreenPresenter(this);
    //var authStateProvider = new AuthStateProvider();
    //authStateProvider.subscribe(this);
  }
  Future<void> _submitLogin() async {
    final form = formKey.currentState;
    try{
                
        if (form.validate()) {
          setState(() => _isLoading = true);
          form.save();     
          
          UserResponse resp = await widget.auth.signIn(
                _username, _password);

            if (resp.error == '200') {
              setState(() => _isLoading = false);
              if(Globals.token!=null)
              {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("itoken", Globals.token);
                _presenter.doLogin(_username, _password);
                  print(Globals.token);
                  print("Token=>"+prefs.getString('itoken'));
                  
              }
            
              // _user = resp.user;
              // _showSnackBar("Welcome back "+_user.email);

              
      
            } else {
              setState(() => _isLoading = false);
              _showSnackBar("Error !!");
            }
        }
      
   
    }catch(ex){}
    
  }

  Future<void> _submit() async {   
    String user,password;
    try{
             SharedPreferences prefs = await SharedPreferences.getInstance();    
              user=(prefs.getString('username') ?? "");
              password=(prefs.getString('pass') ?? "");
              if(user == "" || password==""){return;}
              else{
                    UserResponse resp = await widget.auth.signIn( user, password);

                if (resp.error == '200') {
                  setState(() => _isLoading = false);
                  if(Globals.token!=null)
                  {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("itoken", Globals.token);
                    _presenter.doLogin(user, password);
                      print(Globals.token);
                      print("Token=>"+prefs.getString('itoken'));
                      
                  }
                
                } else {
                  setState(() => _isLoading = false);
                  _showSnackBar("Error !!");
                }
              }
      
   
    }catch(ex){}
    
  }

   void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  TextStyle style = TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 20.0);
//TextStyle textStyle = Theme.of(context).textTheme.title;
     Widget buildButton({
    @required String text,
    @required IconData icon,
    @required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
          shape: StadiumBorder()
        ),
        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
        
      );

   Widget buildAuthenticate(BuildContext context) => buildButton(
        text: 'Authenticate',
        icon: Icons.lock_open,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();
           setState(() => _isAuth = true);    
          if (isAuthenticated) {
             _submit();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    //_ctx = context;


DecorationImage tick = new DecorationImage(
  image: new ExactAssetImage('assets/tick.png'),
  fit: BoxFit.cover, 
);
DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/home.jpg'),
  fit: BoxFit.cover,
);
     final emailField = new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: new TextFormField(
        onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 2
                        ? "Username must have atleast 2 chars"
                        : null;
                  },             
      obscureText: false,      
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: new InputDecoration(
          icon: new Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintText: "ex:user",
          labelText: "UserName",
          labelStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding: const EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
      ),
    );

    //  final emailField2 =  
    //          TextFormField( 
    //   onSaved: (val) => _username = val,
    //               validator: (val) {
    //                 return val.length < 2
    //                     ? "Username must have atleast 2 chars"
    //                     : null;
    //               },             
    //   obscureText: false,
    //   style: style,
    //   decoration: InputDecoration(
    //       icon: new Icon(
    //         Icons.person_outline,
    //         color: Colors.white,
    //       ),
    //        errorStyle: TextStyle(
    //       fontSize: 12.0,
    //       color: Colors.white
    //       ),
    //       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    //       hintText: "ex:user",
    //       labelText: "UserName",
    //       labelStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
    //       hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),          
    //       border:
    //           OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
    //           borderSide: new BorderSide(color: Colors.white)
    //           )),
    // );
// new InputFieldArea(
//                 hint: "Username",
//                 obscure: false,
//                 icon: Icons.person_outline,
//               );
     final passwordField = new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: new TextFormField(
        onSaved: (val) => _password = val,
        obscureText: _obscureText,  
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: new InputDecoration(
          icon: new Icon(
           Icons.lock_outline,
            color: Colors.white,
          ),
          border: InputBorder.none,
           hintText: "Password",
          labelText: "Password",
          labelStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding: const EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
      ),
    );
    // final passwordField2 =  
    // TextFormField(
    //   onSaved: (val) => _password = val,
    //   obscureText: _obscureText,
    //   style: style,
    //   decoration: InputDecoration(         
    //      icon: new Icon(
    //         Icons.lock_outline,
    //         color: Colors.white,
    //       ),
    //       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    //       hintText: "Password",
    //       labelText: "Password",
    //       labelStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
    //       hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
    //       border:
    //           OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
    //           borderSide: new BorderSide(color: Colors.white)
    //           )),
    // );
    //  new InputFieldArea(
    //             hint: "Password",
    //             obscure: _obscureText,
    //             icon: Icons.lock_outline,
    //           );
//######
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _submitLogin,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
//  var loginButon = new RaisedButton(
//       onPressed: _submit,
//       child: new Text("LOGIN"),
//       color: Colors.primaries[0],
//     );
var loginForm = new Form(
          key: formKey,
          child:SingleChildScrollView(child: 
           Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Seems',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 40),
                    )),
                     new Tick(image: tick),
                // SizedBox(
                //   height: 155.0,
                //   child: Image.asset(
                //     "assets/logo.png",
                //     fit: BoxFit.contain,
                //   ),
                // ), 
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                 new FlatButton(
                onPressed: _toggle,
                //textTheme: ButtonTextTheme.primary,
                textColor: Colors.white,
                
                child: new Text(_obscureText ? "Show" : "Hide")),
                SizedBox(
                  height: 35.0,
                ),
                _isLoading ? new CircularProgressIndicator() : loginButon,//new SignIn(style:style),
                SizedBox(
                  height: 15.0,
                ),
                buildAuthenticate(context)               
                
              ],
            ),
)
             );
         
    return Scaffold(
      appBar: null,
      key: scaffoldKey,
      // resizeToAvoidBottomInset: true,//use
      body: Container(
        decoration: new BoxDecoration(
                image: backgroundImage,
              ),
        child:
        Center(
        child: Container(
         decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(162, 146, 199, 0.8),
                      const Color.fromRGBO(51, 51, 63, 0.9),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: loginForm ),
        ),
      
      ) 
      ),
       
    );
  }


  // @override
  // onAuthStateChanged(AuthState state) {
   
  //   //  if(state == AuthState.LOGGED_IN)  
  //   //   Navigator.pushNamedAndRemoveUntil(
  //   //         _ctx, '/home', ModalRoute.withName('/home'));   
  //       //Navigator.of(_ctx).pushReplacementNamed("/home");
  // }

@override
  void onError(String errorTxt) async{

    if(errorTxt == null)
      errorTxt = "Incorrect credentials !!";
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);    
  }

  @override
  void onSuccess(dynamic item) async {   
   
    User user =  item;
    _showSnackBar("Welcome back "+user.username);
    setState(() => _isLoading = false);
    print(user.username);
    // dynamic result = await _auth.signInWithEmailAndPassword(user.username+"@mcit.gov.eg", user.password);
    //                 if(result == null) {
    //                   setState(() {
    //                     error = 'Could not sign in with those credentials';
    //                   });}
    SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("username", user.username);
        prefs.setString("pass",user.password);
        prefs.setString("name", user.name);
        prefs.setString("id", user.id.toString());
        prefs.setBool("admin", user.admin);
        prefs.setString("uid", user.id.toString());
       
        try{
          await DatabaseService(uid: user.id.toString()).updateUserData(user.username,user.name,user.id);
        }catch(err){}
   //to sign in using firebase authantication     
   /* dynamic result = await _auth.signInAnon(user.username,user.name,user.id);
            if(result == null){
              print('error signing in');
            } else {
              print('signed in');
              print(result);
              print(result.uid);
              prefs.setString("uid", result.uid);
            }*/
    // user.date = new DateFormat.yMd().format(DateTime.now());
    // var db = new DatabaseHelper();  
    // await db.saveUser(user);
    // final userFuture = db.getUser(user.id);
    //   userFuture.then((result){
    //     List<User> userList = List<User>();
    //     int count = result.length;
    //     for (int i=0; i<count; i++) {
    //       todoList.add(Todo.fromObject(result[i]));
    //       debugPrint(todoList[i].title);
    //     }
    // var authStateProvider = new AuthStateProvider();    
    //  authStateProvider.notify(AuthState.LOGGED_IN);   
    Navigator.pushNamedAndRemoveUntil(
            context, '/home', ModalRoute.withName('/home'));
    // var u = await db.getUser(user.id);
    // print(u.username);
        
  }
  @override
dispose(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  super.dispose();
}
}
