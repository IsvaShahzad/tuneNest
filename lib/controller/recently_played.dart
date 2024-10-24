// import 'dart:convert';
//
// import 'package:get/get.dart';
// import '../model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class RecentlyPlayedController extends GetxController {
//   var recentlyPlayedTracks = <Track>[].obs; // Observable list for tracks
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadRecentlyPlayedTracks(); // Load tracks when initialized
//   }
//
//   // Load tracks from SharedPreferences
//   Future<void> _loadRecentlyPlayedTracks() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? storedTracks = prefs.getStringList('recentlyPlayed');
//     if (storedTracks != null) {
//       recentlyPlayedTracks.value = storedTracks
//           .map((trackJson) =>
//               Track.fromJson(jsonDecode(trackJson))) // Decode JSON string
//           .toList();
//     }
//   }
//
//   // Save track to SharedPreferences
//   Future<void> addTrack(Track track) async {
//     recentlyPlayedTracks.add(track); // Add to observable list
//
//     final prefs = await SharedPreferences.getInstance();
//     List<String> storedTracks = recentlyPlayedTracks
//         .map((track) => jsonEncode(track.toJson())) // Encode to JSON string
//         .toList();
//     await prefs.setStringList(
//         'recentlyPlayed', storedTracks); // Save to SharedPreferences
//   }
// }
