import 'package:instagram_reel/features/feed/data/models/feed_response.dart';

abstract class FeedApi {
  Future<FeedResponse> getFeed({
    int limit = 20,
    String? cursor,
    List<int>? categoryIds,
  });
}
