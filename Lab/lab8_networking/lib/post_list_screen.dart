import 'package:flutter/material.dart';
import 'api_service.dart';
import 'post.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final ApiService apiService;
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();

    apiService = ApiService();
    futurePosts = apiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts from API'),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text('Unable to load posts'),
                  ElevatedButton(
                    onPressed: retryLoading,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final posts = snapshot.data ?? [];

          // Empty
          if (posts.isEmpty) {
            return const Center(
              child: Text('No posts found'),
            );
          }

          // Has data
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text('${post.id}'),
                ),
                title: Text(post.title),
                subtitle: Text(
                  'User ID: ${post.userId}\n${post.body}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: createPostDemo,
        icon: const Icon(Icons.add),
        label: const Text('Create Post'),
      ),
    );
  }

  void retryLoading() {
    setState(() {
      futurePosts = apiService.fetchPosts();
    });
  }

  @override
  void dispose() {
    apiService.dispose();
    super.dispose();
  }

  Future<void> createPostDemo() async {
    try {
      final post = await apiService.createPost(
        title: 'My first post',
        body: 'Learning Flutter POST',
      );

      // Print created data
      print('Post created successfully!');
      print('ID: ${post.id}');
      print('User ID: ${post.userId}');
      print('Title: ${post.title}');
      print('Body: ${post.body}');

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Post created successfully! ID: ${post.id}',
          ),
        ),
      );
    } catch (e) {
      // Print error
      print('Error creating post: $e');

      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create post'),
        ),
      );
    }
  }
}