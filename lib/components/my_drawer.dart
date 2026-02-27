import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/settings_page.dart';

import '../pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.secondary.withOpacity(0.85),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 80),
            child: ListTile(
              title: const Text('H O M E'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ),

          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 0),
            child: ListTile(
              title: const Text('P R O F I L E'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 0),
            child: ListTile(
              title: const Text('S E T T I N G S'),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
