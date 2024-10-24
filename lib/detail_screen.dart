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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(songName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl),
            SizedBox(height: 20),
            Text(
              songName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Artist: $artist',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _playTrack('https://open.spotify.com/track/$trackId');
              },
              child: Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
