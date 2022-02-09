import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instructions_app/components/Colors.dart';
import 'package:instructions_app/data/rest_ds.dart';
import 'package:instructions_app/models/instructionsUser.dart';
import 'package:instructions_app/models/services.dart';
import 'package:instructions_app/models/users.dart';
import 'package:instructions_app/services/database.dart';

import 'bind_user_instruction.dart';

final List<String> choices = const <String> [
  'Save and Exit',
  'Delete User',
  'Back to Groups'
];

const mnuSave = 'Save and Exit';
const mnuDelete = 'Delete User';
const mnuBack = 'Back to Groups';

class UserInstructionDetails extends StatefulWidget {
  final InstructionUser instructionUser;
  UserInstructionDetails(this.instructionUser);
  @override
  UserInstructionDetailState createState() {
    return new UserInstructionDetailState(instructionUser);
  }
}

class UserInstructionDetailState extends State {
  InstructionUser instructionUser;
  DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/home2.jpg'),
  fit: BoxFit.cover,
);
  UserInstructionDetailState(this.instructionUser);
  User _currentUser; 
  bool deleted,saved;
  Services _currentService; 
  RestDatasource api = new RestDatasource();
  List<User> userList = new List<User>() ;
  List<Services> serviceList = new List<Services>() ;
   @override
  void initState() {
    super.initState();    
    fetchUsers();
    fetchServices();   
    //  getUser(instructionUser.userId);
    //  getService(instructionUser.serviceId);
  }

  updateCurrent(dynamic value,int type){
         if(type==1)
         {          
           debugPrint("Update user"+value.id.toString());   
             instructionUser.userId = value.id;
              setState((){
            instructionUser = new InstructionUser(value.id, instructionUser.color,instructionUser.id, instructionUser.serviceId , instructionUser.name) ;
            _currentUser = value;
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
   getUser(int id) {
    
    if(userList.length>0)
    {
      if(id>0)
      {
      var newItem = userList.where((item)=>item.id == id).first;
      print("User Id:"+id.toString()); 
      
      setState(()=> _currentUser = newItem);       
       
      }
     
    }
   return _currentUser;     
      
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
  fetchUser(int id) {
    print("User Id:"+id.toString());  
     api.fetchUser(id).then((lst) {   
       print("User Name:"+lst.name);  
       setState(()=>_currentUser = lst);    
        //return lst;
      
    });//.catchError((error) => throw Exception('Failed to load internet')); 
  }
  fetchUsers() {
     api.fetchUsers().then((lst) {   
       print("List Count:"+lst.length.toString());  
       setState(()=>userList = lst);    
        return lst;
      
    });//.catchError((error) => throw Exception('Failed to load internet')); 
  }
  fetchService(int id) {
    print("Service Id:"+id.toString());  
     api.fetchService(id).then((lst) {   
       print("Service Name:"+lst.name);  
       setState(()=> _currentService = lst);  
        //return lst;
      
    });//.catchError((error) => throw Exception('Failed to load internet')); 
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
                    value: type == 1 ?getUser(instructionUser.userId):getService(instructionUser.serviceId),
                    onChanged: (value)=>updateCurrent(value,type),
                    isExpanded: true,                  
                 
                    hint: Text(type == 1 ?'اختار شخص':'اختار مجموعه'),
                  );
            
}
  @override
  Widget build(BuildContext context) {
    if(saved==null)
      saved =false;
    if(deleted==null)
      deleted =false;  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        title: Text("اختيار مجموعه للاشخاص"),
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
      body:new Container(
        decoration: BoxDecoration(
        image: backgroundImage),
        child:
      Padding( 
        padding: EdgeInsets.only(top:35.0, left: 10.0, right: 10.0),
        child:
        ListView(children: 
          <Widget>[
            Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
           
            getDropdown(userList,1) 
           ,
            SizedBox(height: 20.0),
            _currentUser != null
                ? Text("UserName: " +
                    _currentUser.username                    
                   )
                : Text("لم يتم تحديد مستخدم"),
                Padding(
            padding: EdgeInsets.only(top:15.0, bottom: 15.0),
            child: getDropdown(serviceList,2) ),
             _currentService != null
                ? Text("Color: " + _currentService.name)
                : Text("لم يتم اختيار مجموعة"),
          // Center(child:
          //   ListTile(
          //   onTap: () {},
          //   leading: CircleAvatar(backgroundColor: HexColor(_currentService.color)),
          //   title: Text(_currentService.name),
          // ))
                
          ],
        ),
  
          ]),
      ) 
    ));
  }
Widget returnChoice(){
  
}
update(){
  if(_currentUser!=null && _currentService!=null && instructionUser!=null)
     api.updateUserInstructions(instructionUser.id.toString(),_currentUser.id.toString(),_currentService.id.toString()).then((res) async {   
       String token =null;
       await DatabaseService(uid:instructionUser.id.toString()).getToken(_currentUser.id).then((value) => token =value).catchError((err){print(err);});
      debugPrint('uid:'+instructionUser.id.toString());
      //debugPrint('token:'+token);
      debugPrint('topic:'+_currentService.id.toString());
       if(token!=null && _currentService.id.toString()!=null)
      await DatabaseService(uid:instructionUser.id.toString()).createTopicData(token,_currentService.id.toString());
      debugPrint('uid:'+instructionUser.id.toString());
       Navigator.pop(context, true);
});
}
save(){
  if(_currentUser!=null && _currentService!=null)
     api.addUserInstructions(_currentUser.id.toString(),_currentService.id.toString()).then((res) async {   
      // setState(()=>saved = res);
      instructionUser=res; 
      String token =null;
       await DatabaseService(uid:instructionUser.id.toString()).getToken(_currentUser.id).then((value) => token =value).catchError((err){print(err);});
      debugPrint('uid:'+instructionUser.id.toString());
      //debugPrint('token:'+token??'');
      debugPrint('topic:'+_currentService.id.toString());
      if(token!=null && _currentService.id.toString()!=null)
      await DatabaseService(uid:instructionUser.id.toString()).createTopicData(token,_currentService.id.toString());
      debugPrint('uid:'+instructionUser.id.toString());
      Navigator.pop(context, true);
});
}
delete(){
  if(instructionUser!=null)
     api.deleteUserInstructions(instructionUser.id.toString()).then((res) async {  
       await DatabaseService(uid:instructionUser.id.toString()).deleteTopicData();
        Navigator.pop(context, true); 
       //setState(()=>deleted = res);    
});
}
void select (String value) async {
    switch (value) {
      case mnuSave:     
      if(instructionUser!=null)
      {
       
         //showAlert(context,1);
          if(instructionUser.id == 0)
             save();
          else
             update();
          //  AlertDialog alertDialog = AlertDialog(
          //   title: Row(
          //    children:[            
          //   Icon(Icons.done,color: Colors.deepOrange,),
          //   Text(' Alert')
          //   ]
          // ),
          //   content: Text("The User has been Saved"),            
          // );
          // showDialog(
          //   context: context,
          //   builder: (_) => alertDialog);
         //Navigator.pop(context, true);
        //  if (saved) {
        //    setState(()=>saved = false); 
        
        // }
      }      
        
        break;
      case mnuDelete:        
        if (instructionUser.id == 0) {
          return;
        }
         delete();      
         //showAlert(context,2);
         
        // if (deleted) {
        //   AlertDialog alertDialog = AlertDialog(
        //     title: Text("Delete User"),
        //     content: Text("The User has been deleted"),
        //   );
        //   showDialog(
        //     context: context,
        //     builder: (_) => alertDialog);
          
        // }
        break;
        case mnuBack:
          Navigator.pop(context, true);
          break;
      default:
      
    }
  }
showAlert(BuildContext context,int type) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children:[
            // Image.network('https://flutter-examples.com/wp-content/uploads/2019/12/android_icon.png',
            //   width: 50, height: 50, fit: BoxFit.contain,),
            Icon(
            type==1?Icons.question_answer:Icons.delete,
            color: Colors.deepOrange,
          ),
            Text('  Alert ')
            ]
          ),
        content: type==1?Text("هل أنت متأكد من أنك تريد المتابعة؟"):Text("هل أنت متأكد من أنك تريد الحذف؟"),
        actions: <Widget>[
          FlatButton(
            child: Text("نعم"),
            onPressed: () {
              //Put your code here which you want to execute on Yes button click.
              if(type==1)
              {
              if(instructionUser.id == 0)
                save();
              else
                update();
              }
              else
              {
                delete();
              }
              Navigator.of(context).pop();
        //       Navigator.push(context, 
        // MaterialPageRoute(builder: (context) => BindUserInstructionsList()));
            },
          ),

           FlatButton(
            child: Text("لا"),
            onPressed: () {
              //Put your code here which you want to execute on Cancel button click.
              Navigator.of(context).pop();
               Navigator.push(context, 
        MaterialPageRoute(builder: (context) => BindUserInstructionsList()));
            },
          ),
        ],
      );
     },
    );
  }

}
