import 'package:dictionary/data/data.dart' as dictionary;
import 'package:dictionary/Model/db_helper.dart';
import 'package:dictionary/pages/home_page.dart';
import 'package:dictionary/pages/intropage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  dictionary.Data data = dictionary.Data();
  Get.put(data);

  // Create database
  DBHelper db = DBHelper();

  // Ensure database is initialized before querying data
  await db.init();

  // Print table names for debugging
  await db.printTableNames();

  // Query data from database and add it to list(MyData)
  var list = await db.getAll("SELECT * FROM Items LIMIT 100");
  if (list.isEmpty) {
    print('No data found');  // Debug print for no data found
  } else {
    print('Data found: $list');  // Debug print for data found
    data.list.value = list.map((item) => item ?? {}).toList();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
