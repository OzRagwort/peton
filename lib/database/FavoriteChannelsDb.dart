
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peton/model/Channels.dart';
import 'package:sqflite/sqflite.dart';

final int version = 1;
final String TableNameOrig = 'favorite_channels_v';
final String TableName = TableNameOrig + version.toString();

class FavoriteChannelsDb {

  FavoriteChannelsDb._();
  static final FavoriteChannelsDb _db = FavoriteChannelsDb._();
  factory FavoriteChannelsDb() => _db;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) {
      if ((await _database.getVersion()) != version) {
        _database = await initDB();
      }
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'peton_favorite_channels_db.db');

    Map<int, String> versionColumn = {1:'idx, channelId, channelName, channelThumbnail, uploadsList, subscribers, bannerExternalUrl'};
    var createTableQueryNew = '''
          CREATE TABLE $TableName(
            idx INTEGER, 
            channelId TEXT, 
            channelName TEXT, 
            channelThumbnail TEXT, 
            uploadsList TEXT, 
    subscribers INTEGER,
        bannerExternalUrl TEXT
    );
    ''';

    return await openDatabase(
        path,
        version: version,
        onCreate: (db, version) async {
          await db.execute(createTableQueryNew);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          String TableNameOld = TableNameOrig + oldVersion.toString();

          var insertTableQuery = '''
            INSERT INTO $TableName 
            (${versionColumn[newVersion]}) 
              select ${versionColumn[oldVersion]}
              from $TableNameOld
          ''';
          var deleteTableQuery = "DROP TABLE IF EXISTS $TableNameOld";

          await db.execute(createTableQueryNew);
          await db.execute(insertTableQuery);
          await db.execute(deleteTableQuery);
        }
    );
  }

  //Create insert
  Future<void> insertChannel(Channels channels) async {
    final db = await database;

    await db.insert(
      TableName,
      channels.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Read one
  Future<Channels> getChannel(String channelId) async {
    final db = await database;

    var res = await db.rawQuery('SELECT * FROM $TableName WHERE channelId = ?', [channelId]);

    return res.isNotEmpty ? Channels(
        idx: res.first['idx'],
        channelId : res.first['channelId'],
        channelName : res.first['channelName'],
        channelThumbnail : res.first['channelThumbnail'],
        uploadsList: res.first['uploadsList'],
        subscribers: res.first['subscribers'],
        bannerExternalUrl: res.first['bannerExternalUrl']
    ) : null;
  }

  //Read All
  Future<List<Channels>> getAllChannels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TableName);

    return List.generate(maps.length, (index) {
      return Channels(
          idx: maps[index]['idx'],
          channelId : maps[index]['channelId'],
          channelName : maps[index]['channelName'],
          channelThumbnail : maps[index]['channelThumbnail'],
          uploadsList: maps[index]['uploadsList'],
          subscribers: maps[index]['subscribers'],
          bannerExternalUrl: maps[index]['bannerExternalUrl']
      );
    });
  }

  //Delete
  Future<void> deleteChannel(String channelId) async {
    final db = await database;

    await db.delete(
      TableName,
      where: "channelId = ?",
      whereArgs: [channelId],
    );

  }

  //Delete All
  Future<void> deleteAllChannels() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

}