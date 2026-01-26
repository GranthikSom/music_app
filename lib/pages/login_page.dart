import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/My_drawer.dart';
import 'package:flutter_application_1/models/playlist_provider.dart';
import 'package:provider/provider.dart';

import '../models/song_data.dart';
import 'song_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

@override
class _LoginPageState extends State<LoginPage> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    //initialize playlistProvider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    //set current song index in provider
    playlistProvider.currentSongIndex = songIndex;
    //navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("Welcome User")),
      drawer: MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          //get the playlist
          final List<Song> playlist = value.playlists;
          //return ListView ui
          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              //get the song data
              final Song song = playlist[index];
              //return ListTile ui
              return ListTile(
                title: Text(song.title),
                subtitle: Text(song.artist),
                leading: Image.asset(song.album),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}
