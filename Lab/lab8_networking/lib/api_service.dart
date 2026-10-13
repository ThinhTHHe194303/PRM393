import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client})
      : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    final response = await client.get(
      Uri.parse(
        'https://jsonplaceholder.typicode.com/posts',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load posts');
    }

    final List<dynamic> data =
    json.decode(response.body);

    return data
        .map((item) => Post.fromJson(item))
        .toList();
  }

  Future<Post> createPost({
    required String title,
    required String body,
  }) async {
    final response = await client.post(
      Uri.parse(
        'https://jsonplaceholder.typicode.com/posts',
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'userId': 1,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create post');
    }

    return Post.fromJson(
      json.decode(response.body),
    );
  }

  void dispose() {
    client.close();
  }
}