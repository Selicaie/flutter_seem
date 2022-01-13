class Services {
  
  String _color;
  int _id;  
  String _name;
 
  
  Services(this._color,this._id,this._name);
  
  
  String get color => _color;
  int get id => _id;     
  String get name => _name; 
  set id (int id) {
    _id = id;
  }
 
    factory Services.fromJson(Map<String, dynamic> json) {
    return Services(      
      json['Color'],
      json['Id'],      
      json['Name']          
    );
  }
}
