import 'package:flutter/material.dart';
import 'package:instructions_app/screens/home/home_screen.dart';
import 'package:instructions_app/screens/home/new_home.dart';
import 'package:instructions_app/screens/instruction/bind_user_instruction.dart';
import 'package:instructions_app/screens/instruction/send_instruction.dart';
import 'package:instructions_app/screens/instruction/user_instruction_details.dart';
import 'package:instructions_app/screens/instruction/user_instructions.dart';
import 'package:instructions_app/screens/landing/landing.dart';
import 'package:instructions_app/screens/login/face_page.dart';
import 'package:instructions_app/screens/notification/notificationList.dart';
import 'package:instructions_app/screens/login/login.dart';
import 'package:instructions_app/screens/user/userList.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(title: 'Instructions Login'),
  //'/login':         (BuildContext context) => new FacePage(),
  //'/home':         (BuildContext context) => new HomeScreen(),
  '/home':         (BuildContext context) => new AdminHome(),
  '/users':         (BuildContext context) => new UserList(),
  '/notification':         (BuildContext context) => new NotificationMain(),
  '/instructions':         (BuildContext context) => new UserInstructionsList(),//UserInstructionsPage(),
  '/sendinstruction':         (BuildContext context) => new SendInstruction(),//UserInstructionsPage(),
  '/instructionUser':         (BuildContext context) => new BindUserInstructionsList(),//UserInstructionsPage(),
  //'/instructionUserDetail':         (BuildContext context) => new UserInstructionDetails(),//UserInstructionsPage(),
  
  '/' :          (BuildContext context) => new Landing(),
};