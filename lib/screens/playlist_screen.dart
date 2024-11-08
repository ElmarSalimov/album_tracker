import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify_app/data/models/track.dart';
import 'package:spotify_app/data/services/api.dart';

class PlaylistScreen extends StatefulWidget {
  final String accessToken;
  final String playlistId;
  const PlaylistScreen(
      {super.key, required this.accessToken, required this.playlistId});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final ApiService apiService = ApiService();

  List<Song> playlistTracks = [];
  late int value;

  @override
  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    playlistTracks = (await apiService.getTracks(widget.playlistId))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: const Text(
          "Playlist Tracks",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: apiService.getTracks(widget.playlistId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data;
                if (data != null) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var track = data[index];
                        return SizedBox(
                          child: Row(
                            children: [
                              Text(
                                "${track.track!.name!}\t",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  fontSize: 13,
                                )),
                              ),
                              Text(
                                track.track!.artists!.first.name!,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  fontSize: 13,
                                )),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    );
  }
}
