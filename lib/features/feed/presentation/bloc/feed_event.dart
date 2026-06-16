abstract class FeedEvent {
  const FeedEvent();
}

class LoadFeed extends FeedEvent {
  const LoadFeed();
}

class LoadMoreFeed extends FeedEvent {
  const LoadMoreFeed();
}
