import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:prueba_gps/User.dart';

void main()=>runApp(new AppGPS());

class AppGPS extends StatefulWidget {
  @override
  _AppGPSState createState() => _AppGPSState();
}

class _AppGPSState extends State<AppGPS> {

  final  mainReference  =FirebaseDatabase.instance.reference();
  List<User> users=new List<User>();
  Position currentPosition;

  void add(User user){
    mainReference.push().set(user.toJson()).whenComplete((){
      print("added");
    }).catchError((e)=>print(e));
  }

  void read(){
    mainReference.onChildAdded.listen((event){
      setState(() {
        users.add(new User.fromSnapshot(event.snapshot));
      });
    });
  }
  
  void update(User user){
    mainReference.child(user.key).set(user.toJson());
    User oldUser=users.singleWhere((x)=>x.key==user.key);
    users[users.indexOf(oldUser)]=user;
  }

  _AppGPSState(){
    read();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(title: new Text('PruebaGPS'),),
        floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: (){
            Geolocator().getCurrentPosition().then((currPos){
              setState(() {
                currentPosition=currPos;
                add(new User('user2',currentPosition.latitude,currentPosition.longitude));
              });
            });
          },
        ),
        body: Container(
          child: Center(
            child: new ListView.builder(
                itemCount: users.length,
                itemBuilder: (context,index){
                  final user=users[index];
                  return GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Text('name: '+user.name),
                        Text('latitude: '+user.latitude.toString()),
                        Text('longitude: '+user.longitude.toString() )
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        update(new User.whitKey(user.key, 'userUpdated', user.latitude, user.longitude));
                      });
                    },
                  );
                },
            ),
          ),
        )
      ),
    );
  }
}

