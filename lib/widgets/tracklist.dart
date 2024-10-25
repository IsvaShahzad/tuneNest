// lib/widgets/track_list.dart
import 'package:flutter/material.dart';
import '../model/model.dart';
import '../screens/detail_screen.dart';

class TrackList extends StatelessWidget {
  final List<Track> tracks;

  const TrackList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          leading: Image.network(track.imageUrl),
          title: Text(track.name, style: TextStyle(color: Colors.white)),
          subtitle: Text(track.artist, style: TextStyle(color: Colors.grey)),
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
    );
  }
}
