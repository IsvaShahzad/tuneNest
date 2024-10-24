  import 'package:flutter/material.dart';
  import 'package:spotifyapi/spotify_auth.dart';
  import 'package:url_launcher/url_launcher.dart';
  import 'detail_screen.dart';
  import 'model.dart';

  class HomeScreen extends StatefulWidget {
    @override
    _HomeScreenState createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    final SpotifyAuth spotifyAuth = SpotifyAuth();
    String? accessToken;
    List<Track>? tracks; // List to hold all songs by Bruno Mars

    // Function to play the track using the URL
    void _playTrack(String trackUrl) async {
      final Uri url = Uri.parse(trackUrl); // Convert the trackUrl to a Uri

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
      else {
        print('Could not launch $trackUrl, trying to open in web browser');

        // Attempt to open the URL directly
        try {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } catch (e) {
          print('Error launching URL: $e');
          throw 'Could not launch $trackUrl'; // Log the error
        }
      }
    }

    // Function to fetch all songs by Bruno Mars
    void _fetchBrunoMarsTracks() async {
      if (accessToken == null) return; // Ensure accessToken is available

      try {
        // Clear the previous list of tracks to avoid duplicates
        tracks?.clear(); // Clear existing tracks

        // Fetch new tracks by Bruno Mars
        tracks = await spotifyAuth.searchTracksByArtist('Bruno Mars', accessToken!);
        setState(() {}); // Trigger UI rebuild to display fetched tracks
      } catch (e) {
        print('Error fetching tracks: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch tracks: $e')),
        );
      }
    }

    void _fetchHozierTracks() async {
      if (accessToken == null) return; // Ensure accessToken is available

      try {
        // Clear the previous list of tracks to avoid duplicates
        tracks?.clear(); // Clear existing tracks

        // Fetch new tracks by Bruno Mars
        tracks = await spotifyAuth.searchTracksByArtist('Hozier', accessToken!);
        setState(() {}); // Trigger UI rebuild to display fetched tracks
      } catch (e) {
        print('Error fetching tracks: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch tracks: $e')),
        );
      }
    }

    void _fetchAnuvJainSongs() async {
      if (accessToken == null) return; // Ensure accessToken is available

      try {
        // Clear the previous list of tracks to avoid duplicates
        tracks?.clear(); // Clear existing tracks

        // Fetch new tracks by Bruno Mars
        tracks = await spotifyAuth.searchTracksByArtist('Anuv Jain', accessToken!);
        setState(() {}); // Trigger UI rebuild to display fetched tracks
      } catch (e) {
        print('Error fetching tracks: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch tracks: $e')),
        );
      }
    }
    void _fetchDjoTracks() async {
      if (accessToken == null) return; // Ensure accessToken is available

      try {
        // Clear the previous list of tracks to avoid duplicates
        tracks?.clear(); // Clear existing tracks

        // Fetch new tracks by Bruno Mars
        tracks = await spotifyAuth.searchTracksByArtist('Djo', accessToken!);
        setState(() {}); // Trigger UI rebuild to display fetched tracks
      } catch (e) {
        print('Error fetching tracks: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch tracks: $e')),
        );
      }
    }
    void _fetchGotyeTracks() async {
      if (accessToken == null) return; // Ensure accessToken is available

      try {
        // Clear the previous list of tracks to avoid duplicates
        tracks?.clear(); // Clear existing tracks

        // Fetch new tracks by Bruno Mars
        tracks = await spotifyAuth.searchTracksByArtist('Gotye', accessToken!);
        setState(() {}); // Trigger UI rebuild to display fetched tracks
      } catch (e) {
        print('Error fetching tracks: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch tracks: $e')),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.center,
              child: Text('TuneNest')),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: accessToken == null
                ? ElevatedButton(
              onPressed: () async {
                try {
                  await spotifyAuth.authenticate();
                  setState(() {
                    accessToken = spotifyAuth.accessToken;
                  });
                } catch (e) {
                  print('Error during authentication: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Authentication failed: $e')),
                  );
                }
              },
              child: Text(
                'Login with Spotify',
                style: TextStyle(color: Colors.black),
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchBrunoMarsTracks,
                  child: Text('Fetch Songs by Bruno Mars'),
                ),

                ElevatedButton(
                  onPressed: _fetchHozierTracks,
                  child: Text('Fetch Songs by Hozier '),
                ),
                ElevatedButton(
                  onPressed: _fetchAnuvJainSongs,
                  child: Text('Fetch Songs by Anuv Jain'),
                ),
                ElevatedButton(
                  onPressed: _fetchDjoTracks,
                  child: Text('Fetch Songs by Djo'),
                ),
                ElevatedButton(
                  onPressed: _fetchGotyeTracks,
                  child: Text('Fetch Songs by Gotye'),
                ),

                SizedBox(height: 20),
                if (tracks != null) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tracks!.length,
                    itemBuilder: (context, index) {
                      final track = tracks![index];
                      return ListTile(
                        leading: Image.network(track.imageUrl),
                        title: Text(track.name),
                        subtitle: Text('Artist: ${track.artist}'),
                        onTap: () {
                          // Navigate to SongDetailScreen when the tile is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongDetailScreen(
                                imageUrl: track.imageUrl,
                                songName: track.name,
                                artist: track.artist,
                                trackId: track.id, // Pass the track ID for playback
                              ),
                            ),
                          );
                        },
                        // trailing: ElevatedButton(
                        //   onPressed: () {
                        //     _playTrack('https://open.spotify.com/track/${track.id}');
                        //   },
                        //   child: Text('Play'),
                        // ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
  }
