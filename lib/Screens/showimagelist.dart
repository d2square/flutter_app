import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app/DbHelper/DbHelper.dart';
import 'dart:async';

import 'package:flutter_app/Item/Photo.dart';


Future<List<Photo>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();

  Future<List<Photo>> employees = dbHelper.getPhotos();


  return employees;
}

class MyEmployeeList extends StatefulWidget {
  @override
  MyEmployeeListPageState createState() => new MyEmployeeListPageState();
}

class MyEmployeeListPageState extends State<MyEmployeeList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image List'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<Photo>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Image.file(File(snapshot.data[index].photo_name)),
                    new Text("Download Count "+snapshot.data[index].countforphoto.toString(),
                    style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14.0)),
                    new Divider()
                    ]);
                  });
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
