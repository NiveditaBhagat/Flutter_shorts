import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shorts/model/post_model.dart';

Future<List<Post>> fetchData(int page, int limit) async {
  final url = 'https://internship-service.onrender.com/videos?page=$page&limit=$limit';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final postsData = jsonData['data']['posts'];

    List<Post> posts = [];
    for (var postData in postsData) {
      posts.add(Post.fromJson(postData));
    }

    return posts;
  } else {
    throw Exception('Failed to fetch data');
  }
}

    
  
