import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/data.dart';
import 'defination_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController searchController = TextEditingController();

  void navigateToDefinitionScreen(
      BuildContext context, String word, String definition) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DefinationScreen(word: word, definition: definition)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Data dataController = Get.put(Data());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Agricultural Dictionary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.translate, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.apps, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25.0),
            decoration: const BoxDecoration(color: Colors.green),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                dataController.filterList(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for Words',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {},
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (dataController.filteredList.isEmpty) {
                return const Center(
                    child: Text(
                  'No data available',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ));
              }
              return ListView.builder(
                itemCount: dataController.filteredList.length,
                itemBuilder: (context, index) {
                  var item = dataController.filteredList[index];
                  var word = item['word']?.toString() ?? 'No Word';
                  var definition =
                      item['definition']?.toString() ?? 'No Definition';

                  // Filter out English definitions
                  if (!definition.contains(new RegExp(r'[A-Za-z]'))) {
                    return GestureDetector(
                      onTap: () =>
                          navigateToDefinitionScreen(context, word, definition),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white24),
                        child: ListTile(
                          leading: const Icon(Icons.wb_sunny_outlined,
                              color: Colors.green),
                          title: Text(word),
                          trailing: IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 300),
        index: 2,
        items: const [
          Icon(
            Icons.add,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.bookmark,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.history,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.camera_alt_rounded,
            size: 26,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          // Handle navigation logic here
          switch (index) {
            case 0:
              print("Add icon tapped");
              // Navigate to add page or perform add action
              break;
            case 1:
              print("Bookmark icon tapped");
              // Navigate to bookmarks page or perform bookmark action
              break;
            case 2:
              print("Home icon tapped");
              // Navigate to home page or perform home action
              break;
            case 3:
              print("History icon tapped");
              // Navigate to history page or perform history action
              break;
            case 4:
              print("Camera icon tapped");
              // Navigate to camera page or perform camera action
              break;
          }
        },
      ),
    );
  }
}
