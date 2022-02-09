import 'dart:async';
import 'dart:io'as io;
//import 'dart:developer';
//import 'package:audio_recorder/audio_recorder.dart';
// import 'package:button3d/button3d.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:instructions_app/components/Colors.dart';
import 'package:instructions_app/components/button3d.dart';
import 'package:instructions_app/components/glowing_button.dart';
import 'package:instructions_app/components/player_widget.dart';
import 'package:instructions_app/data/rest_ds.dart';
import 'package:instructions_app/models/instructions.dart';
import 'package:instructions_app/models/instructionsUser.dart';
import 'package:instructions_app/models/services.dart';
import 'package:instructions_app/models/users.dart';
import 'package:instructions_app/services/database.dart';
import 'package:instructions_app/services/firebaseAuth.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as path;
import 'dart:math';

import 'package:file/file.dart';
import 'package:file/local.dart';
//import 'package:path_provider/path_provider.dart';

final List<String> choices = const <String> [
  'Logout'
];

const mnuLogout = 'Logout';

class AdminHome extends StatefulWidget {
  @override
  AdminHomeState createState() {
    return new AdminHomeState();
  }
}

class AdminHomeState extends State {
  final AuthService _auth = AuthService();
  InstructionUser instructionUser = new InstructionUser(0,'',0,0,'');
     DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/bk2.png'),
  fit: BoxFit.cover,
);
 // AdminHomeState(this.instructionUser);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isSelected = [false, false, false];
  List<Instruction> instructions = List<Instruction>();    
  bool deleted,saved;
  int count = 0; 
  double _width = 0;
  String _username ,_name;
  Services _currentService; 
  RestDatasource api = new RestDatasource();
  List<User> userList = new List<User>() ;
  List<Services> serviceList = new List<Services>() ;
  TextEditingController messageController = TextEditingController();
  Instruction instruction;
  bool _showVoice;
  String uId;
  //Recording _recording ;
  bool _isRecording ;
  bool _isLoading = false;
  LocalFileSystem localFileSystem;
  TextStyle itemStyle = TextStyle(color: Colors.black,fontFamily: 'Montserrat', fontSize: 16.0);
  TextStyle style = TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 20.0);
  bool _admin;
  Timer _timer;
  FlutterSoundRecorder _myRecorder;
  String filePath;
  //final audioPlayer = AssetsAudioPlayer();
   @override
  void initState() {
    super.initState(); 
    this.localFileSystem = LocalFileSystem();
    //_recording = new Recording();
     _permissionGrant();  
    fetchServices();   
    _loadUserInfo();
    getData();
    setUpTimedFetch();
    startIt();
  }

  void startIt() async {
    filePath = '/sdcard/Download/temp.AAC';
    _myRecorder = FlutterSoundRecorder();

    await _myRecorder.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
    //await initializeDateFormatting();

    // await Permission.microphone.request();
    // await Permission.storage.request();
    // await Permission.manageExternalStorage.request();
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
     title: Text("هناك بعض الصلاحيات لم يسرح بها !!",style: TextStyle(fontWeight: FontWeight.bold),),
     content:const Text('من فضلك اعطنا صلاحيات التخزين و الميكروفون',style: TextStyle(fontWeight: FontWeight.bold),),
     actions: <Widget>[
       FlatButton(child: Text('تم',style: TextStyle(fontWeight: FontWeight.bold),),
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

 setUpTimedFetch() {
     _timer = Timer.periodic(Duration(milliseconds: 20000 ), (timer) {
     api.getSpecificInstructions().then((List<Instruction> lst) {
      if(lst!=null)
      {
             
        setState(() {
                   instructions = lst;
                   count = instructions.length;
                  _isLoading = false;
                });
        debugPrint("Items " + count.toString());
      }
      else
      {
        Toast.show("No seems were found!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    }).catchError((error) => setState(() => _isLoading = false)); 

    });
    
  }
 getData()  { 
   api.getSpecificInstructions().then((List<Instruction> lst) {
      if(lst!=null)
      {
             
        setState(() {
                   instructions = lst;
                   count = instructions.length;
                  _isLoading = false;
                });
        debugPrint("Items " + count.toString());
      }
      else
      {
        Toast.show("No seems were found!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    }).catchError((error) => setState(() => _isLoading = false)); 

        //Toast.show("Load  instruction data failed!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM)
  }
Future<bool> _onBackPressed() {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('هل انت متاكد',style: TextStyle(fontWeight: FontWeight.bold),),
      content: new Text('هل تريد الخروج من التطبيق؟',style: TextStyle(fontWeight: FontWeight.bold),),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("لا",style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          onTap: () {
            //_timer.cancel();
            Navigator.of(context).pop(true);},
          child: Text("نعم",style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ],
    ),
  ) ??
      false;
}
 _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     //setState(()=> uId = (prefs.getString('uid')??'')); 
     setState(() {
                  _username = (prefs.getString('username') ?? "");
                  _name = (prefs.getString('name') ?? "");
                  uId = (prefs.getString('uid')??''); 
                  _admin = (prefs.getBool('admin')??false);    
                });                  
  }
  updateCurrent(dynamic value,int type){
         if(type==1)
         {          
           debugPrint("Update user"+value.id.toString());   
             instructionUser.userId = value.id;
              setState((){
            instructionUser = new InstructionUser(value.id, instructionUser.color,instructionUser.id, instructionUser.serviceId , instructionUser.name) ;
            //_currentUser = value;
         }); 

            //  setState(()=> this._currentUser = value); 

         }                    
        else
        {     
           debugPrint("Update Service:"+value.id.toString());    
         instructionUser.serviceId = value.id;  
        // setState(()=> this._currentService = value); 
         setState((){
            instructionUser = new InstructionUser(instructionUser.userId, instructionUser.color, instructionUser.id, value.id, instructionUser.name) ;
            _currentService = value;
         }); 
         debugPrint("Current Service:"+_currentService.name.toString());                                                     
         }                   
  }
  Services getService(int id) {
    print("Service Id:"+id.toString()); 
    if(serviceList.length>0)
    {
      if(id>0)
      {
        var newItem = serviceList.where((item)=>item.id == id).first;
        _currentService = newItem;
         //setState(()=>  _currentService = newItem);     
        print("Service Id:"+id.toString());        
      }
       
    }
   return _currentService;  
      
    }
  
  fetchServices() {
     api.fetchServices().then((lst) {   
       print("List Count:"+lst.length.toString());  
       setState(()=> serviceList = lst);  
        return lst;
      
    });//.catchError((error) => throw Exception('Failed to load internet')); 
  }
  Widget getDropdown(List<dynamic> lst,int type) {
  return DropdownButton<dynamic>(
                    items: lst
                        .map((item) => DropdownMenuItem<dynamic>(
                              child: Row(children:
          //                     ListTile(
          //   onTap: () {},
          //   leading: CircleAvatar(backgroundColor: Colors.primaries[0]),
          //   title: Text(user.name),
          // ),
          <Widget>[
                type==2 ? new Icon(
                  Icons.format_color_fill,
                  color: HexColor(item.color),
                ):
                 Text(''),
                  Text(item.name)
              ],
                   ) ,         
                              value: item,
                            ))
                        .toList(),
                    value: getService(instructionUser.serviceId),
                    onChanged: (value)=>updateCurrent(value,type),
                    isExpanded: true,                  
                 
                    hint: Text(type == 1 ?'اختار شخص':'اختار مجموعه',style: TextStyle(fontWeight: FontWeight.bold),),
                  );
            
}
  @override
  Widget build(BuildContext context) { 
    _width = MediaQuery.of(context).size.width;
    if(instructions == null)
    instructions = List<Instruction>();    
    if(_isRecording == null)
      _isRecording = false;
    if(_showVoice == null)
      _showVoice = true;
    if(instruction == null)
       instruction = new Instruction(null, null, 0, null, null, null, false);  
    
      var drawer =   Drawer(       
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("مرحبا بك  " + _name,style: style),
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
              title: Text('الرسائل',style: itemStyle),
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
               title: Text('مجموعه',style: itemStyle),
               trailing: Icon(Icons.arrow_forward),
               leading: Icon(Icons.supervised_user_circle),
              onTap: () {
                Navigator.of(context).pushNamed("/instructionUser");
                //Navigator.pop(context);
              },
            )) ,
         
              ],
        ),
         );
      
  return new WillPopScope(
    onWillPop:_onBackPressed,
    child: new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        // automaticallyImplyLeading: true,
        title: Text("ارسال رساله",style: TextStyle(fontWeight: FontWeight.bold),),
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
      body://serviceModel());
      SingleChildScrollView(
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
          image: backgroundImage
          ),
          child:
        Column(
        children: <Widget>[
          // _appBar(),
          chatModel(),
          Expanded(
            child:
            !_isLoading && instructions.length>0?instructioListItems(): Text(''),
          ),

        ],
          )
                  ),
      )));
              }

              Color color;
  Widget chatModel(){
    TextStyle textStyle = Theme.of(context).textTheme.headline1;
     final ButtonStyle flatButtonStyle = TextButton.styleFrom(
            primary: Colors.black87,
            minimumSize: Size(88, 36),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
          );
     return Column(
       mainAxisAlignment: MainAxisAlignment.center,

       children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button3d(
                    style: Button3dStyle(
                        topColor: Colors.yellow[400],
                        backColor: Colors.yellow[900],
                         borderRadius: BorderRadius.circular(50),
                        //borderRadius: BorderRadius.zero
                    ),
                    pressed_color: (col)=>color=col,pressed:color ==Colors.yellow[400] ,
                    height: 80,
                    width: 120,
                    onLongPressed: () {
                      setState(() {
                        updateCurrentService(4,"YELLOW","#FFFF00");
                        sendWithoutTxt();
                      });
                      },
                      onPressed: () {setState(() {
                        updateCurrentService(4,"YELLOW","#FFFF00");
                      });},
                    child: Text("مستعد",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),

                   Button3d(
                    style: Button3dStyle(
                        topColor: Colors.red[400],
                        backColor: Colors.red[900],
                         borderRadius: BorderRadius.circular(50),
                        //borderRadius: BorderRadius.zero
                    ),
                     pressed_color: (col)=>color=col,pressed:color ==Colors.red[400] ,
                    height: 80,
                    width: 120,
                     onLongPressed: () {
                      setState(() {
                        updateCurrentService(11,"RED","#FF0000");
                        sendWithoutTxt();
                      });
                      },
                    onPressed: () {setState(() {
                      updateCurrentService(11,"RED","#FF0000");
                    });},
                    child: Text("ينزل",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Button3d(
                  style: Button3dStyle(
                      topColor: Colors.purple[400],
                      backColor: Colors.purple[900],
                       borderRadius: BorderRadius.circular(50),
                      //borderRadius: BorderRadius.zero
                  ),
                  pressed_color: (col)=>color=col,pressed:color ==Colors.purple[400] ,
                  height: 80,
                  width: 120,
                  onLongPressed: () {
                    setState(() {
                      updateCurrentService(1,"PURPLE","#800080");
                      sendWithoutTxt();
                    });
                    },
                    onPressed: () {setState(() {
                      updateCurrentService(1,"PURPLE","#800080");
                    });},
                  child: Text("الضيوف",style: TextStyle(fontWeight: FontWeight.bold),),
                ),

                 Button3d(
                  style: Button3dStyle(
                      topColor: Colors.green[400],
                      backColor: Colors.green[900],
                       borderRadius: BorderRadius.circular(50),
                      //borderRadius: BorderRadius.zero
                  ),
                   pressed_color: (col)=>color=col,pressed:color ==Colors.green[400] ,
                  height: 80,
                  width: 120,
                   onLongPressed: () {
                    setState(() {
                      updateCurrentService(16,"GREEN","#008000");
                      sendWithoutTxt();
                    });
                    },
                  onPressed: () {setState(() {
                    updateCurrentService(16,"GREEN","#008000");
                  });},
                  child: Text("مدخل",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                 ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Button3d(
                  style: Button3dStyle(
                      topColor: Colors.black,
                      backColor: Colors.grey[800],
                       borderRadius: BorderRadius.circular(50),
                      //borderRadius: BorderRadius.zero
                  ),
                    pressed_color: (col)=>color=col,pressed:color ==Colors.black ,
                  height: 80,
                  width: 120,
                  onLongPressed: () {
                    setState(() {
                      updateCurrentService(20,"BLACK","#000000");
                      sendWithoutTxt();
                    });
                    },
                    onPressed: () {setState(() {
                      updateCurrentService(20,"BLACK","#000000");
                    });},
                  child: Text("تاخير ساعه",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white ),),

                ),

                 Button3d(
                  style: Button3dStyle(
                      topColor: Colors.orange[400],
                      backColor: Colors.orange[900],
                       borderRadius: BorderRadius.circular(50),
                      //borderRadius: BorderRadius.zero
                  ),
                   pressed_color: (col)=>color=col,pressed:color ==Colors.orange[400] ,
                  height: 80,
                  width: 120,
                 onLongPressed: () {
                    setState(() {
                      updateCurrentService(5,"ORANGE","#FFA500");
                      sendWithoutTxt();
                    });
                    },
                  onPressed: () {setState(() {
                    updateCurrentService(5,"ORANGE","#FFA500");
                  });},
                  child: Text("IT مساعد",style: TextStyle(fontWeight: FontWeight.bold),),
                ),


                ],
              ),
            ),
     
            Padding(
              padding: EdgeInsets.all(10),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 Button3d(
                  style: Button3dStyle(
                      topColor: Colors.blue[400],
                      backColor: Colors.blue[900],
                       borderRadius: BorderRadius.circular(50),
                      //borderRadius: BorderRadius.zero
                  ),
                   pressed_color: (col)=>color=col,pressed:color ==Colors.blue[400] ,
                  height: 80,
                  width: 120,
                  onLongPressed: () {
                    setState(() {
                      updateCurrentService(19,"BLUE","#0000FF");
                      sendWithoutTxt();
                    });
                    },
                  onPressed: () {setState(() {
                    updateCurrentService(19,"BLUE","#0000FF");
                  });},
                  child: Text("المنزل",style: TextStyle(fontWeight: FontWeight.bold),),
                ),

                 Button3d(
                  style: Button3dStyle(
                      topColor: Colors.grey[400],
                      backColor: Colors.blueGrey,
                       borderRadius: BorderRadius.circular(50),
                      //borderRadius: BorderRadius.zero
                  ),
                   pressed_color: (col)=>color=col,pressed:color ==Colors.grey[400] ,
                  height: 80,
                  width: 120,
                  onLongPressed: () {setState(() {
                    updateCurrentService(21,"GRAY","#808080");
                    sendWithoutTxt();
                  });},
                  onPressed: () {setState(() {
                    updateCurrentService(21,"GRAY","#808080");
                  });},
                  child: Text("تاخير نص ساعه",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                ],
              ),
            ),
     
             _currentService != null
                ? Text("Group: " + _currentService.name)
                : Text("لم تختار مجموعه",style: TextStyle(fontWeight: FontWeight.bold),)
       ,
      Row(children: <Widget>[
              Visibility( 
        visible: !_showVoice,
        child: _isLoading ? new CircularProgressIndicator() :    
  MaterialButton(
  onPressed: () {send();},
  color: Colors.blue,
  textColor: Colors.white,
  child: Icon(
    Icons.send,
    size: 32,
  ),
  //padding: EdgeInsets.all(2),
  shape: CircleBorder(),
),
  //  Container(
  //           width: 50.0,
  //           child: InkWell(
  //             onTap: send,
  //             child: Icon(
  //               Icons.send,
  //               color: Color(0xFFdd482a),
  //             ),))
 ),
              Visibility( 
        visible: _showVoice,
        child: _isLoading ? new CircularProgressIndicator() :
        MaterialButton(
  onPressed: () {!_isRecording ?_start():_stop();},
  color: !_isRecording ? Colors.blue:Colors.red,
  textColor: Colors.white,
  child: Icon(
    !_isRecording ?Icons.mic :Icons.stop,
    size: 24,
  ),
  //padding: EdgeInsets.all(16),
  shape: CircleBorder(),
),
   
   ), 
    // new Text(
    //               "Audio recording duration : ${_recording.duration.toString()}"),
   
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right:4.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0),
                        ),
                        Text(
                          new DateFormat.yMd().format(DateTime.now()),
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child:  TextField(
            controller: messageController,
            textInputAction: TextInputAction.send,
            //style: textStyle,
             onSubmitted: (_) {
                send();
              },
            onChanged: (value)=> this.updateMessage(),
                        decoration: InputDecoration(
                          labelText: "اكتب رسالتك...",
                          //labelStyle: textStyle,
                          //border: InputBorder.none,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )
                        ),
                      ),
              
                    )
                  ],
                ),
              ),
            ),
           
          ],
        ),
              
 
      Divider(),
    ],
  );
}
  ListView instructioListItems() {
    return ListView.builder(
      itemCount: count,
      //physics: const NeverScrollableScrollPhysics(),
      //reverse: true,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int position) {
        return generateColum(instructions[position],position);    
      },
    );
  }
  Widget generateColum(Instruction item,int position) => Card(
        //elevation: 1.0,
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor:  HexColor(item.color),
              child:Text((position+1).toString()),
              radius: 15,
            ),//Image.network(item.imageUrl),
          title: Text(
            item.message??'',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle:
              Text(item.time),
           onTap: () {
            submitTab(item);
          },
          //trailing:(item.url != null) ?PlayerWidget(url: item.url) : null   
           trailing:getIcon(item)
                
        ),
        shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
      );
  Widget getIcon(Instruction item){
    if(item.status == "2")
    return Icon(Icons.check_box,
    color: Colors.deepOrange,
      size: 20.0,
      semanticLabel: 'كل الاشخاص استلمت الرساله بنجاح',
    );
    else if(item.status == "1")
    return Icon(Icons.check,
    color: Colors.pink,
      size: 20.0,
      semanticLabel: 'بعض الاشخاص استلمت الرساله بنجاح',
    );
    else
    return Icon(Icons.access_time,
      color: Colors.pink,
      size: 20.0,
      semanticLabel: 'لم يستلم احد الرساله',
    );
  }
 
  getListButton() {

  return ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: _getListData() );
}
  _getListData() {
        List<Widget> widgets = [];

        for (int i = 0; i < 10; i++) {
          widgets.add(Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  FlatButton(
                      onPressed: () => {},
                      color: Colors.orange,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[Icon(Icons.add), Text("ضيف")],
                      )),
                ],
              )));
        }
        return widgets;
      }
  send(){
              if( _currentService!=null)
              {
                if(instruction.message!=null)
                {
                     setState(() => _isLoading = true);
                    instruction.serviceId = _currentService.id;
                    api.sendInstruction(instruction).then((res) async {   
                      debugPrint('Output:'+res.toString());
                    if(res)
                    {
                      messageController.text = "";
                     setState(() {
                       _isLoading = false;
                       _showVoice = true;
                     }); 

                     //final usr = Provider.of<User>(context);
                     if(uId!=null){
                      print('send message to user id:${uId}');
                      await DatabaseService(uid: uId).updateMessageData(instruction.message,instruction.serviceId.toString());
                     }
                      getData();
                      Toast.show("تم ارسال التعليمات بنجاح", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    }                    
                    else
                    Toast.show("فشل ارسال التعليمات", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    });
                }
                else
                    Toast.show("من فضلك اكتب رسالتك", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
           
              }
              else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("من فضلك اختار مجموعه")));
      }
                 
            }
  sendWithoutTxt(){
              if( _currentService!=null)
              {
                
                     setState(() => _isLoading = true);
                    instruction.serviceId = _currentService.id;
                    instruction.message = " ";
                    api.sendInstruction(instruction).then((res) async {   
                      debugPrint('Output:'+res.toString());
                    if(res)
                    {
                      messageController.text = "";
                     setState(() {
                       _isLoading = false;
                       _showVoice = true;
                     }); 

                     //final usr = Provider.of<User>(context);
                     if(uId!=null){
                      print('send message to user id:${uId}');
                      await DatabaseService(uid: uId).updateMessageData(instruction.message,instruction.serviceId.toString());
                     }
                      getData();
                      Toast.show("تم ارسال التعليمات بنجاح", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    }                    
                    else
                    Toast.show("فشل ارسال التعليمات", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    });
               
              }
              else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("من فضلك اختار مجموعه")));
      }
                 
            }
  randomNumber(int min,int max){
    Random rnd;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);
    return r;
  }
  updateMessage() {
    setState(() {
      if(messageController.text!=null && messageController.text !='')
       _showVoice =false;
       else 
        _showVoice =true;
    });
    if(instruction!=null)
    instruction.message = messageController.text;
  }
 //   _start() async {
 //    try {
 //      if( _currentService!=null) {
 //              if (await AudioRecorder.hasPermissions) {
 //        // if (_controller.text != null && _controller.text != "") {
 //        //   String path = _controller.text;
 //        //   if (!_controller.text.contains('/')) {
 //        //     io.Directory appDocDirectory =
 //        //         await getApplicationDocumentsDirectory();
 //        //     path = appDocDirectory.path + '/' + _controller.text;
 //        //   }
 //        //   print("Start recording: $path");
 //        //   await AudioRecorder.start(
 //        //       path: path, audioOutputFormat: AudioOutputFormat.AAC);
 //        // } else {
 //        //   await AudioRecorder.start();
 //        // }
 //        io.Directory appDocDirectory =
 //                await getApplicationDocumentsDirectory();
 //        String path = appDocDirectory.path  ;
 //        await AudioRecorder.start(
 //              path: path, audioOutputFormat: AudioOutputFormat.AAC);
 //        //  await AudioRecorder.start(
 //        //         audioOutputFormat: AudioOutputFormat.WAV);
 //        //await AudioRecorder.start();
 //        bool isRecording = await AudioRecorder.isRecording;
 //        setState(() {
 //          _recording = new Recording(duration: new Duration(), path: "");
 //          _isRecording = isRecording;
 //         // _showVoice = !isRecording;
 //        });
 //      } else {
 //              Scaffold.of(context).showSnackBar(
 //              new SnackBar(content: new Text("You must accept permissions")));
 //          }
 //          }
 //          else {
 //        Scaffold.of(context).showSnackBar(
 //            new SnackBar(content: new Text("You must Select category")));
 //      }
 //
 //    } catch (e) {
 //      print(e);
 //    }
 //  }
 //
 // _stop() async {
 //    var recording = await AudioRecorder.stop();
 //    Toast.show("Audio recording duration : ${_recording.duration.toString()}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
 //
 //    print("Stop recording: ${recording.path}");
 //
 //    bool isRecording = await AudioRecorder.isRecording;
 //    File file = localFileSystem.file(recording.path);
 //    print("  File length: ${await file.length()}");
 //    String filename = file.path.split('/').last;
 //    setState(() => _isLoading = true);
 //     if( _currentService!=null)
 //    await api.uploadFile(filename,recording.path,_currentService.id).then((value) async {
 //       setState(() => _isLoading = false);
 //       if(uId!=null){
 //                      print('send message to user id:${uId}');
 //                      await DatabaseService(uid: uId).updateMessageData("Voice Message ..",_currentService.id.toString());
 //                     }
 //        Toast.show("Instruction sent successfully!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
 //    });
 //    setState(() {
 //      _recording = recording;
 //      _isRecording = isRecording;
 //      //_showVoice = !isRecording;
 //    });
 //    getData();
 //   // _controller.text = recording.path;
 //  }

  Future<void> _start() async {
    if( _currentService!=null) {
    // // io.Directory dir = io.Directory(path.dirname(filePath)) ;
    //  io.Directory dir = await getApplicationDocumentsDirectory();
    //   filePath = dir.path+'/temp'  ;
    // if (!dir.existsSync()) {
    //   dir.createSync();
    // }
    // _myRecorder.openAudioSession();
    // await _myRecorder.startRecorder(
    //   toFile: filePath,
    //   codec: Codec.aacMP4,
    // );
    //
    // setState(() {
    //   _isRecording = _myRecorder.isRecording;
    //   print(_isRecording);
    //   // _recorderTxt = txt.substring(0, 8);
    // });
    //
    // StreamSubscription _recorderSubscription = _myRecorder.onProgress.listen((e) {
    //   var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds, isUtc: true);
    //   var txt =  date.toString();
    //   print(e.duration.inMilliseconds);
    // });
    // _recorderSubscription.cancel();
      startRecord();
    } else {
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("من فضلك اختار مجموعه")));}
  }

   _stop() async {
    // await _myRecorder.stopRecorder();
    // File file = await localFileSystem.file('/storage/emulated/0/Download/temp.AAC');
    //print("  File length: ${await file.length()}");
    //String filename = file.path.split('/').last;
    // io.File file = io.File(filePath);
    // String filename = file.path.split('/').last;
    // print(file.path+'...'+filename);
    // setState(() => _isLoading = true);
    // if( _currentService!=null)
    //   await api.uploadFile(filename,file.path,_currentService.id).then((value) async {
    //     print('value of uploading $value');
    //     setState(() { _isLoading = false;_isRecording=_myRecorder.isRecording;});
    //     if(uId!=null){
    //       print('send message to user id:${uId}');
    //       await DatabaseService(uid: uId).updateMessageData("Voice Message ..",_currentService.id.toString());
    //     }
    //     Toast.show("تم ارسال التعليمات بنجاح", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    //   });
    // _myRecorder.closeAudioSession();
     stopRecord();
  }


   startRecord() async {

      print("Recording...");
      recordFilePath = await getFilePath();
      setState(() {

      });
      setState(() {
        _isRecording = RecordMp3.instance.start(recordFilePath, (type) {
          print("Record error--->$type");
        });
      });

    }



  String recordFilePath;

   stopRecord() async {
    bool s = await RecordMp3.instance.stop();
    if(s && io.File(recordFilePath).existsSync()) {
      io.File file = io.File(recordFilePath);
      String filename = file.path
          .split('/')
          .last;
      print(file.path + '...' + filename);
      print("  File length: ${await file.length()}");
      setState(() => _isLoading = true);
      if (_currentService != null)
        await api.uploadFile(filename, file.path, _currentService.id).then((
            value) async {
          print('value of uploading $value');
          setState(() {
            _isLoading = false;
            _isRecording = _myRecorder.isRecording;
          });
          if (uId != null) {
            print('send message to user id:${uId}');
            await DatabaseService(uid: uId).updateMessageData(
                "Voice Message ..", _currentService.id.toString());
          }
          Toast.show(
              "تم ارسال التعليمات بنجاح", context, duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        });
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    io.Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = io.Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

void playRemoteFile(url){
   
    print('Play Now :'+ url);
     showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: PlayerWidget(url: url),
        );
      });
  }
updateCurrentService(int id,String name,String color){
debugPrint("Update Service:"+id.toString());    
         instructionUser.serviceId = id;  
        // setState(()=> this._currentService = value); 
         setState((){
            instructionUser = new InstructionUser(instructionUser.userId, instructionUser.color, instructionUser.id, id, instructionUser.name) ;
            _currentService = new Services(color,id,name) ;
});  
debugPrint("Current Service:"+_currentService.name.toString());
}
submitTab(Instruction item){
      //setState(()=>_isLoading = true);       
            getAcknowledgetUser(item.id.toString());
            debugPrint("Tapped on " + item.id.toString());
            //navigateToDetail(this.instructions[position]);
  }
String getNames(List<User> lst){
  String names=""  ;
         lst.forEach((user) => names=names + user.name+",");
          //lst.forEach((user) => print(user.name));
         if(names=="")
          names = "Not seen ...";
        print(names);
         return names;
}
 getAcknowledgetUser(String instructionId)  {  
    api.getAcknowledgeUsers(instructionId).then((List<User> lst) {
      if(lst!=null)
      {       
        showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                title: Text("Acknowledge Users !!"),
                content:Text(getNames(lst)),
                actions: <Widget>[
                  FlatButton(child: Text('Ok'),
                  onPressed: () {         
                    Navigator.pop(context);
                  //    final AndroidIntent intent = AndroidIntent(
                  //     action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                  //  intent.launch();
                  //  Navigator.of(context, rootNavigator: true).pop();
                  //  _gpsService();
                  })],
                );
   });
  
        // debugPrint("Items " + count.toString());
      }   
      else
      {
        Toast.show("No seems were found!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }   
    });
    //.catchError((error) => setState(() => _isLoading = false)); 
    //.catchError((Exception error) => Toast.show("Load  instruction data failed!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM)); 
  }
@override
dispose(){
 _timer.cancel();
  super.dispose();
}
}

