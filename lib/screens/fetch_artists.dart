// fetch_tracks.dart
import 'package:spotifyapi/auth/spotify_auth.dart';
import '../model/model.dart';

class TrackFetcher {
  final SpotifyAuth spotifyAuth;
  String? accessToken;

  TrackFetcher(this.spotifyAuth);

  Future<List<Track>?> fetchTracksByArtist(String artistName) async {
    if (accessToken == null) return null; // Ensure accessToken is available

    try {
      return await spotifyAuth.searchTracksByArtist(artistName, accessToken!);
    } catch (e) {
      print('Error fetching tracks: $e');
      return null;
    }
  }

  void setAccessToken(String token) {
    accessToken = token;
  }
}
