import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/album.dart';

/// Fetches an album from the server with ID 1.
///
/// Returns a [Future<Album>] that completes with the fetched album if the
/// request is successful, or throws an [Exception] if the request fails.
Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load album');
  }
}

/// Sends a DELETE request to remove an album from the server.
///
/// Takes [id] as a parameter to specify the ID of the album to delete.
/// Returns a [Future<Album>] that completes with an empty Album if the
/// deletion is successful, or throws an [Exception] if the request fails.
Future<Album> deleteAlbum(String id) async {
  final response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{ 'Content-Type': 'application/json; charset=UTF-8' },
  );

  if (response.statusCode == 200) {
    return Album.empty(); // Return an empty Album after successful deletion
  } else {
    throw Exception('Failed to delete album.');
  }
}

/// A StatefulWidget that provides the UI for deleting an album.
class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum(); // Fetch the initial album data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Data')),
      body: Center(
        child: FutureBuilder<Album>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // Display the album title and a button to delete it
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data?.title ?? 'Deleted'),
                    ElevatedButton(
                      child: const Text('Delete Data'),
                      onPressed: () {
                        // Initiate the deletion process
                        setState(() {
                          _futureAlbum = deleteAlbum(snapshot.data!.id.toString());
                        });
                      },
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                // Display error message if fetching or deleting fails
                return Text('${snapshot.error}');
              }
            }
            // Show a progress indicator while waiting for the future to complete
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
