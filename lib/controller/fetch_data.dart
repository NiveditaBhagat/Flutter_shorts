import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shorts/model/post_model.dart';

class HomeController {
  List<Post> posts = [];
  int currentPage = 0;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  void init() {
    scrollController.addListener(scrollListener);
    fetchData();
  }

  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  Future<void> fetchData() async {
    try {
      final url = 'https://internship-service.onrender.com/videos?page=$currentPage';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final postsData = jsonData['data']['posts'];

        List<Post> fetchedPosts = [];
        for (var postData in postsData) {
          fetchedPosts.add(Post.fromJson(postData));
        }

        posts.addAll(fetchedPosts);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> loadMoreData() async {
    if (!isLoading) {
      isLoading = true;

      currentPage++;

      try {
        final url = 'https://internship-service.onrender.com/videos?page=$currentPage';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final postsData = jsonData['data']['posts'];

          List<Post> newPosts = [];
          for (var postData in postsData) {
            newPosts.add(Post.fromJson(postData));
          }

          posts.addAll(newPosts);
        } else {
          throw Exception('Failed to fetch data');
        }
      } catch (error) {
        print('Error: $error');
      }

      isLoading = false;
    }
  }
}
