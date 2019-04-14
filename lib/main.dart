import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:prueba_gps/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main()=>runApp(new AppGPS());

class AppGPS extends StatefulWidget {
  @override
  AppGPSState createState() => AppGPSState();
}

/*class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // ignore: missing_return
  Widget build(BuildContext context){
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       home: MyHomePage(),
     );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(45.16165, 17.646651),
                zoom: 15.0,
            ),
          )
        ],
      ),
    );
  }


}*/


class AppGPSState extends State<AppGPS> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  //GoogleMapController mapController;
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

  AppGPSState(){
    read();
  }

  /*void onMapCreated(controller) {
    setState(() {
      mapController=controller;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    double long=25.166516;
    double lat=74.6556616;
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
                lat=currentPosition.latitude;
                long=currentPosition.longitude;
              });
            });
          },
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
          ),
        )
      ),
    );
  }
}


/*body: Container(
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
        )*/