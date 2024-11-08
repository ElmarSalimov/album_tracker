import 'package:dio/dio.dart';
import 'package:spotify_app/data/models/track.dart';
import 'package:spotify_app/util/constants.dart';

class ApiService {
  final Dio _dio = Dio();

  // Get playlists
  Future<dynamic> getPlaylists() async {
    try {
      Response response = await _dio.get(
        "https://api.spotify.com/v1/me/playlists",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        return data['items'];
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Get tracks
  Future<List<Song>?> getTracks(String playlistId) async {
    List<Song> mainList = [];
    int offset = 0;

    try {
      Response response = await _dio.get(
        "https://api.spotify.com/v1/playlists/$playlistId/tracks?offset=$offset&limit=100",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );

      // Process the first batch of tracks
      if (response.statusCode == 200) {
        var data = response.data['items'] as List;
        mainList.addAll(data.map((e) => Song.fromJson(e)).toList());
      }

      // Loop through the next batches if available
      while (response.data['next'] != null) {
        offset += 100;
        response = await _dio.get(
          "https://api.spotify.com/v1/playlists/$playlistId/tracks?offset=$offset&limit=100",
          options: Options(headers: {"Authorization": "Bearer $accessToken"}),
        );

        if (response.statusCode == 200) {
          var data = response.data['items'] as List;
          mainList.addAll(data.map((e) => Song.fromJson(e)).toList());
        }
      }

      return mainList;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }
}
