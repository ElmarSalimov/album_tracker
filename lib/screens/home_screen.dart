import 'package:flutter/material.dart';
import 'package:spotify_app/data/services/api.dart';
import 'package:spotify_app/screens/playlist_screen.dart';
import 'package:spotify_app/util/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder(
                future: apiService.getPlaylists(),
                builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data;
            if (data != null) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var playlist = data[index];
                    return GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlaylistScreen(
                                  accessToken: accessToken,
                                  playlistId: playlist['id'],
                                ))),
                        child: Text(playlist['name']));
                  },
                ),
              );
            }
          }
          return const CircularProgressIndicator();
                },
              ),
        ));
  }
}
