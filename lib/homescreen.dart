import 'package:flutter/material.dart';
import 'package:spotifyapi/spotify_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpotifyAuth spotifyAuth = SpotifyAuth();
  String? accessToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Integration'),
      ),
      body: Center(
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
                    // Optionally show an alert to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Authentication failed: $e')),
                    );
                  }
                },
                child: Text(
                  'Login with Spotify Access Token: $accessToken',
                  style: TextStyle(color: Colors.black),
                ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Access Token: $accessToken',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Example: Fetch podcast episodes (replace with valid show ID)
                      await spotifyAuth
                          .fetchPodcastEpisodes('your_show_id_here');
                    },
                    child: Text('Fetch Podcast Episodes'),
                  ),
                ],
              ),
      ),
    );
  }
}
