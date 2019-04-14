import 'package:firebase_database/firebase_database.dart';

class User{

  String _key;
  String _name;
  double _latitude;
  double _longitude;

  User.empty();
  User.whitKey(this._key,this._name,this._latitude,this._longitude);
  User(this._name,this._latitude,this._longitude);
  User.fromSnapshot(DataSnapshot snapshot):
      _key=snapshot.key,
      _name=snapshot.value['name'],
      _latitude=snapshot.value['latitude'].toDouble(),
      _longitude=snapshot.value['longitude'].toDouble();

  String get key=>this._key;
  set key(String key)=>_key=key;
  String get name=>this._name;
  set name(String name)=>_name=name;
  double get latitude=>this._latitude;
  set latitude(double latitude)=>_latitude=latitude;
  double get longitude=>this._longitude;
  set longitude(double name)=>_longitude=longitude;

  toJson(){
    return {
      'name':this._name,
      'latitude':this._latitude,
      'longitude':this._longitude
    };
  }

  static User Json2User(Map<String,String> data){
    String name=data['name'];
    double latitude=double.parse(data['latitude']);
    double longitude=double.parse(data['longitude']);
    return new User(name, latitude, longitude);
  }

}