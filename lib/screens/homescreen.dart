import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spotifyapi/auth/spotify_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/artists_data.dart';
import 'detail_screen.dart';
import 'fetch_artists.dart';
import '../model/model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpotifyAuth spotifyAuth = SpotifyAuth();
  late final TrackFetcher trackFetcher;
  String? accessToken;
  List<Track>? tracks;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    trackFetcher = TrackFetcher(spotifyAuth);
    if (spotifyAuth.accessToken != null) {
      accessToken = spotifyAuth.accessToken;
      _fetchTracks('Bruno Mars');
    }
  }

  void _fetchTracks(String artist) async {
    if (accessToken == null) return;
    trackFetcher.setAccessToken(accessToken!);
    try {
      tracks = await trackFetcher.fetchTracksByArtist(artist);
      setState(() {});
    } catch (e) {
      print('Error fetching tracks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch tracks: $e')),
      );
    }
  }

  void _searchArtist() {
    String artistName = _searchController.text.trim();
    if (artistName.isNotEmpty) {
      _fetchTracks(artistName);
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: accessToken != null
          ? AppBar(
              title: Text(
                'Tune Nest',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: width * 0.05,
                ),
              ),
              backgroundColor: Colors.black,
              elevation: 0,
            )
          : null,
      body: Stack(
        children: [
          Center(
            child: Container(
              color: accessToken == null ? Colors.transparent : Colors.black,
              child: accessToken == null
                  ? Lottie.asset(
                      'assets/animations/lottie.json',
                      width: width * 0.7,
                    )
                  : SizedBox.expand(),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: accessToken == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.8),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await spotifyAuth.authenticate();
                              setState(() {
                                accessToken = spotifyAuth.accessToken;
                              });
                              _fetchTracks('Bruno Mars');
                            } catch (e) {
                              print('Error during authentication: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Authentication failed: $e')),
                              );
                            }
                          },
                          child: Text(
                            'Login with Spotify',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: width * 0.04,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: width * 0.1,
                            ),
                            elevation: 5,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.06),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            cursorColor: Colors.white,
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              hintText: 'Search Artist and Songs',
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.grey.shade500,
                                fontSize: width * 0.04,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search, color: Colors.grey),
                                onPressed: _searchArtist,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade700),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade700),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade700),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Container(
                          height: size.height * 0.2,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: artists.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (context, index) {
                              final artist = artists[index];
                              return GestureDetector(
                                onTap: () => _fetchTracks(artist['name']!),
                                child: Column(
                                  children: [
                                    Container(
                                      width: width * 0.3,
                                      height: width * 0.3,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(artist['imageUrl']!),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      artist['name']!,
                                      style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        if (tracks != null) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: tracks!.length,
                            itemBuilder: (context, index) {
                              final track = tracks![index];
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 5), // Adjust horizontal padding
                                leading: Image.network(
                                  track.imageUrl,
                                  width: width * 0.17,
                                  height: width * 0.17,
                                ),
                                title: Text(
                                  track.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.04,
                                  ),
                                ),
                                subtitle: Text(
                                  '${track.artist}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SongDetailScreen(
                                        imageUrl: track.imageUrl,
                                        songName: track.name,
                                        artist: track.artist,
                                        trackId: track.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
