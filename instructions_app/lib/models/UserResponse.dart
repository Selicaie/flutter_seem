import 'user.dart';


class UserResponse {
  UserIdentity user;
  String error;


  UserResponse();
  UserResponse.mock(UserIdentity user):
        user  = user,error = "";
}