import 'dart:async';
import 'dart:developer';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:instructions_app/components/Colors.dart';
import 'package:instructions_app/components/glowing_button.dart';
import 'package:instructions_app/components/player_widget.dart';
import 'package:instructions_app/data/rest_ds.dart';
import 'package:instructions_app/models/instructions.dart';
import 'package:instructions_app/models/instructionsUser.dart';
import 'package:instructions_app/models/services.dart';
import 'package:instructions_app/models/users.dart';
import 'package:instructions_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'dart:io' as io;
import 'dart:math';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

final List<String> choices = const <String> [
  'Save User & Back',
  'Delete User',
  'Back to Groups'
];

const mnuSave = 'Save User & Back';
const mnuDelete = 'Delete User';
const mnuBack = 'Back to Grpups';

class SendInstruction extends StatefulWidget {
  @override
  SendInstructionState createState() {
    return new SendInstructionState();
  }
}

class SendInstructionState extends State {
  InstructionUser instructionUser = new InstructionUser(0,'',0,0,'');
     DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/home2.jpg'),
  fit: BoxFit.cover,
);
 // SendInstructionState(this.instructionUser);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isSelected = [false, false, false];
  List<Instruction> instructions = List<Instruction>();    
  bool deleted,saved;
  int count = 0; 
  double _width = 0;
  Services _currentService; 
  RestDatasource api = new RestDatasource();
  List<User> userList = new List<User>() ;
  List<Services> serviceList = new List<Services>() ;
  TextEditingController messageController = TextEditingController();
  Instruction instruction;
  bool _showVoice;
  String uId;
  Recording _recording ;
  bool _isRecording ;
  bool _isLoading = false;
  LocalFileSystem localFileSystem;
  Timer _timer;
   @override
  void initState() {
    super.initState(); 
    this.localFileSystem = LocalFileSystem();
    _recording = new Recording();
    fetchServices();   
    _loadUserInfo();
    getData();
    setUpTimedFetch();
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
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit?'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("NO"),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          onTap: () {
            //_timer.cancel();
            Navigator.of(context).pop(true);},
          child: Text("YES"),
        ),
      ],
    ),
  ) ??
      false;
}
 _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(()=> uId = (prefs.getString('uid')??''));                   
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
                 
                    hint: Text(type == 1 ?'Select User':'Select Group'),
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
    
     return new WillPopScope(
    onWillPop:_onBackPressed,
    child: new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        // automaticallyImplyLeading: true,
        title: Text("Send Seems"),
           ),
      body://serviceModel());
      new Container(
        decoration: BoxDecoration(
        image: backgroundImage),
        child:
      Padding( 
        padding: EdgeInsets.only(top:10.0),
        child:    //getListButton(),     
        Stack(
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
           //physics: const NeverScrollableScrollPhysics(),          
          children:[            
            Column(
            children: <Widget>[
              // _appBar(),
              chatModel(),
              Flexible(
                child: 
                !_isLoading && instructions.length>0?instructioListItems(): Text(''), 
              ),
            
            ],
          ),
              
                  
        //      new Expanded(
        //     child:
              
        // ),
          ] 
        
        //   <Widget>[
           
        // //  Column(
        // //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        // //   mainAxisSize: MainAxisSize.max,
        // //   children: <Widget>[
                    
        // //                ],
        // //             ),
        //   //   SingleChildScrollView(child:
        //   //  )
        // //      new Expanded(
        // //     child:
        // //     !_isLoading && instructions.length>0?instructioListItems(): Text(''),
        // // ),
              
        //             ]
                    ),
                  ) 
                )));
              }
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
            children: <Widget>[
            Padding(
            padding: const EdgeInsets.only(top:5.0,right:1.0,left:15.0,bottom:1.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RaisedButton(
                    // elevation: 5.0,
                    onLongPress: () {
                    updateCurrentService(4,"YELLOW","#FFFF00");
                    sendWithoutTxt();
                    },
                    onPressed: () {updateCurrentService(4,"YELLOW","#FFFF00");},
                    //padding: EdgeInsets.all(25.0),
                    shape:StadiumBorder(), 
                   child: Text('Ready'),
                   textColor: Colors.white,
                    color: Colors.yellow,
                  ),                    
                SizedBox(width: 15),  
                RaisedButton(
                  // elevation: 5.0,
                   onLongPress: () {
                    updateCurrentService(11,"RED","#FF0000");
                    sendWithoutTxt();
                    },
                  onPressed: () {updateCurrentService(11,"RED","#FF0000");},
                   //padding: EdgeInsets.all(25.0),
                  shape:StadiumBorder(), 
                  child: Text('Coming down '),
                  textColor: Colors.white, 
                  color: Colors.red,
                ),
                SizedBox(width: 15),  
                RaisedButton(
                  // elevation: 5.0,
                  onLongPress: () {
                    updateCurrentService(16,"GREEN","#008000");
                    sendWithoutTxt();
                    },
                  onPressed: () {updateCurrentService(16,"GREEN","#008000");},
                  //padding: EdgeInsets.all(25.0),
                  shape:StadiumBorder(), 
                  child: Text('Entrance'),
                  textColor: Colors.white,
                  color: Colors.green,
                ),
               
            // GlowingButton(
            //         color1: Colors.yellow,
            //         color2: Colors.yellowAccent,
            //         text: 'Ready',
            //         onPressed: () {
            //            updateCurrentService(4,"YELLOW","#FFFF00");
            //            sendWithoutTxt();
            //         },
            //       ),
            // SizedBox(width: 15),
            // GlowingButton(
            //   color1: Colors.red,
            //   color2: Colors.redAccent,
            //   text: 'Coming down',
            //   onPressed: () {
            //     updateCurrentService(11,"RED","#FF0000");
            //     sendWithoutTxt();
            //   },
            // ),
            
              ],
            ),
          ),
            Padding(
            padding: const EdgeInsets.only(top:10.0,right:1.0,left:15.0,bottom:5.0),
            child: Center(
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ 
                  RaisedButton(
                    // elevation: 5.0,
                     onLongPress: () {
                    updateCurrentService(1,"PURPLE","#800080");
                    sendWithoutTxt();
                    },
                    onPressed: () {updateCurrentService(1,"PURPLE","#800080");},
                    //padding: EdgeInsets.all(25.0),
                   shape:StadiumBorder(), 
                   child: Text('Guest hurry'),
                   textColor: Colors.white,
                    color: Colors.purple,
                  ),
                  SizedBox(width: 15),
                  RaisedButton(
                    // elevation: 5.0,
                     onLongPress: () {
                    updateCurrentService(20,"BLACK","#000000");
                    sendWithoutTxt();
                    },
                    onPressed: () {updateCurrentService(20,"BLACK","#000000");},
                    //padding: EdgeInsets.all(25.0),
                    shape:StadiumBorder(),  
                   child: Text('An hour delay'),
                   textColor: Colors.white,
                    color: Colors.black,
                  ),
                  SizedBox(width: 15),
                    RaisedButton(
                  // elevation: 5.0,
                  onLongPress: () {
                    updateCurrentService(5,"ORANGE","#FFA500");
                    sendWithoutTxt();
                    },
                  onPressed: () {updateCurrentService(5,"ORANGE","#FFA500");},
                  //padding: EdgeInsets.only(top: _width/5,right: _width/5,left: _width/5,bottom: _width/5),
                  shape:StadiumBorder(), 
                  child: Text('IT Help '),
                  textColor: Colors.white, // foreground
                  // CircleBorder(
                  //     side: BorderSide(color: Colors.white)),
                  color: Colors.orange,
                  
                ),
                  //  GlowingButton(
                  //   color1: Colors.green,
                  //   color2: Colors.greenAccent,
                  //   text: 'Entrance',
                  //   onPressed: ()  {
                  //     updateCurrentService(16,"GREEN","#008000");
                  //     sendWithoutTxt();
                  //   },
                  // ),         
                  // SizedBox(width: 15),    
                  // GlowingButton(
                  //   color1: Colors.blue,
                  //   color2: Colors.blueAccent,
                  //   text: 'Move from home',
                  //   onPressed: () {
                  //     updateCurrentService(19,"BLUE","#0000FF");
                  //     sendWithoutTxt();
                  //   },
                  // ),
                   
                  
                  
                ],
              ),
            ),
          ),
    Padding(
            padding: const EdgeInsets.only(top:10.0,right:1.0,left:40.0,bottom:5.0),
            child: Center(
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [                 
                  RaisedButton(
                  // elevation: 5.0,
                   onLongPress: () {
                    updateCurrentService(19,"BLUE","#0000FF");
                    sendWithoutTxt();
                    },
                  onPressed: () {updateCurrentService(19,"BLUE","#0000FF");},
                  //padding: EdgeInsets.all(25.0),
                  shape:StadiumBorder(), 
                  child: Text('Move from home'),
                  textColor: Colors.white,
                  color: Colors.blue,
                ),  
                 SizedBox(width: 15),            
                  RaisedButton(
                    // elevation: 5.0,
                     onLongPress: () {
                    updateCurrentService(21,"GRAY","#808080");
                    sendWithoutTxt();
                    },
                    onPressed: () {updateCurrentService(21,"GRAY","#808080");},
                    //padding: EdgeInsets.all(25.0),
                   shape:StadiumBorder(), 
                   child: Text('Half an hour delay'),
                   textColor: Colors.white,
                    color: Colors.grey,
                  ),
                 
                  //   GlowingButton(
                  //   color1: Colors.grey,
                  //   color2: Colors.blueGrey,
                  //   text: 'Half an hour delay',
                  //   onPressed: ()  {
                  //     updateCurrentService(21,"GRAY","#808080");
                  //     sendWithoutTxt();
                  //   },
                  // ),
                  //  SizedBox(width: 15),
                  //   GlowingButton(
                  //   color1: Colors.purple,
                  //   color2: Colors.purpleAccent,
                  //   text: 'Guest hurry',
                  //   onPressed: () {
                  //      updateCurrentService(1,"PURPLE","#800080");
                  //      sendWithoutTxt();
                  //   },
                  // ),
               
                
                ],
              ),
            ),
          ),
      //  Padding(
      //       padding: const EdgeInsets.only(top:10.0,right:1.0,left:5.0,bottom:5.0),
      //       child: Center(
      //         child: new Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [                 
     
      //             GlowingButton(
      //               color1: Colors.orange,
      //               color2: Colors.orangeAccent,
      //               text: 'IT Help',
      //               onPressed: () {
      //                 updateCurrentService(5,"ORANGE","#FFA500");
      //                 sendWithoutTxt();
      //               },
      //             ),
                     
      //              SizedBox(width: 15),
      //                GlowingButton(
      //               color1: Colors.black,
      //               color2: Colors.black,
      //               text: 'An hour delay',
      //               onPressed: ()  {
      //                  updateCurrentService(20,"BLACK","#000000");
      //                  sendWithoutTxt();
      //               },
      //             ),
                   
                
      //           ],
      //         ),
      //       ),
      //     ),
      //       // Padding(
            // padding: EdgeInsets.only(top:15.0, bottom: 15.0, left: 35.0, right: 35.0),
            // child: 
            // getDropdown(serviceList,2) ),
             _currentService != null
                ? Text("Group: " + _currentService.name)
                : Text("No Group selected")
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
            style: textStyle,
             onSubmitted: (_) {
                send();
              },
            onChanged: (value)=> this.updateMessage(),
                        decoration: InputDecoration(
                          labelText: "Type Message...",
                          labelStyle: textStyle,
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
      semanticLabel: 'All persons recieved message',
    );
    else if(item.status == "1")
    return Icon(Icons.check,
    color: Colors.pink,
      size: 20.0,
      semanticLabel: 'Somebody recieved message',
    );
    else
    return Icon(Icons.access_time,
      color: Colors.pink,
      size: 20.0,
      semanticLabel: 'Nobody recieved message',
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
                        children: <Widget>[Icon(Icons.add), Text("Add")],
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
                      Toast.show("Instruction sent successfully!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    }                    
                    else
                    Toast.show("Failed to send instruction !!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    });
                }
                else
                    Toast.show("Please write message !!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
           
              }
              else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must select group !!")));
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
                      Toast.show("Instruction sent successfully!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    }                    
                    else
                    Toast.show("Failed to send instruction !!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    });
               
              }
              else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must select group !!")));
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
   _start() async {
    try {
      if( _currentService!=null)
          {
              if (await AudioRecorder.hasPermissions) {
        // if (_controller.text != null && _controller.text != "") {
        //   String path = _controller.text;
        //   if (!_controller.text.contains('/')) {
        //     io.Directory appDocDirectory =
        //         await getApplicationDocumentsDirectory();
        //     path = appDocDirectory.path + '/' + _controller.text;
        //   }
        //   print("Start recording: $path");
        //   await AudioRecorder.start(
        //       path: path, audioOutputFormat: AudioOutputFormat.AAC);
        // } else {
        //   await AudioRecorder.start();
        // }
        io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
        String path = appDocDirectory.path  ;
        // await AudioRecorder.start(
        //       path: path, audioOutputFormat: AudioOutputFormat.AAC);
        //AudioRecorder.prepare();
         await AudioRecorder.start(
                audioOutputFormat: AudioOutputFormat.WAV);
        //await AudioRecorder.start();
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
         // _showVoice = !isRecording;
        });
      } else {
              Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("You must accept permissions")));
          }
          }
          else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must Selet category")));
      }
      
    } catch (e) {
      print(e);
    }
  }

 _stop() async {
    var recording = await AudioRecorder.stop();
    Toast.show("Audio recording duration : ${_recording.duration.toString()}", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    
    print("Stop recording: ${recording.path}");
    
    bool isRecording = await AudioRecorder.isRecording;   
    File file = localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    String filename = file.path.split('/').last;
    setState(() => _isLoading = true);
     if( _currentService!=null)
    await api.uploadFile(filename,recording.path,_currentService.id).then((value) async {
       setState(() => _isLoading = false);
       if(uId!=null){
                      print('send message to user id:${uId}');
                      await DatabaseService(uid: uId).updateMessageData("Voice Message ..",_currentService.id.toString());
                     }
        Toast.show("Instruction sent successfully!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
    });
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
      //_showVoice = !isRecording;
    });
    getData();
   // _controller.text = recording.path;
  }           
void playRemoteFile(url){
    // AudioPlayer player = new AudioPlayer();
    //  int result = await player.play("https://bit.ly/2CH50TO");//await player.play(url);
    // if (result == 1) {
    //   // success
    // }
    // await player.play("'https://luan.xyz/files/audio/ambient_c_motion.mp3'");
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

// class HeaderWidget extends StatelessWidget {
//   final String text;

//   HeaderWidget(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.0),
//       child: Text(text),
//       color: Colors.grey[200],
//     );
//   }
// }
//  Widget serviceModel(){
//                return 
// Container(
//     child: CustomScrollView(
//       slivers: <Widget>[
//         SliverList(
//           delegate: SliverChildListDelegate(
//             [
//               HeaderWidget("Header 1"),
//               HeaderWidget("Header 2"),
//               HeaderWidget("Header 3"),
//               HeaderWidget("Header 4"),
//             ],
//           ),
//         ),
//         SliverList(
//           delegate: SliverChildListDelegate(
//             [
//               BodyWidget(Colors.blue),
//               BodyWidget(Colors.red),
//               BodyWidget(Colors.green),
//               BodyWidget(Colors.orange),
//               BodyWidget(Colors.blue),
//               BodyWidget(Colors.red),
//             ],
//           ),
//         ),
//         SliverGrid(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
//           delegate: SliverChildListDelegate(
            
//             [

//               BodyWidget(Colors.blue),
//               BodyWidget(Colors.green),
//               BodyWidget(Colors.yellow),
//               BodyWidget(Colors.orange),
//               BodyWidget(Colors.blue),
//               BodyWidget(Colors.red),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
   
//     //   Container(
//     //   color: Colors.white30,
//     //   child: GridView.count(
//     //       crossAxisCount: 4,
//     //       childAspectRatio: 1.0,
//     //       padding: const EdgeInsets.all(4.0),
//     //       mainAxisSpacing: 4.0,
//     //       crossAxisSpacing: 4.0,
//     //       children: <String>[
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
//     //       ].map((String url) {
//     //         return GridTile(
//     //             child: Image.network(url, fit: BoxFit.cover));
//     //       }).toList()),
//     // );
//              }
 
// class BodyWidget extends StatelessWidget {
//   final Color color;

//   BodyWidget(this.color);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child:Container(
//       height: 50.0,
//       color: color,
//       alignment: Alignment.center,
//     //   decoration: BoxDecoration(
//     //             borderRadius: BorderRadius.circular(15.0),
//     //             border: Border.all(
//     //                 color: Colors.green,
//     //                 width: 2.0
//     //             )),
//     //  child: Container(
//     // color: color,
//     //  height: 150.0
//     //  ),
//     ));
//   }
// }
