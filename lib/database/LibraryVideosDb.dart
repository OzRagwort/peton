
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peton/model/LibraryVideos.dart';
import 'package:sqflite/sqflite.dart';

final int version = 2;
final String TableNameOrig = 'library_videos_v';
final String TableName = TableNameOrig + version.toString();

class LibraryVideosDb {

  LibraryVideosDb._();
  static final LibraryVideosDb _db = LibraryVideosDb._();
  factory LibraryVideosDb() => _db;

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
    String path = join(documentsDirectory.path, 'peton_library_videos_db.db');

    Map<int, String> versionColumn = {
      1:'channelId, channelName, channelThumbnail, videoId, videoName, videoThumbnail, videoPublishedDate, videoEmbeddable',
      2:'channelId, channelName, channelThumbnail, videoId, videoName, videoThumbnail, videoPublishedDate'
    };
    var createTableQueryNew = '''
          CREATE TABLE $TableName(
            channelId TEXT, 
            channelName TEXT, 
            channelThumbnail TEXT, 
            videoId TEXT, 
            videoName TEXT, 
            videoThumbnail TEXT, 
            videoPublishedDate TEXT
          )
        ''';

    return await openDatabase(
        path,
        version: version,
        onCreate: (db, version) async {
          await db.execute(createTableQueryNew);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          String TableNameOld = TableNameOrig + oldVersion.toString();

          await db.execute(createTableQueryNew);

          var insertTableQuery = '''
            INSERT INTO $TableName 
            (${versionColumn[newVersion]}) 
              select ${versionColumn[newVersion]}
              from $TableNameOld
          ''';
          var deleteTableQuery = "DROP TABLE IF EXISTS $TableNameOld";

          await db.execute(insertTableQuery);
          await db.execute(deleteTableQuery);
        }
    );
  }

  //Create insert
  Future<void> insertLibraryVideo(LibraryVideos libraryVideos) async {
    final db = await database;

    await db.insert(
      TableName,
      libraryVideos.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Read one
  Future<LibraryVideos> getLibraryVideo(String videoId) async {
    final db = await database;

    var res = await db.rawQuery('SELECT * FROM $TableName WHERE videoId = ?', [videoId]);
    
    return res.isNotEmpty ? LibraryVideos(
      channelId : res.first['channelId'],
      channelName : res.first['channelName'],
      channelThumbnail : res.first['channelThumbnail'],
      videoId : res.first['videoId'],
      videoName : res.first['videoName'],
      videoThumbnail : res.first['videoThumbnail'],
      videoPublishedDate : res.first['videoPublishedDate'],
    ) : null;
  }

  //Read All
  Future<List<LibraryVideos>> getAllLibraryVideos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TableName);

    return List.generate(maps.length, (index) {
      return LibraryVideos(
        channelId : maps[index]['channelId'],
        channelName : maps[index]['channelName'],
        channelThumbnail : maps[index]['channelThumbnail'],
        videoId : maps[index]['videoId'],
        videoName : maps[index]['videoName'],
        videoThumbnail : maps[index]['videoThumbnail'],
        videoPublishedDate : maps[index]['videoPublishedDate'],
      );
    });
  }

  //Delete
  Future<void> deleteLibraryVideo(String videoId) async {
    final db = await database;

    await db.delete(
      TableName,
      where: "videoId = ?",
      whereArgs: [videoId],
    );

  }

  //Delete All
  Future<void> deleteAllLibraryVideos() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

}