import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

class SpotifyAuth {
  final String clientId = '851b9e24e51b45b8a458f8a7d0b58880';
  final String redirectUri = 'yourapp://callback';

  String? accessToken;

  Future<void> authenticate() async {
    const String scopes = 'user-read-private streaming';
    final String url =
        'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=token&redirect_uri=$redirectUri&scope=$scopes';

    final result = await FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: 'yourapp',
    );

    accessToken = Uri.parse(result).fragment.split('&')[0].split('=')[1];
    print('Spotify Access Token: $accessToken');
  }

  Future<void> fetchPodcastEpisodes(String showId) async {
    final String url = 'https://api.spotify.com/v1/shows/$showId/episodes';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
    } else {
      print('Error fetching podcast episodes: ${response.statusCode}');
      print('Error response: ${response.body}');
    }
  }


}
