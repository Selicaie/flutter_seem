import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:connectivity/connectivity.dart';
import 'package:instructions_app/models/instructionList.dart';
import 'package:instructions_app/models/instructions.dart';
import 'package:instructions_app/models/instructionsUser.dart';
import 'package:instructions_app/models/services.dart';
import 'package:instructions_app/utils/network_util.dart';
import 'package:instructions_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  //static final BASE_URL = "http://192.168.1.3/";
  // static final BASE_URL = "http://192.168.1.4:44399/Api/";
  //static final BASE_URL = "http://www.instructions-internal.mcit.gov.eg/";
  // static final BASE_URL = "http://instructions.mcit.gov.eg/";
  static final BASE_URL = "http://seems.mcit.gov.eg/";
  static final LOGIN_URL = BASE_URL + "Api/Login/CheckUser";
  static final GET_INSTRUCTION_URL = BASE_URL + "Api/Instruction/GetInstruction";
  static final GET_SPECIFIC_INSTRUCTION_URL = BASE_URL + "Api/Instruction/GetSpecificInstruction";
  static final ACKNOWLEDGE_INSTRUCTION_URL = BASE_URL + "Api/Instruction/AcknowledgeUser";
  static final DONE_INSTRUCTION_URL = BASE_URL + "Api/Instruction/DoneUser";
  static final GET_INSTRUCTION_USER_URL = BASE_URL + "Api/Instruction/GetUserInstructions";
  static final SEND_INSTRUCTION_USER_URL = BASE_URL + "Api/Instruction/SendMessage";
  static final GET_SERVICES_URL = BASE_URL + "Api/Instruction/GetServices";
  static final GET_SERVICE_URL = BASE_URL + "Api/Instruction/GetService";
  static final USERS_URL = BASE_URL + "Api/Login/GetUsers";
  static final USER_URL = BASE_URL + "Api/Login/GetUser";
  static final ADD_SERVICE_USER_URL = BASE_URL + "Api/Instruction/AddInstructionUser";
  static final DELTE_SERVICE_USER_URL = BASE_URL + "Api/Instruction/DeleteInstructionUser";
  static final UPDATE_SERVICE_USER_URL = BASE_URL + "Api/Instruction/UpdateInstructionUser";
  static final POST_FILE_URL = BASE_URL + "Api/Instruction/PostFormData";
  static final ACKNOWLEDGE_USERS_URL = BASE_URL + "Api/Instruction/GetAknowledgeUsers"; 
  static final _API_KEY = "15081466950052";

Future<User> fetchUser(int id)  {
    return _netUtil.get(USER_URL+"?id="+id.toString()).then((res) {
      print(res.toString());
       if(res!=null)
        return User.fromJson(res);
       
      
    });
  }
Future<List<User>> fetchUsers()  {
    return _netUtil.get(USERS_URL).then((res) {
      print(res.toString());
       if(res!=null)
       {
         Iterable list = res;//res['articles'];
         return list.map((model) => User.fromJson(model)).toList();
       }
       
      
    });
  }
  Future<Services> fetchService(int id)  {
    return _netUtil.get(GET_SERVICE_URL+"?id="+id.toString()).then((res) {
      print(res.toString());
       if(res!=null)
        return Services.fromJson(res);
       
      
    });
  }
  Future<List<Services>> fetchServices()  {
    return _netUtil.get(GET_SERVICES_URL).then((res) {
      print(res.toString());
       if(res!=null)
       {
         Iterable list = res;//res['articles'];
         return list.map((model) => Services.fromJson(model)).toList();
       }
       
      
    });
  }
  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {       
      "UserName": username,
      "Password": password
    }).then((dynamic res) {
      print(res.toString());
       //if(res["error"]) throw new Exception(res["error_msg"]);
       if(res!=null)
       return new User.fromJson(res);
      //  else
      //  throw new Exception("Error!! Login Faild");
      // return new User.map(res["user"]);
    });
    //.catchError((Exception error){ return error;})
  }
  Future<List<Instruction>> getSpecificInstructions()  {     
   
    return _netUtil.get(GET_SPECIFIC_INSTRUCTION_URL).then((res) {
      print(res.toString());
       //if(res["error"]) throw new Exception(res["error_msg"]);
       if(res!=null)
       {
         Iterable list = res;//res['articles'];
         //List<Instruction> out = list.map((model) => Instruction.fromJson(model)).toList();
         return list.map((model) => Instruction.fromJson(model)).toList();
       }
       
      
    });
    //.catchError((Exception error){ return error;})
  }

 
  Future<List<Instruction>> getInstructions() async { 
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String id = (prefs.getString('id') ?? ""); 
                  bool admin = (prefs.getBool('admin')??false);
    return _netUtil.post(GET_INSTRUCTION_URL, body: {    
      "Id": id, 
      "Admin": admin.toString()     
    }).then((dynamic res) {
      print(res.toString());
       if(res!=null)
       {
         Iterable list = res;//res['articles'];
         //List<Instruction> out = list.map((model) => Instruction.fromJson(model)).toList();
         return list.map((model) => Instruction.fromJson(model)).toList();
       }
        //return null;
    });
    //.catchError((Exception error){ return error;})
  }
  Future<List<InstructionUser>> getInstructionsUser() {    
   
    return _netUtil.get(GET_INSTRUCTION_USER_URL).then((res) {
      print(res.toString());
       if(res!=null)
       {
         Iterable list = res;//res['articles'];
         return list.map((model) => InstructionUser.fromJson(model)).toList();
       }
       
      
    });
  }
Future<List<User>> getAcknowledgeUsers(String id)  {
           
    String url = ACKNOWLEDGE_USERS_URL+"?id="+id;
    print("Url:"+url);
    return _netUtil.get(url).then((res) {
      print(res.toString());
       if(res!=null)
       {
         Iterable list = res;
         return list.map((model) => User.fromJson(model)).toList();
       }
       
      
    });
  }

Future<List<Instruction>> acknowledgeInstructions(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = (prefs.getString('id') ?? "");   
    bool admin = (prefs.getBool('admin')??false);   
    //print("Admin:"+admin.toString());             
    String url = admin?DONE_INSTRUCTION_URL+"?userId="+userId+"&id="+id:ACKNOWLEDGE_INSTRUCTION_URL+"?userId="+userId+"&id="+id;
    print("Url:"+url);
    return _netUtil.get(url).then((res) {
      print(res.toString());
       if(res!=null)
       {
         Iterable list = res;
         return list.map((model) => Instruction.fromJson(model)).toList();
       }
       
      
    });
  }
Future<InstructionUser> addUserInstructions(String userId,String serviceId)  {    
    String url = ADD_SERVICE_USER_URL+"?userId="+userId+"&serviceId="+serviceId;
    print("Url:"+url);
    return _netUtil.get(url).then((res) {
      print(res.toString());
       if(res!=null)
       {
          if(res!=null)
            return new InstructionUser.fromJson(res);
         
       }
        return null;
      
    });
  }
Future<bool> deleteUserInstructions(String id) {    
    String url = DELTE_SERVICE_USER_URL+"?id="+id;
    print("Url:"+url);
    return _netUtil.get(url).then((res) {
      print(res.toString());
       if(res!=null)
       {
         
         return res as bool;
       }
        return false;
      
    });
  }
Future<bool> updateUserInstructions(String id,String userId,String serviceId) {    
    String url = UPDATE_SERVICE_USER_URL+"?id="+id+"&userId="+userId+"&serviceId="+serviceId;
    print("Url:"+url);
    return _netUtil.get(url).then((res) {
      print(res.toString());
       if(res!=null)
       {
         
         return res as bool;
       }
        return false;
      
    });
  }
 Future<bool> sendInstruction(Instruction instruction) {
    return _netUtil.post(SEND_INSTRUCTION_USER_URL, body: {    
      "Id": instruction.id.toString(), 
      "ServiceId": instruction.serviceId.toString(),
      "Message": instruction.message
    }).then((dynamic res) {
      print(res.toString());
       if(res!=null)
       {
         
         return res as bool;
       }
        return false;
    });
    //.catchError((Exception error){ return error;})
  }
 Future<String> uploadFile(filename,filepath,id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('itoken') ?? "");
    Map<String, String> headers = { HttpHeaders.authorizationHeader: "bearer $token"};
    var request = http.MultipartRequest('POST', Uri.parse(POST_FILE_URL+"?id="+id.toString()));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath(filename, filepath));
    //request.fields['id'] = '12';
    // request.fields['firstName'] = 'abc';
    var response = await request.send();
    print(response.reasonPhrase);
    response.stream.transform(utf8.decoder).listen((value) {
      
      print('Url:'+value);
      return value;
    });
    //return res.reasonPhrase;
  }
}

/* Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
} */
Future<InstructionListModel> getInstructionListData() async {
  String url = "http://192.168.1.4/Api/Instruction/GetInstruction",id;
  bool admin;
   SharedPreferences prefs = await SharedPreferences.getInstance();
 id = (prefs.getString('id') ?? ""); 
                  admin = (prefs.getBool('admin')??false);  
  final response = await http.get(url+"?id="+id+"&admin="+admin.toString(),);
  //json.decode used to decode response.body(string to map)
  return InstructionListModel.fromJson(json.decode(response.body));
}
 // Future<List<Instruction>> getInstructions() async {    
  //  SharedPreferences prefs = await SharedPreferences.getInstance();
  //  String id = (prefs.getString('id') ?? ""); 
  //                 bool admin = (prefs.getBool('admin')??false);
  //   return _netUtil.get(GET_INSTRUCTION_URL+"?id="+id+"&admin="+admin.toString()).then((res) {
  //     print(res.toString());
  //      if(res!=null)
  //      {
  //        Iterable list = res;//res['articles'];
  //        return list.map((model) => Instruction.fromJson(model)).toList();
  //      }
       
      
  //   });
  // }