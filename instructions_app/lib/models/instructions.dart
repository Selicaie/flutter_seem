class Instruction {
  String _message;
  String _color;
  int _id;
  String _time;
  String _status;
  String _url;
  String _name;
  int _serviceId;
  bool _admin;
  
  Instruction(this._message, this._color,this._id,this._time,this._status,this._name,this._admin);
  
  String get message => _message;
  String get color => _color;
  int get id => _id;
  int get serviceId => _serviceId;
  String get status => _status; 
  String get time => _time;
  String get name => _name;
  String get url => _url;
  bool get admin => _admin;
  set id (int id) {
    _id = id;
  }
   set serviceId (int serviceId) {
    _serviceId = serviceId;
  }
   set message (String message) {
    _message = message;
  }
   set url (String url) {
    _url = url;
  }
  Map<String, dynamic> toMap() {
    //return data from sqlflite
    var map = new Map<String, dynamic>();
    map["message"] = _message;
    map["color"] = _color;
    map["id"] = _id;
    map["status"] = _status;
    map["time"] = _time;
    map["name"] = _name;    
    return map;
  }

Instruction.fromMap(Map<String, dynamic> obj) {
  //set object user with new data come from any
    this._message = obj["message"];
    this._color = obj["color"];    
    this._status = obj["status"];
    this._time = obj["time"];
    this._id = obj["id"];
  }
    factory Instruction.fromJson(Map<String, dynamic> json) {
    Instruction instruction =  Instruction(
      json['Message'],
      json['Color'],
      json['Id'],
      json['Time'],
      json['Status'],
      json['Name'],
      json['Admin']     
    );
    instruction.url = json['Url'] ;
    return instruction;
  }
}
