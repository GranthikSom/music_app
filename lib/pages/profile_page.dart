import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/My_drawer.dart';
import 'package:flutter_application_1/components/bottombar.dart';
import 'package:flutter_application_1/components/song_ball.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      drawer: MyDrawer(),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      SongBall(
                        child: Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.inversePrimary,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              radius: 40,
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Faxektie op',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Text(
                            '@niggaslayer67',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Bottombar(),
    );
  }
}
