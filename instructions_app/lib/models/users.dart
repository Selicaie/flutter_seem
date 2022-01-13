class User {
  String _username;
  String _password;
  int _id;
  String _date;
  String _name;
  bool _admin;
  String uid;  
  User(this._username, this._password,this._id,this._name,this._admin, this.uid);
  
  
  String get username => _username;
  String get password => _password;
  String get name => _name;
  int get id => _id;
  bool get admin => _admin; 
  String get date => _date;
  set date (String date) {
    _date = date;
  }
   set name (String name) {
    _name = name;
  }
   set password (String password) {
    _password = password;
  }
   set admin (bool admin) {
    _admin = admin;
  }
  set id (int id) {
    _id = id;
  }
  Map<String, dynamic> toMap() {
    //return data from sqlflite
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["id"] = _id;
    map["date"] = _date;
    return map;
  }
// User.map(dynamic obj) {  
//     //int ii =   obj["userId"];
//     this._username = obj["username"];
//     this._password = obj["password"];    
//     this._date = obj["date"];
//     this._id = obj["id"];
//   }
User.fromMap(Map<String, dynamic> obj) {
  //set object user with new data come from any
    this._username = obj["username"];
    this._password = obj["password"];    
    this._date = obj["date"];
    this._id = obj["id"];
  }
    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['UserName'],
      json['Password'],
      json['Id'],
      json['Name'],
      json['Admin']
      ,null
    );
  }
}
// class User {
//   final int id;
//   final String title,username,password;


//   User({this.id, this.title,this.username,this.password});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['ID'],
//       title: json['Title'],
//       username: json['UserName'],
//       password: json['Password']
//     );
//   }
// }