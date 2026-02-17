// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/song_ball.dart';
import 'package:flutter_application_1/components/song_box.dart';
import 'package:flutter_application_1/models/playlist_provider.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  //min to sec converter
  String formatTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // playlist data
        final playlist = value.playlists;
        //song index
        final songIndex = playlist[value.currentSongIndex ?? 0];
        //ui return
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image(image: AssetImage(songIndex.album), fit: BoxFit.cover),

              // Blur Layer
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withOpacity(0.05), // dark overlay
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 25,
                    top: 5,
                  ),

                  child: Column(
                    children: [
                      // app bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ),
                            icon: Icon(Icons.arrow_back),
                          ),

                          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            songIndex.quote,

                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),

                      //album artwork
                      SongBox(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(image: AssetImage(songIndex.album)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        songIndex.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(songIndex.artist),
                                    ],
                                  ),

                                  //like button
                                  Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ), // HAVE TO FIX THE LIKE OPTION LATER !!!!!!!!!!!!!!
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      //song duration slider
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatTime(value.currentDuration)),

                                Icon(Icons.shuffle),

                                Icon(Icons.repeat),

                                Text(formatTime(value.totalDuration)),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 0,
                              ),
                            ),
                            child: Slider(
                              value: value.currentDuration.inSeconds.toDouble(),
                              min: 0,
                              max: value.totalDuration.inSeconds.toDouble(),
                              activeColor: Colors.green,
                              onChanged: (double double) {},
                              onChangeEnd: (double double) {
                                value.seek(Duration(seconds: double.toInt()));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SongBall(
                            child: Expanded(
                              child: GestureDetector(
                                onTap: value.playPrevious,
                                child: CircleAvatar(
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  child: Icon(Icons.skip_previous),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SongBall(
                            child: Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: value.pauseOrResume,
                                child: CircleAvatar(
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  radius: 34,
                                  child: Icon(
                                    value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SongBall(
                            child: Expanded(
                              child: GestureDetector(
                                onTap: value.playNext,
                                child: CircleAvatar(
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  child: Icon(Icons.skip_next),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
