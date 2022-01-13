import 'package:flutter/material.dart';
import 'package:instructions_app/models/users.dart';

class UserTile extends StatelessWidget {

  final User user;
  UserTile({ this.user });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
             backgroundColor: Colors.white,             
                child: Text(
                 user.name[0],
                  style: TextStyle(fontSize: 40.0),
                ),
          ),
          title: Text(user.name),
          subtitle: Text('Takes ${user.username} sugar(s)'),
        ),
      ),
    );
  }
}