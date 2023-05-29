import 'package:flutter/material.dart';

class Post{
  Creator creator;
  Comment comment;
  Reaction reaction;
  Submission submission;

  Post({
    required this.comment,
    required this.creator,
    required this.reaction,
    required this.submission,
  
  });

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      comment: Comment.fromJson(json['comment']),  
      creator: Creator.fromJson(json['creator']), 
      reaction: Reaction.fromJson(json['reaction']), 
      submission: Submission.fromJson(json['submission']),
      );
  }

}

class Creator{
  String name;
  String handle;
  String id;
  String pic;

  Creator({
    required this.handle,
    required this.id,
    required this.name,
    required this.pic,
  });

  factory Creator.fromJson(Map<String, dynamic> json){
    return Creator(
      handle: json['handle'],
       id: json['id'], 
       name: json['name'], 
       pic: json['pic'],
       );
  }
}

class Comment {
  int count;
  bool commentingAllowed;

  Comment({
    required this.count,
    required this.commentingAllowed,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      count: json['count'],
      commentingAllowed: json['commentingAllowed'],
    );
  }
}

class Reaction {
  int count;
  bool voted;

  Reaction({
    required this.count,
    required this.voted,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      count: json['count'],
      voted: json['voted'],
    );
  }
}


class Submission {
  String title;
  String description;
  String mediaUrl;
  String thumbnail;
  String hyperlink;
  String placeholderUrl;

  Submission({
    required this.title,
    required this.description,
    required this.mediaUrl,
    required this.thumbnail,
    required this.hyperlink,
    required this.placeholderUrl,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      title: json['title'],
      description: json['description'],
      mediaUrl: json['mediaUrl'],
      thumbnail: json['thumbnail'],
      hyperlink: json['hyperlink'],
      placeholderUrl: json['placeholderUrl'],
    );
  }
}