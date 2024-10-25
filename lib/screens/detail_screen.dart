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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Responsive image
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              width: double.infinity,
              child: Image.network(
                imageUrl,
                height: screenHeight * 0.57,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Text(
                songName,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Text(
                artist,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: ElevatedButton(
                onPressed: () {
                  _playTrack('https://open.spotify.com/track/$trackId');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.05,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: screenWidth * 0.06,
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
