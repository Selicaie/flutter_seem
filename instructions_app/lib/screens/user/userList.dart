  
import 'package:flutter/material.dart';
import 'package:instructions_app/models/users.dart';
import 'package:instructions_app/screens/user/userTile.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context);
    users.forEach((user) {
      print(user.name);
      print(user.username);
    });

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserTile(user: users[index]);
      },
    ); 
  }
}