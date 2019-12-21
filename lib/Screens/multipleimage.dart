import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/DbHelper/DbHelper.dart';
import 'package:flutter_app/Functions/Dialogs.dart';
import 'package:flutter_app/Functions/functions.dart';
import 'package:flutter_app/Item/Flowerdata.dart';
import 'package:flutter_app/Item/Photo.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class JsonImageList extends StatefulWidget {
  JsonImageListWidget createState() => JsonImageListWidget();
}

class JsonImageListWidget extends State {
  bool downloading = false;
  bool checkstatus = false;
  List<Flowerdata> _list;
  var progressString = "";
  var savepath = "";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var total;
  Future<List<Photo>> customer;
  int index = 0;
  String _base64, removeSlashUrl;
  DBHelper dbHelper;
  final String apiURL =
      'https://flutter-examples.000webhostapp.com/getFlowersList.php';

  @override
  void initState() {
    super.initState();
    // images = [];
    dbHelper = DBHelper();
    // downloadFile();
  }

  Future<List<Flowerdata>> fetchFlowers() async {
    var response = await http.get(apiURL);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Flowerdata> listOfFruits = items.map<Flowerdata>((json) {
        return Flowerdata.fromJson(json);
      }).toList();
      //_list= listOfFruits;

      return listOfFruits;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  selectedItem(BuildContext context, String holder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(holder),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Flowerdata>>(
      future: fetchFlowers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        //final fruitMap = _list.asMap();

        return ListView(
          children: snapshot.data
              .map((data) => Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          selectedItem(context, data.flowerName);
                        },
                        child: Row(children: [
                          Container(
                              width: 200,
                              height: 100,
                              margin: EdgeInsets.fromLTRB(10, 7, 10, 0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    data.flowerImageURL,
                                    width: 200,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ))),
                          Flexible(
                              child: Text(data.flowerName,
                                  style: TextStyle(fontSize: 18))),
                          Flexible(
                              child: RaisedButton(
                            padding: const EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            color: Colors.blue,
                            onPressed: () {
                              Dialogs.showLoadingDialog(context, _keyLoader);
                              downloadFile(snapshot.data.indexOf(data), data.id,
                                  data.flowerImageURL, data.flowerName);
                            },
                            child: new Text("Download"),
                          ))
                        ]),
                      ),
                      Divider(color: Colors.black),
                    ],
                  ))
              .toList(),
        );
      },
    );
  }

  Future<void> downloadFile(
      int pos, int id, String imgUrl, String imgName) async {
    String id1 = id.toString();
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      savepath = dir.path + "/myimage" + id1 + ".jpg";
      await dio.download(imgUrl, "${dir.path}/myimage" + id1 + ".jpg",
          onReceiveProgress: (rec, total) {
        removeSlashUrl = imgUrl.replaceAll(new RegExp(r'[^\w\s]+'), '');
        print(removeSlashUrl);
      });
    } catch (e) {
      print(e);
    }
    var ifexist = await check_if_image_exist();
    int _total;
    int _total1;
    try {
      //customer=dbHelper.getSelected(id1, removeSlashUrl);

      //total = (await dbHelper.getSelected(id1))[pos]['countforphoto'];
      _total1 = await dbHelper.getCount(id1);
      //print(totals);
      //customer.asMap().forEach((index, value) => f);
//      total = (await dbHelper.getSelected(id1))[0]['countforphoto'];
    } catch (e) {
      print(e);
    }

    setState(() {
      Photo photo = new Photo(id, savepath, 1, removeSlashUrl);
      if (ifexist == "1") {
      _total = _total1;
        functions.toastmessage("Image Already Downloaded Completed");
        var sum = _total + 1;
        dbHelper.updatedcount(id1, sum.toString());
        Navigator.pop(context);
      } else {
        dbHelper.save(photo);
        Navigator.pop(context);
        //progressString = "Completed";
        functions.toastmessage("Download Completed");
      }
    });
    print("Download completed");
  }

  Future<String> check_if_image_exist() async {
    var data = await dbHelper.checkifalreadyExists(removeSlashUrl);
    return data;
  }
}
