// lib/widgets/artist_grid.dart
import 'package:flutter/material.dart';
import '../data/artists_data.dart';

class ArtistGrid extends StatelessWidget {
  final Function(String) onArtistTap;

  const ArtistGrid({required this.onArtistTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final artist = artists[index];
          return GestureDetector(
            onTap: () => onArtistTap(artist['name']!),
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
    );
  }
}
