    import 'dart:io';
    import 'package:flutter/services.dart';
    import 'package:path/path.dart';
    import 'package:sqflite/sqflite.dart';

    class DBHelper {
      Database? database;

      DBHelper() {
        init();
      }

      Future<void> init() async {
        try {
          var databasesPath = await getDatabasesPath();
          // ignore: unnecessary_null_comparison
          if (databasesPath == null) {
            throw Exception("Failed to get database path.");
          }
          String path = join(databasesPath, 'khmer.db');

          // Check if the database exists
          bool exists = await databaseExists(path);

          if (!exists) {
            // Copy from asset
            print('Creating new copy from asset');

            // Make sure the parent directory exists
            await Directory(dirname(path)).create(recursive: true);

            // Copy the database
            ByteData data = await rootBundle.load(join('assets', 'khmer.db'));
            List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

            await File(path).writeAsBytes(bytes, flush: true);
            print('Database copied from assets');
          } else {
            print('Opening existing database');
          }

          // Open the database
          database = await openDatabase(path, version: 1);
          print('Database opened');
        } catch (e, stacktrace) {
          print("Error during database initialization: $e");
          print("Stacktrace: $stacktrace");
        }
      }

      Future<void> insert(String query) async {
        if (database == null) await init();
        try {
          await database!.rawInsert(query);
        } catch (e, stacktrace) {
          print("Error executing insert query: $e");
          print("Stacktrace: $stacktrace");
        }
      }

      Future<void> update(String query) async {
        if (database == null) await init();
        try {
          await database!.rawUpdate(query);
        } catch (e, stacktrace) {
          print("Error executing update query: $e");
          print("Stacktrace: $stacktrace");
        }
      }

      Future<void> delete(String query) async {
        if (database == null) await init();
        try {
          await database!.rawDelete(query);
        } catch (e, stacktrace) {
          print("Error executing delete query: $e");
          print("Stacktrace: $stacktrace");
        }
      }

      Future<List<Map<String, Object?>>> getAll(String query) async {
        if (database == null) await init();
        try {
          var result = await database!.rawQuery(query);
          print('Query result: $result');  // Debug print to check query result
          return result ?? [];
        } catch (e, stacktrace) {
          print("Error executing getAll query: $e");
          print("Stacktrace: $stacktrace");
          return [];
        }
      }

      Future<void> printTableNames() async {
        if (database == null) await init();
        try {
          var result = await database!.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
          print('Table names: $result');
        } catch (e, stacktrace) {
          print("Error fetching table names: $e");
          print("Stacktrace: $stacktrace");
        }
      }
    }
