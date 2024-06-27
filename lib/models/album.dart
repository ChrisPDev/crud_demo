/// A model class representing an Album with an id and a title.
class Album {
  /// The unique identifier for the album.
  final int id;

  /// The title of the album.
  final String title;

  /// A constant constructor for creating an Album instance.
  ///
  /// This constructor requires [id] and [title] parameters to be passed.
  const Album({required this.id, required this.title});

  /// A factory constructor that creates an Album instance from a JSON map.
  ///
  /// The [json] parameter is a map representation of JSON data.
  /// This method will parse the JSON data and return an Album object.
  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
      } => 
        Album(
          id: id,
          title: title,
        ),
      // Throws a FormatException if the JSON format is unexpected.
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  /// A factory constructor that returns an empty Album instance.
  ///
  /// This is useful when an album is deleted or not found. It returns
  /// an Album instance with default id `0` and title `No Album`.
  factory Album.empty() {
    return const Album(id: 0, title: 'No Album');
  }
}
