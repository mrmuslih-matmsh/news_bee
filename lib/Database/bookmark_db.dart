import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:newsbee/Models/news_model.dart';

class BookmarkDatabase {
  static final BookmarkDatabase _instance = BookmarkDatabase._internal();
  static Database? _database;

  BookmarkDatabase._internal();

  factory BookmarkDatabase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'bookmarks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE bookmarks(title TEXT PRIMARY KEY, author TEXT, content TEXT, urlToImage TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  // Insert a bookmark
  Future<void> insertBookmark(NewsData news) async {
    final db = await database;
    await db.insert('bookmarks', news.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Delete a bookmark
  Future<void> deleteBookmark(String title) async {
    final db = await database;
    await db.delete('bookmarks', where: 'title = ?', whereArgs: [title]);
  }

  // Check if an article is bookmarked
  Future<bool> isBookmarked(String title) async {
    final db = await database;
    final maps = await db.query('bookmarks', where: 'title = ?', whereArgs: [title]);
    return maps.isNotEmpty;
  }

  // Get all bookmarks
  Future<List<NewsData>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) => NewsData.fromMap(maps[i]));
  }


}
