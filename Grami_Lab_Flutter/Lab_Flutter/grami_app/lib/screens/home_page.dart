import 'package:flutter/material.dart';
import 'cnn_page.dart'; // Importez la page CNN ici

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    'Grami Salma',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/photo.png'),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Smart_App covid tracker'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Home page or perform actions
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('ANN'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Home page or perform actions
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('CNN'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CnnPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Emsi_bot'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Home page or perform actions
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Profile page or perform actions
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_right),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Settings page or perform actions
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: const Center(
          child: Text('Home Page'),
        ),
      ),
    );
  }
}
