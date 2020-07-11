import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hover_wide_wallpaper/res/strings.dart';
import 'package:http/http.dart' as http;

/*
Future<List<Posts>> fetchPosts(http.Client client) async {
  final response = await client.get(
      '${AppStrings.url}/r/${AppStrings.subreddit}/${AppStrings.sort}.json');

  return compute(parsePosts, response.body);
}
*/
String currentPage;
bool notfst = false;
List<Posts> currentPosts = List<Posts>();

Future fetchPosts(http.Client client) async {
  http.Response response;
  if (notfst == false) {
    await client
        .get(
            '${AppStrings.url}/r/${AppStrings.subreddit}/${AppStrings.sort}.json')
        .then((value) async {
      response = value;
      currentPosts.addAll(await compute(parsePosts, response.body));
    });
    notfst = true;
  } else {
    await client
        .get(
            '${AppStrings.url}/r/${AppStrings.subreddit}/${AppStrings.sort}.json?after=${currentPosts.last.currn}')
        .then((value) async {
      response = value;
      currentPosts.addAll(await compute(parsePosts, response.body));
    });
  }
  return response;
}

List<Posts> parsePosts(String responseBody) {
  final parsed = json
      .decode(responseBody)['data']['children']
      .cast<Map<String, dynamic>>();
  currentPage = json.decode(responseBody)['data']['after'];
  return parsed.map<Posts>((json) => Posts.fromJson(json['data'])).toList();
}

class Posts {
  final String title;
  final String permalink;
  final String url;
  final String score;
  final String currn;
  final String thumbnail;

  Posts(
      {this.title,
      this.permalink,
      this.score,
      this.url,
      this.currn,
      this.thumbnail});

  factory Posts.fromJson(Map<String, dynamic> json) {
    var _thumbnail = 'https://mp3-youtube.ch/images/no-thumbnail.png';
    try {
      _thumbnail = json['thumbnail'];
      //_thumbnail = json['preview']['images'][0]['resolutions'][2]['url'];
    } catch (e) {}

    return Posts(
      title: json['title'],
      permalink: json['permalink'],
      score: json['score'].toString(),
      url: json['url'],
      currn: currentPage,
      thumbnail: _thumbnail,
    );
  }
}
