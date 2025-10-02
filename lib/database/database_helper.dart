import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/blood_sugar_entry.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('blood_sugar.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE blood_sugar_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year INTEGER NOT NULL,
        month INTEGER NOT NULL,
        day INTEGER NOT NULL,
        blood_sugar REAL NOT NULL,
        is_fasting INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        UNIQUE(year, month, day)
      )
    ''');
  }

  // Insert or update entry (only one per day)
  Future<int> insertOrUpdateEntry(BloodSugarEntry entry) async {
    final db = await database;
    
    // Check if entry exists for this date
    final existing = await db.query(
      'blood_sugar_entries',
      where: 'year = ? AND month = ? AND day = ?',
      whereArgs: [entry.year, entry.month, entry.day],
    );

    if (existing.isNotEmpty) {
      // Update existing entry
      return await db.update(
        'blood_sugar_entries',
        entry.toMap(),
        where: 'year = ? AND month = ? AND day = ?',
        whereArgs: [entry.year, entry.month, entry.day],
      );
    } else {
      // Insert new entry
      return await db.insert('blood_sugar_entries', entry.toMap());
    }
  }

  // Get entry for today
  Future<BloodSugarEntry?> getTodayEntry() async {
    final jalali = Jalali.now();
    return await getEntryForDate(jalali.year, jalali.month, jalali.day);
  }

  // Get entry for specific date
  Future<BloodSugarEntry?> getEntryForDate(int year, int month, int day) async {
    final db = await database;
    final maps = await db.query(
      'blood_sugar_entries',
      where: 'year = ? AND month = ? AND day = ?',
      whereArgs: [year, month, day],
    );

    if (maps.isNotEmpty) {
      return BloodSugarEntry.fromMap(maps.first);
    }
    return null;
  }

  // Get all entries
  Future<List<BloodSugarEntry>> getAllEntries() async {
    final db = await database;
    final maps = await db.query(
      'blood_sugar_entries',
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => BloodSugarEntry.fromMap(map)).toList();
  }

  // Get entries for last N months
  Future<List<BloodSugarEntry>> getEntriesLastMonths(int months) async {
    final db = await database;
    final now = Jalali.now();
    final threeMonthsAgo = now.addMonths(-months);

    final maps = await db.query(
      'blood_sugar_entries',
      orderBy: 'timestamp ASC',
    );

    final allEntries = maps.map((map) => BloodSugarEntry.fromMap(map)).toList();
    
    // Filter entries within the last N months
    return allEntries.where((entry) {
      final entryDate = Jalali(entry.year, entry.month, entry.day);
      return entryDate.compareTo(threeMonthsAgo) >= 0;
    }).toList();
  }

  // Delete entry
  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete(
      'blood_sugar_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
