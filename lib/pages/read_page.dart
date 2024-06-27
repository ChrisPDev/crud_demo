import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/album.dart';

/// Fetches an album from the JSONPlaceholder API.
///
/// This function sends a GET request to the JSONPlaceholder API to fetch
/// the album with ID 1. It expects a JSON response containing the album details.
/// If the request is successful (status code 200), it returns an [Album] object
/// created from the JSON response. If the request fails, it throws an exception.
///
/// Returns a [Future<Album>] that completes with the fetched album.
Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load album');
  }
}

/// A [StatefulWidget] that provides the UI for fetching and displaying an album.
class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

/// The state for the [ReadPage] widget.
///
/// This state manages the future result of the album fetching API call.
class _ReadPageState extends State<ReadPage> {
  // Future to hold the result of the fetchAlbum API call.
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    // Initiates the API call to fetch the album when the state is created.
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fetch Data')),
      body: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // If the API call was successful, display the album title.
              return Text(snapshot.data!.title);
            } else if (snapshot.hasError) {
              // If the API call failed, display the error message.
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner while waiting for the response.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
