import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:instagram_reel/core/rate_limit_exception.dart';
import 'package:instagram_reel/features/feed/domain/repository/feed_repository.dart';

import 'feed_event.dart';
import 'feed_state.dart';

@injectable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository repository;

  FeedBloc(this.repository) : super(FeedState.initial()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMoreFeed>(_onLoadMoreFeed);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await repository.getFeed();

      emit(
        state.copyWith(
          isLoading: false,
          reels: response.data,
          nextCursor: response.pagination.nextCursor,
          hasMore: response.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMoreFeed(
    LoadMoreFeed event,
    Emitter<FeedState> emit,
  ) async {
    if (state.isLoadingMore) {
      return;
    }

    if (!state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await repository.getFeed(cursor: state.nextCursor);
      final updated = [...state.reels, ...response.data];

      emit(
        state.copyWith(
          isLoadingMore: false,
          reels: updated,
          nextCursor: response.pagination.nextCursor,
          hasMore: response.pagination.hasMore,
        ),
      );
    } on RateLimitException catch (e) {
      emit(state.copyWith(isLoadingMore: false));

      await Future.delayed(Duration(seconds: e.retryAfterSeconds));

      add(const LoadMoreFeed());
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }
}
