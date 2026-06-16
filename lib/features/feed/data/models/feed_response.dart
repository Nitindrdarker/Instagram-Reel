import 'pagination.dart';
import 'reel.dart';

class FeedResponse {
  final List<Reel> data;
  final Pagination pagination;

  const FeedResponse({required this.data, required this.pagination});

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      data: (json['data'] as List).map((e) => Reel.fromJson(e)).toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}
