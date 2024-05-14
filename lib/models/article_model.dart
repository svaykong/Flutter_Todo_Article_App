import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

@immutable
class ListArticles extends Equatable {
  const ListArticles({required this.articles});

  final List<Article> articles;

  factory ListArticles.fromJson(Map<String, dynamic> json) => ListArticles(articles: List.from(json['data']).map((element) => Article.fromJson(element)).toList());

  @override
  List<Object?> get props => [articles];
}

@immutable
class Article extends Equatable {
  const Article({
    required this.createdAt,
    required this.id,
    required this.title,
    required this.description,
  });

  final String createdAt;
  final String description;
  final int id;
  final String title;

  factory Article.fromJson(Map<String, dynamic> json) => Article(createdAt: json['created_at'], id: json['id'], title: json['title'], description: json['description']);

  @override
  List<Object?> get props => [createdAt, id, title, description];

  static Map<String, String> toMap(String title, String desc) {
    return {
      'title': title,
      'description': desc,
    };
  }
}
