
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class SendCode extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Send Code"),
//       ),
//       body: Center(
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
//             Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: new Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 RaisedButton(
//                   elevation: 10.0,
//                   onPressed: () {},
//                   padding: EdgeInsets.all(38.0),
//                   shape: CircleBorder(
//                       side: BorderSide(color: Colors.white, width: 4.0)),
//                   color: Colors.orange,
//                 ),
//                 RaisedButton(
//                   elevation: 10.0,
//                   onPressed: () {},
//                   padding: EdgeInsets.all(38.0),
//                   shape: CircleBorder(
//                       side: BorderSide(color: Colors.white, width: 4.0)),
//                   color: Colors.red,
//                 ),
//                 RaisedButton(
//                   elevation: 10.0,
//                   onPressed: () {},
//                   padding: EdgeInsets.all(38.0),
//                   shape: CircleBorder(
//                       side: BorderSide(color: Colors.white, width: 4.0)),
//                   color: Colors.green,
//                 ),
//                 RaisedButton(
//                   elevation: 10.0,
//                   onPressed: () {},
//                   padding: EdgeInsets.all(38.0),
//                   shape: CircleBorder(
//                       side: BorderSide(color: Colors.white, width: 4.0)),
//                   color: Colors.blue,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: new Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   RaisedButton(
//                     elevation: 10.0,
//                     onPressed: () {},
//                     padding: EdgeInsets.all(38.0),
//                     shape: CircleBorder(
//                         side: BorderSide(color: Colors.white, width: 4.0)),
//                     color: Colors.pink,
//                   ),
//                   RaisedButton(
//                     elevation: 10.0,
//                     onPressed: () {},
//                     padding: EdgeInsets.all(38.0),
//                     shape: CircleBorder(
//                         side: BorderSide(color: Colors.white, width: 4.0)),
//                     color: Colors.purple,
//                   ),
//                   RaisedButton(
//                     elevation: 10.0,
//                     onPressed: () {},
//                     padding: EdgeInsets.all(38.0),
//                     shape: CircleBorder(
//                         side: BorderSide(color: Colors.white, width: 4.0)),
//                     color: Colors.grey,
//                   ),
//                   RaisedButton(
//                     elevation: 10.0,
//                     onPressed: () {},
//                     padding: EdgeInsets.all(38.0),
//                     shape: CircleBorder(
//                         side: BorderSide(color: Colors.white, width: 4.0)),
//                     color: Colors.yellow,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 50.0),
//             child: Text(
//               'Please enter this Code: ' + randomAlphaNumeric(14),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: TextField(
//               decoration: InputDecoration(hintText: 'Enter code'),
//             ),
//           ),
//           Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SizedBox(
//                     width: 200.0,
//                     height: 50,
//                     child: RaisedButton(
//                       color: Color(0xFF527DAA),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: const Text(
//                           'Send Code',
//                           style: TextStyle(fontSize: 20.0, color: Colors.white),
//                         ),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(18.0),
//                         //side: BorderSide(color: Colors.red)
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => MessageSent()),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SizedBox(
//                     width: 200.0,
//                     height: 50,
//                     child: RaisedButton(
//                       color: Colors.indigoAccent,
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           'Go back!',
//                           style: TextStyle(fontSize: 20.0, color: Colors.white),
//                         ),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(18.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ]),
//         ]),
//       ),
//     );
//   }
// }


//************* */

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:instructions_app/components/Colors.dart';
// import 'package:instructions_app/data/rest_ds.dart';
// import 'package:instructions_app/models/instructions.dart';
// import 'package:instructions_app/models/instructionsUser.dart';
// import 'package:instructions_app/models/services.dart';
// import 'package:instructions_app/models/users.dart';
// import 'package:instructions_app/services/database.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';

// import 'bind_user_instruction.dart';

// final List<String> choices = const <String> [
//   'Save User & Back',
//   'Delete User',
//   'Back to Groups'
// ];

// const mnuSave = 'Save User & Back';
// const mnuDelete = 'Delete User';
// const mnuBack = 'Back to Groups';

// class SendInstruction extends StatefulWidget {
//   @override
//   SendInstructionState createState() {
//     return new SendInstructionState();
//   }
// }

// class SendInstructionState extends State {
//   InstructionUser instructionUser = new InstructionUser(0,'',0,0,'');
//      DecorationImage backgroundImage = new DecorationImage(
//   image: new ExactAssetImage('assets/home2.jpg'),
//   fit: BoxFit.cover,
// );
//  // SendInstructionState(this.instructionUser);
//   List<bool> isSelected = [false, false, false];
//   bool deleted,saved;
//   Services _currentService; 
//   RestDatasource api = new RestDatasource();
//   List<User> userList = new List<User>() ;
//   List<Services> serviceList = new List<Services>() ;
//   TextEditingController messageController = TextEditingController();
//   Instruction instruction;
//   bool _showVoice;
//   String uId;
//    @override
//   void initState() {
//     super.initState(); 
    
//     fetchServices();   
//     _loadUserInfo();
//   }
//  _loadUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//      setState(()=> uId = (prefs.getString('uid')??''));                   
//   }
//   updateCurrent(dynamic value,int type){
//          if(type==1)
//          {          
//            debugPrint("Update user"+value.id.toString());   
//              instructionUser.userId = value.id;
//               setState((){
//             instructionUser = new InstructionUser(value.id, instructionUser.color,instructionUser.id, instructionUser.serviceId , instructionUser.name) ;
//             //_currentUser = value;
//          }); 

//             //  setState(()=> this._currentUser = value); 

//          }                    
//         else
//         {     
//            debugPrint("Update Service:"+value.id.toString());    
//          instructionUser.serviceId = value.id;  
//         // setState(()=> this._currentService = value); 
//          setState((){
//             instructionUser = new InstructionUser(instructionUser.userId, instructionUser.color, instructionUser.id, value.id, instructionUser.name) ;
//             _currentService = value;
//          }); 
//          debugPrint("Current Service:"+_currentService.name.toString());                                                     
//          }                   
//   }
//   Services getService(int id) {
//     print("Service Id:"+id.toString()); 
//     if(serviceList.length>0)
//     {
//       if(id>0)
//       {
//         var newItem = serviceList.where((item)=>item.id == id).first;
//         _currentService = newItem;
//          //setState(()=>  _currentService = newItem);     
//         print("Service Id:"+id.toString());        
//       }
       
//     }
//    return _currentService;  
      
//     }
  
//    fetchServices() {
//      api.fetchServices().then((lst) {   
//        print("List Count:"+lst.length.toString());  
//        setState(()=> serviceList = lst);  
//         return lst;
      
//     });//.catchError((error) => throw Exception('Failed to load internet')); 
//   }
// Widget getDropdown(List<dynamic> lst,int type) {
//   return DropdownButton<dynamic>(
//                     items: lst
//                         .map((item) => DropdownMenuItem<dynamic>(
//                               child: Row(children:
//           //                     ListTile(
//           //   onTap: () {},
//           //   leading: CircleAvatar(backgroundColor: Colors.primaries[0]),
//           //   title: Text(user.name),
//           // ),
//           <Widget>[
//                 type==2 ? new Icon(
//                   Icons.format_color_fill,
//                   color: HexColor(item.color),
//                 ):
//                  Text(''),
//                   Text(item.name)
//               ],
//                    ) ,         
//                               value: item,
//                             ))
//                         .toList(),
//                     value: getService(instructionUser.serviceId),
//                     onChanged: (value)=>updateCurrent(value,type),
//                     isExpanded: true,                  
                 
//                     hint: Text(type == 1 ?'Select User':'Select Group'),
//                   );
            
// }
//   @override
//   Widget build(BuildContext context) { 
//     if(_showVoice == null)
//       _showVoice = true;
//     if(instruction == null)
//        instruction = new Instruction(null, null, 0, null, null, null, false);  
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepOrange,
//         //automaticallyImplyLeading: false,
//         title: Text("Send Instructions"),
//            ),
//       body://serviceModel());
//       new Container(
//         decoration: BoxDecoration(
//         image: backgroundImage),
//         child:
//       Padding( 
//         padding: EdgeInsets.only(top:35.0, left: 1.0, right: 1.0),
//         child:         
//         ListView(children: 
//           <Widget>[
//             Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             chatModel(), 
                   
//                        ],
//                     ),
              
//                       ]),
//                   ) 
//                 ));
//               }
//   Widget chatModel(){
//     TextStyle textStyle = Theme.of(context).textTheme.title;
//      return Column(
//             children: <Widget>[
//             Padding(
//             padding: EdgeInsets.only(top:15.0, bottom: 15.0, left: 35.0, right: 35.0),
//             child: getDropdown(serviceList,2) ),
//              _currentService != null
//                 ? Text("Color: " + _currentService.name)
//                 : Text("No Group selected")
//        ,
//       Row(
//           children: <Widget>[
//  Visibility( 
//         visible: !_showVoice,
//         child:
//   MaterialButton(
//   onPressed: () {send();},
//   color: Colors.blue,
//   textColor: Colors.white,
//   child: Icon(
//     Icons.send,
//     size: 24,
//   ),
//   padding: EdgeInsets.all(5),
//   shape: CircleBorder(),
// ),
//  ),
//   Visibility( 
//         visible: _showVoice,
//         child: MaterialButton(
//   onPressed: () {},
//   color: Colors.blue,
//   textColor: Colors.white,
//   child: Icon(
//     Icons.mic,
//     size: 24,
//   ),
//   //padding: EdgeInsets.all(16),
//   shape: CircleBorder(),
// ),
   
//    ), 
//     Visibility( 
//         visible: _showVoice,
//         child: MaterialButton(
//   onPressed: () {},
//   color: Colors.red,
//   textColor: Colors.white,
//   child: Icon(
//     Icons.stop,
//     size: 24,
//   ),
//   //padding: EdgeInsets.all(16),
//   shape: CircleBorder(),
// ),
   
//    ),  
    
//              Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(top:8.0,right:8.0,bottom:8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text(
//                           '',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 20.0),
//                         ),
//                         Text(
//                           new DateFormat.yMd().format(DateTime.now()),
//                           style: TextStyle(color: Colors.black45),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 2.0),
//                       child:  TextField(
//             controller: messageController,
//             style: textStyle,
//             onChanged: (value)=> this.updateMessage(),
//                         decoration: InputDecoration(
//                           labelText: "Type Message",
//                           labelStyle: textStyle,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                           )
//                         ),
//                       ),
              
//                     )
//                   ],
//                 ),
//               ),
//             ),
           
//           ],
//         ),
    
//       Divider(),
//     ],
//   );
// }
   
//    send(){
//               if( _currentService!=null)
//               {
//                 if(instruction.message!=null)
//                 {
//                     instruction.serviceId = _currentService.id;
//                     api.sendInstruction(instruction).then((res) async {   
//                       debugPrint('Output:'+res.toString());
//                     if(res)
//                     {
//                       messageController.text = "";
//                      setState(() {
//                        _showVoice = true;
//                      }); 

//                      //final usr = Provider.of<User>(context);
//                      if(uId!=null){
//                       print('send message to user id:${uId}');
//                       await DatabaseService(uid: uId).updateMessageData(instruction.message,instruction.serviceId.toString());
//                      }
                      
//                       Toast.show("Instruction sent successfully!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//                     }                    
//                     else
//                     Toast.show("Failed to send instruction !!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
//                     });
//                 }
//                 else
//                     Toast.show("Please write message !!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
           
//               }
                 
//             }

//   updateMessage() {
//     setState(() {
//       if(messageController.text!=null && messageController.text !='')
//        _showVoice =false;
//        else 
//         _showVoice =true;
//     });
//     if(instruction!=null)
//     instruction.message = messageController.text;
//   }
              

// }
// // class HeaderWidget extends StatelessWidget {
// //   final String text;

// //   HeaderWidget(this.text);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(16.0),
// //       child: Text(text),
// //       color: Colors.grey[200],
// //     );
// //   }
// // }
// //  Widget serviceModel(){
// //                return 
// // Container(
// //     child: CustomScrollView(
// //       slivers: <Widget>[
// //         SliverList(
// //           delegate: SliverChildListDelegate(
// //             [
// //               HeaderWidget("Header 1"),
// //               HeaderWidget("Header 2"),
// //               HeaderWidget("Header 3"),
// //               HeaderWidget("Header 4"),
// //             ],
// //           ),
// //         ),
// //         SliverList(
// //           delegate: SliverChildListDelegate(
// //             [
// //               BodyWidget(Colors.blue),
// //               BodyWidget(Colors.red),
// //               BodyWidget(Colors.green),
// //               BodyWidget(Colors.orange),
// //               BodyWidget(Colors.blue),
// //               BodyWidget(Colors.red),
// //             ],
// //           ),
// //         ),
// //         SliverGrid(
// //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
// //           delegate: SliverChildListDelegate(
            
// //             [

// //               BodyWidget(Colors.blue),
// //               BodyWidget(Colors.green),
// //               BodyWidget(Colors.yellow),
// //               BodyWidget(Colors.orange),
// //               BodyWidget(Colors.blue),
// //               BodyWidget(Colors.red),
// //             ],
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
   
// //     //   Container(
// //     //   color: Colors.white30,
// //     //   child: GridView.count(
// //     //       crossAxisCount: 4,
// //     //       childAspectRatio: 1.0,
// //     //       padding: const EdgeInsets.all(4.0),
// //     //       mainAxisSpacing: 4.0,
// //     //       crossAxisSpacing: 4.0,
// //     //       children: <String>[
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //         'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
// //     //       ].map((String url) {
// //     //         return GridTile(
// //     //             child: Image.network(url, fit: BoxFit.cover));
// //     //       }).toList()),
// //     // );
// //              }
 
// // class BodyWidget extends StatelessWidget {
// //   final Color color;

// //   BodyWidget(this.color);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child:Container(
// //       height: 50.0,
// //       color: color,
// //       alignment: Alignment.center,
// //     //   decoration: BoxDecoration(
// //     //             borderRadius: BorderRadius.circular(15.0),
// //     //             border: Border.all(
// //     //                 color: Colors.green,
// //     //                 width: 2.0
// //     //             )),
// //     //  child: Container(
// //     // color: color,
// //     //  height: 150.0
// //     //  ),
// //     ));
// //   }
// // }
