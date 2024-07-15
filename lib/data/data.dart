import 'package:get/state_manager.dart';

import '../Model/db_helper.dart';

class Data extends GetxController{
     var list=[].obs;
    var filteredList = [].obs;


     DBHelper dbHelper = DBHelper();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

   void fetchData() async {
    print("Fetching data...");
    try {
      var result = await dbHelper.getAll('SELECT * FROM Items LIMIT 100');
      if (result.isEmpty) {
        print("No data found");
      } else {
        print("Data fetched: $result");
      }
      list.value = result;
      filteredList.assignAll(list);
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching data: $e");
    }
    
  }

  void filterList(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(list); // If the query is empty, show all items
    } else {
      filteredList.assignAll(list.where((item) {
        return item['word']?.toString().toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList());
    }
  }

  
}
