import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SongDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String songName;
  final String artist;
  final String trackId;

  SongDetailScreen({
    required this.imageUrl,
    required this.songName,
    required this.artist,
    required this.trackId,
  });

  void _playTrack(String trackUrl) async {
    final Uri url = Uri.parse(trackUrl); // Convert the trackUrl to a Uri

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView( // Enable scrolling for smaller screens
        child: Column(
          children: [
            // Image at the top
            Container(
              margin: EdgeInsets.only(top: 20), // Add margin to the top
              child: Image.network(
                imageUrl,
                height: 400, // Set a height for the image
                fit: BoxFit.cover, // Ensure the image covers the space
                width: double.infinity, // Full width
              ),
            ),
            SizedBox(height: 20),
            Text(
              songName,
              style: TextStyle(fontSize: 23, color: Colors.white, fontFamily: 'Montserrat'),
              textAlign: TextAlign.center, // Center the text
            ),
            SizedBox(height: 8),
            Text(
              artist,
              style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'Montserrat'),
              textAlign: TextAlign.center, // Center the text
            ),
            SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () {
                  _playTrack('https://open.spotify.com/track/$trackId');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Square corners
                  ),
                  backgroundColor: Colors.white, // Set button color to white
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Adjusted padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  children: [
                    Text(
                      'Play', // Button text
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 16,
                        fontFamily: 'Montserrat', // Text font
                      ),
                    ),
                    SizedBox(width: 5), // Space between text and icon
                    Icon(
                      Icons.play_arrow, // Play icon
                      color: Colors.black, // Set icon color to black for contrast
                      size: 25, // Size of the icon
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
