class InstructionUser {
  int _userId;
  String _color;
  int _id;
  int _serviceId; 
  String _name;
 
  
  InstructionUser(this._userId, this._color,this._id,this._serviceId,this._name);
  
  int get serviceId => _serviceId;
  String get color => _color;
  int get id => _id;
  int get userId => _userId;   
  String get name => _name; 
  set id (int id) {
    _id = id;
  }
 set userId (int userId) {
    _userId = userId;
  }
  set serviceId (int iserviceIdd) {
    _serviceId = serviceId;
  }
    factory InstructionUser.fromJson(Map<String, dynamic> json) {
    return InstructionUser(
      json['UserId'],
      json['Color'],
      json['Id'],
      json['ServiceId'],   
      json['Name']          
    );
  }
}
