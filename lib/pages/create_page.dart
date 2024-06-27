import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/album.dart';

/// Sends a POST request to create a new album with the given [title].
///
/// This function sends a POST request to the JSONPlaceholder API with
/// the title of the album as the request body. It expects a JSON response
/// containing the newly created album details. If the request is successful
/// (status code 201), it returns an [Album] object created from the JSON response.
/// If the request fails, it throws an exception.
///
/// [title] is the title of the album to be created.
///
/// Returns a [Future<Album>] that completes with the created album.
Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{ 'title': title }),
  );

  if (response.statusCode == 201) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create album.');
  }
}

/// A [StatefulWidget] that provides the UI for creating a new album.
///
/// This widget includes a [TextField] for entering the album title and an
/// [ElevatedButton] to submit the request. Once the request is made, it shows
/// the result of the request (either the album title or an error message).
class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

/// The state for the [CreatePage] widget.
///
/// This state manages the text input controller and the future result of
/// the album creation API call.
class _CreatePageState extends State<CreatePage> {
  // Controller for the text field to capture the album title.
  final TextEditingController _controller = TextEditingController();
  
  // Future to hold the result of the createAlbum API call.
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Data')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // If _futureAlbum is null, show the input form, otherwise show the result.
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  /// Builds the UI for entering the album title and submitting the request.
  ///
  /// This method returns a [Column] widget that contains a [TextField] for
  /// entering the album title and an [ElevatedButton] for submitting the
  /// create album request.
  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Text field for entering the album title.
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        // Button to submit the request to create a new album.
        ElevatedButton(
          onPressed: () {
            // When the button is pressed, set the state to initiate the API call.
            setState(() {
              _futureAlbum = createAlbum(_controller.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  /// Builds the UI for displaying the result of the createAlbum API call.
  ///
  /// This method returns a [FutureBuilder] that shows a loading spinner
  /// while waiting for the API response, the album title if the request
  /// is successful, or an error message if the request fails.
  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
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
    );
  }
}
