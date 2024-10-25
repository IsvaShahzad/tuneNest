class Track {
  final String id; // Ensure this property is defined
  final String name;
  final String artist;
  final String album;
  final String imageUrl;

  Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.album,
    required this.imageUrl,
  });

  // You may also want to add a factory constructor for JSON parsing
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'], // Ensure the JSON maps to this property
      name: json['name'],
      artist: json['artists'][0]['name'], // Adjust based on your JSON structure
      album: json['album']['name'],
      imageUrl: json['album']['images'][0]['url'],
    );
  }
}