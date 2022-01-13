import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instructions_app/data/database_helper.dart';
import 'package:instructions_app/main.dart';
import 'package:instructions_app/services/database.dart';
import 'package:instructions_app/services/firebaseAuth.dart';
import 'package:instructions_app/services/pushNotificationsManager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final List<String> choices = const <String> [
  'Logout' 
];

const mnuLogout = 'Logout';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username ,_name;
  bool _admin;
  final AuthService _auth = AuthService();
   //final PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
  // BuildContext _ctx;
    DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/home.jpg'),
  fit: BoxFit.cover,
);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 20.0);
  TextStyle itemStyle = TextStyle(color: Colors.black,fontFamily: 'Montserrat', fontSize: 16.0);
   //Notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _permissionGrant();  
    initializing(); 
     PushNotificationsManager pushNotificationsManager = PushNotificationsManager(context,flutterLocalNotificationsPlugin);    
    pushNotificationsManager.init();
  }

 void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
     SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  }

 Future<dynamic> onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
    // showDialog(
    //   context: context,
    //   builder: (_) => AlertDialog(
    //     title: Text(payLoad),
    //     content: Text("Payload: $payLoad"),
    //   ),
    // );
      print(payLoad);
      Navigator.of(context).pushNamed("/instructions");
      // runApp(new LoginApp());

    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payLoad) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text('Ok')),
      ],
    );
  }
  Future _showNotificationWithDefaultSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Post',
    'How to Show Notification in Flutter',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

void select (String value) async {
    //int result;
    switch (value) {
      case mnuLogout:
      _handleLogout();
        //logout();
        break;
     
      default:
    }
  }
  _loadUserInfo() async {
    //await pushNotificationsManager.init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
                  _username = (prefs.getString('username') ?? "");
                  _name = (prefs.getString('name') ?? "");
                  _admin = (prefs.getBool('admin')??false);   
                });
                print("user:"+_username);
      String uid = prefs.getString('uid') ?? "";
      String token = prefs.getString('token') ?? "";
      await DatabaseService(uid:uid).saveDeviceToken(token);
     //return _username;      
  }
 _permissionGrant() async {
      var microStatus = await Permission.microphone.status;
      var storageStatus = await Permission.storage.status;
    if (!microStatus.isGranted || !storageStatus.isGranted) {
      if (Theme.of(context).platform == TargetPlatform.android) {
          showDialog(
   context: context,
   builder: (BuildContext context) {
    return AlertDialog(
     title: Text("Some Permissions were Denied !!"),
     content:const Text('Please enabel Permission for microphone & storage'),
     actions: <Widget>[
       FlatButton(child: Text('Ok'),
       onPressed: () {
         openAppSettings();
         Navigator.pop(context);
      //    final AndroidIntent intent = AndroidIntent(
      //     action: 'android.settings.LOCATION_SOURCE_SETTINGS');
      //  intent.launch();
      //  Navigator.of(context, rootNavigator: true).pop();
      //  _gpsService();
      })],
     );
   });
      }
      
    }

    // You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
 }
  void _handleLogout() async {
        await _auth.signOut();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("name");
        //prefs.clear();
        // var db = new DatabaseHelper();
        // await db.deleteUsers();   
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('/login'));
  }
Future<bool> _onBackPressed() {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit an App'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("NO"),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Text("YES"),
        ),
      ],
    ),
  ) ??
      false;
}
// Future<void> logout()
// async {
//   var db = new DatabaseHelper();
//     await db.deleteUsers();   
//     // var authStateProvider = new AuthStateProvider();
//     // authStateProvider.notify(AuthState.LOGGED_OUT); 
//      //Navigator.of(context).pushReplacementNamed("/");
//       Navigator.pushNamedAndRemoveUntil(
//             context, '/login', ModalRoute.withName('/login'));
//     //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
//     // Navigator.pushAndRemoveUntil(
//     // context,
//     // MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
//     // ModalRoute.withName('/'));
//     // Navigator.push(context, 
//     //     MaterialPageRoute(builder: (context) => LoginScreen()),
//     // );    
//     //Navigator.of(_ctx).popAndPushNamed("/login");
// }
  @override
  Widget build(BuildContext context) {  
    // final usr = Provider.of<User>(context);
    // print(usr);
  //  PushNotificationsManager pushNotificationsManager = PushNotificationsManager(context);    
  //   pushNotificationsManager.init();
    //  PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
    //  pushNotificationsManager.init();
    if(_admin==null)
    _admin = false;
    // if(pushNotificationsManager== null)
    // pushNotificationsManager = new PushNotificationsManager(context);
    // TODO: implement build
    //_ctx = context;
     //_loadUserInfo();
     var drawer =   Drawer(       
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Welcome " + _name,style: style),
              accountEmail: Text(_username+"@mcit.gov.eg"),
              decoration:  BoxDecoration(
                color: Colors.deepOrange,
              ),
              currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              // Theme.of(context).platform == TargetPlatform.iOS
              //   ? Colors.blue
              //   : Colors.white,
                child: Text(
                  _name[0],
                  style: TextStyle(fontSize: 40.0),
                ),
  ),
),
            // DrawerHeader(
            //   child: Text("Welcome " + _name,style: style),
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            // ),
            ListTile(
              title: Text('Seems',style: itemStyle),
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.verified_user),
              onTap: () {
                Navigator.of(context).pushNamed("/instructions");
                //Navigator.pop(context);
              },
            ),
            Visibility( 
        visible: _admin,
        child: ListTile(
               title: Text('Groups',style: itemStyle),
               trailing: Icon(Icons.arrow_forward),
               leading: Icon(Icons.supervised_user_circle),
              onTap: () {
                Navigator.of(context).pushNamed("/instructionUser");
                //Navigator.pop(context);
              },
            ))
           ,
           Visibility( 
        visible: _admin,
        child: ListTile(
               title: Text('Send Seems',style: itemStyle),
               trailing: Icon(Icons.arrow_forward),
               leading: Icon(Icons.send),
              onTap: () {
                Navigator.of(context).pushNamed("/sendinstruction");
                //Navigator.pop(context);
              },
            ),
      
        ),
          
              ],
        ),
         );
       
    //  return StreamProvider<List<User>>.value(
    //   value: DatabaseService().users,
    //   child:);
    return  Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
        backgroundColor: Colors.deepOrange,
       actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ], 
      ),  
      drawer:drawer,        
      body: new Container(
        //margin: EdgeInsets.only(left:5.0,right: 20.0),
        //padding: EdgeInsets.only(left:20.0,right: 20.0),
        decoration: BoxDecoration(
        image: backgroundImage
      //   DecorationImage(
      //     image: 
      //     NetworkImage('https://images.unsplash.com/photo-1547665979-bb809517610d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80'),
      //     fit: BoxFit.cover
      //   ) ,
       ),
        child:Center(        
        child: new  Text("Welcome " + _name ,style: itemStyle,),
      )
      )
     
    );
  
    //   return new WillPopScope(
    // onWillPop:_onBackPressed,
    // child: 
      // return new Scaffold(
    //     key: scaffoldKey,
    //     appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //     title: Text("Home"),
    //     actions: <Widget>[
    //       PopupMenuButton<String>(
    //         onSelected: select,
    //         itemBuilder: (BuildContext context) {
    //           return choices.map((String choice){
    //             return PopupMenuItem<String>(
    //               value: choice,
    //               child: Text(choice),
    //             );
    //           }).toList();
    //         },
    //       ),
    //     ],
    //   ),
    
      // body: new Center(
      //   child: new  Text("Welcome " + _username + ". This is the home screen"),
      // ));
     
     
      //  Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text("Welcome " + _username + ". This is the home screen"),
      //       RaisedButton(
      //         onPressed: _handleLogout,
      //         child: Text("Logout"),
      //       )
      //     ],
      //   ));
    
  }

} 


  //  Visibility( 
  //       visible: _admin,
  //       child: ListTile(
  //              title: Text('Users Active',style: itemStyle),
  //              trailing: Icon(Icons.arrow_forward),
  //              leading: Icon(Icons.people),
  //             onTap: () {
  //               Navigator.of(context).pushNamed("/users");
  //               //Navigator.pop(context);
  //             },
  //           ),
      
  //       ),
          
  //          ListTile(
  //              title: Text('Notification',style: itemStyle),
  //              trailing: Icon(Icons.arrow_forward),
  //              leading: Icon(Icons.notifications),
  //             onTap: () {
  //               Navigator.of(context).pushNamed("/notification");
  //               //Navigator.pop(context);
  //             },
  //           ),

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String _username;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserInfo();
//   }

//   _loadUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _username = (prefs.getString('username') ?? "");
//   }

//   void _handleLogout() async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.remove("username");
//         Navigator.pushNamedAndRemoveUntil(
//             context, '/login', ModalRoute.withName('/login'));
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Home"),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text("Welcome " + _username + ". This is the home screen"),
//             RaisedButton(
//               onPressed: _handleLogout,
//               child: Text("Logout"),
//             )
//           ],
//         ));
//   }
// }


