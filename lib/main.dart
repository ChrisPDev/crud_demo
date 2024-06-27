import 'package:flutter/material.dart';
import 'package:crud_demo/pages/create_page.dart';
import 'package:crud_demo/pages/read_page.dart';
import 'package:crud_demo/pages/update_page.dart';
import 'package:crud_demo/pages/delete_page.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Demo', // App title shown in the device's title bar
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Custom color scheme based on deep purple
        useMaterial3: true, // Enable Material 3 design principles
      ),
      home: const HomePage(), // Set the home page to be the HomePage widget
    );
  }
}

/// The home page of the application, containing a navigation drawer.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Demo'), // Title of the app bar
      ),
      drawer: Drawer( // Navigation drawer containing menu items
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple, // Header background color
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(color: Colors.white, fontSize: 24), // Header text style
              ),
            ),
            ListTile(
              title: const Text('Create'), // Menu item for creating data
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePage()), // Navigate to CreatePage on tap
                );
              },
            ),
            ListTile(
              title: const Text('Read'), // Menu item for reading data
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadPage()), // Navigate to ReadPage on tap
                );
              },
            ),
            ListTile(
              title: const Text('Update'), // Menu item for updating data
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdatePage()), // Navigate to UpdatePage on tap
                );
              },
            ),
            ListTile(
              title: const Text('Delete'), // Menu item for deleting data
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeletePage()), // Navigate to DeletePage on tap
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Select an action from the navigation menu.'), // Placeholder text in the body
      ),
    );
  }
}
