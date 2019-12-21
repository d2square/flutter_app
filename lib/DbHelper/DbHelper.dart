import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_app/Item/Photo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'photo_name';
  static const String COUNT = 'countforphoto';
  static const String IMAGE_NAME = 'image_name';
  static const String TABLE = 'PhotosTable';
  static const String DB_NAME = 'photos.db';

  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER, $NAME TEXT, $COUNT INTEGER, $IMAGE_NAME TEXT)");
  }

  Future<Photo> save(Photo images) async {
    var dbClient = await db;
    images.id = await dbClient.insert(TABLE, images.toMap());
    return images;
  }

  Future<List<Photo>> getPhotos() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, NAME, COUNT, IMAGE_NAME]);
    List<Photo> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Photo.fromMap(maps[i]));
      }
    }
    return employees;
  }

  Future<String> checkifalreadyExists(String id) async {
    var dbClient = await db;
    var res = await dbClient
        .rawQuery("SELECT * FROM PhotosTable WHERE image_name = '$id'");
    if (res.length > 0) {
      return "1";
    } else {
      return "0";
    }
  }

  Future getSelected(String id) async {
    var dbClient = await db;
    List<String> columnsToSelect = [COUNT];
    String whereString = '${id} = ?';
    int rowId = int.parse(id);
    List<dynamic> whereArguments = [rowId];

    List<Map> result = await dbClient.query(TABLE,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    result.forEach((row) =>

        print(row));
    if (result.isEmpty) {
      return 0;
    } else {
      return result.toList();
    }
  }
  Future<int> getCount(String id) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient
        .rawQuery("SELECT countforphoto FROM $TABLE WHERE id = '$id'"));
  }

  Future getSelectedindex(String ids) async {
    var dbClient = await db;
    int id = int.parse(ids);

    var selectedIndex =
        dbClient.rawQuery("SELECT countforphoto FROM $TABLE WHERE id = '$id'");

    return selectedIndex;
  }

  Future updatedcount(String id, String val) async {
    var dbClient = await db;
    Map<String, String> row = {COUNT: val};

    int updateCount =
        await dbClient.update(TABLE, row, where: '${ID} = ?', whereArgs: [id]);
    return updateCount;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
