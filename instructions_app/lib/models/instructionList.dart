import 'package:instructions_app/models/instructions.dart';

class InstructionListModel{
  List<Instruction> intructionList;

  InstructionListModel({this.intructionList});

  InstructionListModel.fromJson(List<dynamic> parsedJson){
    intructionList=new List<Instruction>();
    parsedJson.forEach((v){
      intructionList.add(Instruction.fromJson(v));
    });
  }
}