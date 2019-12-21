import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/multipleimage.dart';
import 'package:flutter_app/Screens/showimagelist.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';

void main() =>
    runApp(MaterialApp(

        title: "Flower",
        debugShowCheckedModeBanner: false,
        home: MainActivity()));

class MainActivity extends StatefulWidget {
  @override

  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  //String msg = 'Flutter FloatingButton Example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //backgroundColor: Colors.yellow,
      appBar: AppBar(

        title: Text('Flower List'),
      ),

      body:JsonImageList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.view_list),
        backgroundColor: Colors.orange,
        onPressed: () {
          print("Clicked");
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new MyEmployeeList()),
          );

        },
        heroTag: "Show",
      ),
    );
  }

/*
void main() => runApp(
    new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
        home: new HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flower"),
      ),
      body: new Center(child: JsonImageList()),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.view_list),
        backgroundColor: Colors.orange,
        onPressed: () {
          print("Clicked");
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new MyEmployeeList()),
          );

        },
        heroTag: "Show",
      ),
    );
  }*/

}
