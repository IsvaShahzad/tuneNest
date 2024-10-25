import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spotifyapi/auth/spotify_auth.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final FocusNode _searchFocusNode = FocusNode(); // Create a FocusNode



  @override
  void initState() {
    super.initState();
    trackFetcher = TrackFetcher(spotifyAuth);
    if (spotifyAuth.accessToken != null) {
      accessToken = spotifyAuth.accessToken;
      _fetchTracks('Bruno Mars');
    }
  }

  void _playTrack(String trackUrl) async {
    final Uri url = Uri.parse(trackUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $trackUrl, trying to open in web browser');
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        print('Error launching URL: $e');
      }
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: accessToken != null
          ? AppBar(
        title: Text(
          'Tune Nest',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      )
          : null,
      body: Stack(
        children: [
          // Background with Lottie animation
          Center(
            child: Container(
              color: accessToken == null ? Colors.transparent : Colors.black,
              child: accessToken == null
                  ? Lottie.asset(
                'assets/animations/lottie.json', // Path to your Lottie file
            
              )
                  : SizedBox.expand(),
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Center(
              child: accessToken == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 650),
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
                          SnackBar(content: Text('Authentication failed: $e')),
                        );
                      }
                    },
                    child: Text(
                      'Login with Spotify',
                      style: TextStyle(
                        color: Colors.white, // Text color set to white for contrast
                        fontFamily: 'Montserrat'// Make text bold
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54, // Set button color to light black (using black54)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                        side: BorderSide(color: Colors.white.withOpacity(0.5)), // Optional border for contrast
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Add padding for larger touch area
                      elevation: 5, // Add elevation for depth
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode, // Attach the FocusNode
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.grey.shade400, fontFamily: 'Montserrat'),
                      decoration: InputDecoration(
                        hintText: 'Search Artist and Songs',
                        hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: Colors.grey),
                          onPressed: _searchArtist,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Padding(padding: EdgeInsets.only(right: 190),
                  //     // child: Text('Trending Artists', style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 16),)),
                  // //

                  SizedBox(height: 15),
                  Container(
                    height: 135,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final artists = [
                          {
                            'name': 'Bruno Mars',
                            'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP-_9y8kThfys0ULNZOLF1NwHoJTb_IYITlg&s',
                          },
                          {
                            'name': 'Hozier',
                            'imageUrl': 'https://www.rollingstone.com/wp-content/uploads/2024/03/Hozier-Unheard-EP.jpg',
                          },
                          {
                            'name': 'Billie Elish',
                            'imageUrl': 'https://static.sky.it/editorialimages/ea77c9d74973204e079adc6c1031bffd888f0898/skytg24/it/spettacolo/musica/2021/09/03/billie-eilish-happier-than-ever/00-billie-eilish-kikapress.jpg',
                          },
                          {
                            'name': 'Anuv Jain',
                            'imageUrl': 'https://i.tribune.com.pk/media/images/WhatsApp-Image-2022-09-18-at-3-48-03-PM1663498094-0/WhatsApp-Image-2022-09-18-at-3-48-03-PM1663498094-0.jpeg',
                          },
                          {
                            'name': 'Djo',
                            'imageUrl': 'https://djomerch.com/wp-content/uploads/2023/07/Djo-Merch-1-scaled.jpeg',
                          },
                          {
                            'name': 'Gotye',
                            'imageUrl': 'https://imagez.tmz.com/image/d7/1by1/2019/10/24/d722490682024681b1bd716c8fe616eb_xl.jpg',
                          },
                        ];

                        final artist = artists[index];
                        return GestureDetector(
                          onTap: () => _fetchTracks(artist['name']!),
                          child: Column(
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(artist['imageUrl']!),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                artist['name']!,
                                style: TextStyle(fontSize: 14, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // Track List
                  if (tracks != null) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tracks!.length,
                      itemBuilder: (context, index) {
                        final track = tracks![index];
                        return ListTile(
                          leading: Image.network(track.imageUrl),
                          title: Text(
                            track.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${track.artist}',
                            style: TextStyle(color: Colors.grey),
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
    _searchFocusNode.dispose(); // Dispose of the FocusNode
    _searchController.dispose();
    super.dispose();
  }
}
