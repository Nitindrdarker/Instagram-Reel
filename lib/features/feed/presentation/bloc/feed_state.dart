import 'package:instagram_reel/features/feed/data/models/reel.dart';

class FeedState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  final String? nextCursor;
  final String? error;

  final List<Reel> reels;

  const FeedState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.reels,
    this.nextCursor,
    this.error,
  });

  factory FeedState.initial() {
    return const FeedState(
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      reels: [],
      nextCursor: null,
      error: null,
    );
  }

  FeedState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? nextCursor,
    String? error,
    List<Reel>? reels,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      error: error,
      reels: reels ?? this.reels,
    );
  }
}
