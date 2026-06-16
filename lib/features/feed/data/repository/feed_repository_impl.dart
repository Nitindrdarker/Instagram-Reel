import 'package:injectable/injectable.dart';
import 'package:instagram_reel/features/feed/data/datasource/feed_api.dart';
import 'package:instagram_reel/features/feed/data/models/feed_response.dart';
import 'package:instagram_reel/features/feed/domain/repository/feed_repository.dart';

@LazySingleton(as: FeedRepository)
class FeedRepositoryImpl implements FeedRepository {
  final FeedApi api;

  FeedRepositoryImpl(this.api);

  @override
  Future<FeedResponse> getFeed({String? cursor}) {
    return api.getFeed(cursor: cursor);
  }
}
