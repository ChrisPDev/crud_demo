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

/// Sends a PUT request to update an album with the given [title].
///
/// This function sends a PUT request to the JSONPlaceholder API to update
/// the album with ID 1. It sends a JSON payload containing the updated title.
/// If the request is successful (status code 200), it returns an [Album] object
/// created from the JSON response. If the request fails, it throws an exception.
///
/// Returns a [Future<Album>] that completes with the updated album.
Future<Album> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{ 'Content-Type': 'application/json; charset=UTF-8' },
    body: jsonEncode(<String, String>{ 'title': title }),
  );
  
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to update album.');
  }
}

/// A [StatefulWidget] that provides the UI for fetching and updating an album.
class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

/// The state for the [UpdatePage] widget.
///
/// This state manages the future result of the album fetching and updating API calls.
class _UpdatePageState extends State<UpdatePage> {
  // Controller for the text field to capture the updated album title.
  final TextEditingController _controller = TextEditingController();
  
  // Future to hold the result of the fetchAlbum API call.
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    // Initiates the API call to fetch the album when the state is created.
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Data')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // If the API call was successful, display the album title and input field for updating.
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Display the current album title.
                      Text(snapshot.data!.title),
                      // Text field for entering the updated album title.
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: 'Enter Title'),
                      ),
                      // Button to submit the request to update the album.
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureAlbum = updateAlbum(_controller.text);
                          });
                        },
                        child: const Text('Update Data'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  // If the API call failed, display the error message.
                  return Text('${snapshot.error}');
                }
              }
              // By default, show a loading spinner while waiting for the response.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
