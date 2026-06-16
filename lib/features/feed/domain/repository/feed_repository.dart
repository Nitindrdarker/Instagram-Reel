import '../../data/models/feed_response.dart';

abstract class FeedRepository {
  Future<FeedResponse> getFeed({String? cursor});
}
