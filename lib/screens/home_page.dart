import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shorts/model/post_model.dart';
import 'package:flutter_shorts/screens/display_shorts_screen.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  int currentPage = 1;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    fetchData();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  Future<void> fetchData() async {
    try {
      final url =
          'https://internship-service.onrender.com/videos?page=$currentPage';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final postsData = jsonData['data']['posts'];

        List<Post> fetchedPosts = [];
        for (var postData in postsData) {
          fetchedPosts.add(Post.fromJson(postData));
        }

        setState(() {
          posts = fetchedPosts;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> loadMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      currentPage++;

      try {
        final url =
            'https://internship-service.onrender.com/videos?page=$currentPage';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final postsData = jsonData['data']['posts'];

          List<Post> newPosts = [];
          for (var postData in postsData) {
            newPosts.add(Post.fromJson(postData));
          }

          setState(() {
            posts.addAll(newPosts);
            isLoading = false;
          });
        } else {
          throw Exception('Failed to fetch data');
        }
      } catch (error) {
        print('Error: $error');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 90) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisSpacing: 11.0,
          mainAxisSpacing: 6.0,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          if (index == posts.length - 1) {
            return GestureDetector(
              onTap: () {
                navigateToDisplayScreen(posts[index]);
              },
              child: Column(
                children: [
                  buildPostItem(posts[index]),
                  buildLoadingIndicator(),
                ],
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                navigateToDisplayScreen(posts[index]);
              },
              child: buildPostItem(posts[index]),
            );
          }
        },
      ),
    );
  }

  void navigateToDisplayScreen(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayShortsScreen(posts: posts),
      ),
    );
  }

  Widget buildPostItem(Post post) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(post.submission.thumbnail),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : SizedBox.shrink();
  }
}
