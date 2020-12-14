
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peton/model/LibraryVideos.dart';
import 'package:sqflite/sqflite.dart';

final String TableName = 'library_videos';

class LibraryVideosDb {

  LibraryVideosDb._();
  static final LibraryVideosDb _db = LibraryVideosDb._();
  factory LibraryVideosDb() => _db;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'peton_db.db');

    log('init' + path);

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $TableName(
            channelId TEXT, 
            channelName TEXT, 
            channelThumbnail TEXT, 
            videoId TEXT, 
            videoName TEXT, 
            videoThumbnail TEXT, 
            videoPublishedDate TEXT, 
            videoEmbeddable INTEGER
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
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
      videoEmbeddable : res.first['videoEmbeddable']==1?true:false,
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
        videoEmbeddable : maps[index]['videoEmbeddable']==1?true:false,
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