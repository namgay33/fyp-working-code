import 'package:first_app/components/about_us.dart';
import 'package:flutter/material.dart';

import 'categories.dart';
import 'home_page.dart';
import 'rank.dart';
import 'favorite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  List<Widget> pages = const [
    Home(
      description: '',
      englishText: '',
      dzongkhaText: '',
      image: '',
    ),
    Categories(),
    Rank(),
    Favorite(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 152, 18),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: () {
              debugPrint("Pressed on Coin");
              // Do something when the search icon is tapped
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () {
              // Do something when the more_vert icon is tapped
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: pages[currentPage],
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 152, 18),
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutUs()));
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: "Category",
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: "Rank",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}



      // apiKey: 'AIzaSyA8-WvSPSOqOn87gRu5H_uqJNxgikdasqc',
      // authDomain: 'paytam-490fa.firebaseapp.com',
      // databaseURL: 'https://paytam-490fa-default-rtdb.firebaseio.com',
      // projectId: 'paytam-490fa',
      // storageBucket: 'paytam-490fa.appspot.com',
      // messagingSenderId: '702069271398',
      // appId: '1:702069271398:web:8f1b722ae39f5d0745b6a7',
      // measurementId: 'G-0KBGM51WV2',