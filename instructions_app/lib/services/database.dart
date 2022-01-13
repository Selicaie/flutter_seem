import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instructions_app/models/users.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('Users');
  final CollectionReference userTokenCollection = Firestore.instance.collection('DeviceTokens');
  final CollectionReference messageCollection = Firestore.instance.collection('Messages');
  Future<void> updateUserData(String username, String name, int id) async {
    return await userCollection.document(uid).setData({
      'username': username,
      'name': name,
      'userId': id,      
    });
  }
Future<void> updateMessageData(String message, String topic) async {
    return await messageCollection.document(uid).setData({
      'message': message,
      'topic': topic,      
    });
  }
    Future<Map<String,dynamic>>  readMessageData() async => messageCollection
    .getDocuments()
    .then((value) {
     value.documents.forEach((element) {
      return element.documentID == 3 ?element.data:null;
     });
    
});
 
  Future<void> createTopicData(String token, String topic) async {
    return await userTokenCollection.document(uid).setData({
      'token': token,
      'topic': topic,      
    });
  }
  Future<void> deleteTopicData() async {
    return await userTokenCollection.document(uid).delete();
    
  }
    // brew list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return null;
      // var username = doc.data['username'];
      // var userId = doc.data['userId'];
      // var name = doc.data['name'];
      // return User(
      //   username ?? '',
      //   null,
      //   userId ?? 0,
      //   name ?? '',
      //   null,
      //   null
      // );
    }).toList();
  }
//get user 
  Future<String>  getToken(int id) async => userCollection.where("userId", isEqualTo: id)
    .getDocuments()
    .then((value) {
      var result  = value.documents.first.data["token"];
     return value==null ? null : result;
  // value.documents.forEach((result) {
  //   print(result.data['user_token']);
  //   return  result.data['user_token'] ?? '';
    
  // });
});
  Future<void> saveDeviceToken(String token) async {
    return await userCollection.document(uid).updateData({
      'token': token,    
    });    
   }
  // get users stream
  Stream<List<User>> get users {
    return userCollection.snapshots()
      .map(_userListFromSnapshot);
  }

}