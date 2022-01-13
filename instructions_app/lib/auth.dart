import 'dart:async';

import 'dart:convert';
import 'dart:io';
import 'data/rest_ds.dart';
import 'globals.dart';

import 'package:http/http.dart' as http;
import 'package:alice/alice.dart';
import 'package:dio/dio.dart';

import 'models/UserResponse.dart';
import 'models/user.dart';
abstract class BaseAuth {


  Future<UserResponse> signIn(String email, String password);
  Future<UserResponse> register(UserIdentity user);
  ShowInspector();


}
/*
class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }
  Future<String> createUser(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }
  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
*/

class AuthASP  {
  AuthASP(this.alice);
  final Alice alice;

  Dio dio;

  Future<UserResponse> signIn(String email, String password) async {
    String targethost = '192.168.32.1';//'10.0.2.2';

    UserResponse resp = new UserResponse();
    var queryParameters = {
      'username': email,
      'password': password,

    };
    //we are using asp.net Identity for login/registration. the first time we
    //login we must obtain an OAuth token which we obtain by calling the Token endpoint
    //and pass in the email and password that the user registered with.
    try {

        var gettokenuri = new Uri(scheme: 'http',
            //      host: '10.0.2.2',
            port: 80,
            host: targethost,
            path: '/token');

        //the user name and password along with the grant type are passed the body as text.
        //and the contentype must be x-www-form-urlencoded
        var loginInfo = 'UserName=' + email + '&Password=' + password +
            '&grant_type=password';

        final response = await http
            .post(
              RestDatasource.BASE_URL+"/token",//"http://192.168.1.29/token",
              headers: {"Content-Type": "application/x-www-form-urlencoded"},
              body: loginInfo
        );
        alice.onHttpResponse(response);
        if (response.statusCode == 200) {
          resp.error = '200';
          final json = jsonDecode(response.body);
          Globals.token = json['access_token'] as String;
        }
        else {
          //this call will fail if the security stamp for user is null
          resp.error = response.statusCode.toString() + ' ' + response.body;
          return resp;
        }

    }


    catch (e){
      resp.error = e.message;
    }
    return   resp ;

  }


  //this call is has anonymous access so no need for access token
  Future<UserResponse> register(UserIdentity user) async {
    String targethost = '10.0.2.2';
    UserResponse resp = new UserResponse();
    String js;
    js = jsonEncode(user);

    //from the emulator 10.0.2.2 is mapped to 127.0.0.1  in windows

    var url1 = 'http://' + targethost + "/api/Account/Register";
    var url =  'http://10.0.2.2:52175/api/Account/Register';
    try {
      // final request = await client.p;
      final response = await http
          .post(url,

          headers: {"Content-Type": "application/json"},
          body: js)
          .then((response) {
        resp.error = '200';
        if ( response.statusCode != 200) {
          alice.onHttpResponse(response);
          resp.error = response.statusCode.toString() + ' ' + response.body;
        }
      });

    }  catch (e) {
      resp.error = e.message;
    }

    return resp;

  }
  Future<String> UserInfo() async {

    var url = new Uri(scheme: 'http',
      host: '10.0.2.2',
      port: 52175,

      path: '/api/Account/userinfo',
    );
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    String authorization = 'Bearer ' + Globals.token;
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: authorization},
    );
    alice.onHttpResponse(response);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['Email'];
    }
    else {
      // resp.error = response.reasonPhrase;
      return 'error';
    }
  }
  ShowInspector(){
    alice.showInspector();
  }
}


// import 'package:instructions_app/data/database_helper.dart';

// enum AuthState{ LOGGED_IN, LOGGED_OUT }

// abstract class AuthStateListener {
//   void onAuthStateChanged(AuthState state);
// }

// // A naive implementation of Observer/Subscriber Pattern. Will do for now.
// class AuthStateProvider {
//   static final AuthStateProvider _instance = new AuthStateProvider.internal();

//   List<AuthStateListener> _subscribers;

//   factory AuthStateProvider() => _instance;
//   AuthStateProvider.internal() {
//     _subscribers = new List<AuthStateListener>();
//     initState();
//   }

//   void initState() async {
//     var db = new DatabaseHelper();
//     var isLoggedIn = await db.isLoggedIn();
//     if(isLoggedIn)
//       notify(AuthState.LOGGED_IN);
//     else
//       notify(AuthState.LOGGED_OUT);
//   }

//   void subscribe(AuthStateListener listener) {
//     _subscribers.add(listener);
//   }

//   void dispose(AuthStateListener listener) {
//     for(var l in _subscribers) {
//       if(l == listener)
//          _subscribers.remove(l);
//     }
//   }

//   void notify(AuthState state) {
//     _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
//   }
// }