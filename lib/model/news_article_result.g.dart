// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticleResult _$NewsArticleResultFromJson(Map<String, dynamic> json) {
  return NewsArticleResult(
    status: json['status'] as String?,
    totalResults: json['totalResults'] as int?,
    articles: (json['articles'] as List<dynamic>)
        .map((e) => Articles.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$NewsArticleResultToJson(NewsArticleResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'totalResults': instance.totalResults,
      'articles': instance.articles,
    };
