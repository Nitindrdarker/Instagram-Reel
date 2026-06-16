import 'package:injectable/injectable.dart';
import 'package:instagram_reel/core/rate_limit_exception.dart';
import 'package:instagram_reel/features/feed/data/datasource/feed_api.dart';
import 'package:instagram_reel/features/feed/data/models/feed_response.dart';

bool _rateLimitTriggered = false;

@LazySingleton(as: FeedApi)
class MockFeedApi implements FeedApi {
  @override
  Future<FeedResponse> getFeed({
    int limit = 20,
    String? cursor,
    List<int>? categoryIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_rateLimitTriggered && cursor == 'cursor_page_2') {
      _rateLimitTriggered = true;

      throw RateLimitException(retryAfterSeconds: 2);
    }

    if (cursor == null) {
      return FeedResponse.fromJson(page1);
    }

    if (cursor == 'cursor_page_2') {
      return FeedResponse.fromJson(page2);
    }

    // Invalid cursor → return first page
    return FeedResponse.fromJson(page1);
  }
}

final page1 = {
  "data": [
    {
      "id": 1,
      "muxPlaybackId": "https://test-streams.mux.dev/pts_shift/master.m3u8",
      "thumbnailUrl": null,
      "title": "Music Player",
      "status": "LIVE",
      "viewCount": "1250",
      "reelItems": [
        {"itemId": 101, "displayOrder": 1, "price": 499},
      ],
    },
    {
      "id": 2,
      "muxPlaybackId":
          "https://test-streams.mux.dev/dai-discontinuity-deltatre/manifest.m3u8",
      "thumbnailUrl": null,
      "title": "Rugby Ball",
      "status": "LIVE",
      "viewCount": "8900",
      "reelItems": [
        {"itemId": 102, "displayOrder": 1, "price": 2499},
      ],
    },
    {
      "id": 3,
      "muxPlaybackId": "https://test-streams.mux.dev/test_001/stream.m3u8",
      "thumbnailUrl": null,
      "title": "Katana",
      "status": "LIVE",
      "viewCount": "500",
      "reelItems": [
        {"itemId": 103, "displayOrder": 1, "price": 9999},
      ],
    },
    {
      "id": 4,
      "muxPlaybackId":
          "https://test-streams.mux.dev/x36xhzz/url_6/193039199_mp4_h264_aac_hq_7.m3u8",
      "thumbnailUrl": null,
      "title": "Bunny",
      "status": "LIVE",
      "viewCount": "17000",
      "reelItems": [
        {"itemId": 104, "displayOrder": 1, "price": 1499},
      ],
    },
    {
      "id": 5,
      "muxPlaybackId": null,
      "thumbnailUrl": null,
      "title": "Books",
      "status": "PROCESSING",
      "viewCount": "17000",
      "reelItems": [
        {"itemId": 104, "displayOrder": 1, "price": 1499},
      ],
    },
  ],
  "pagination": {
    "nextCursor": "cursor_page_2",
    "hasMore": true,
    "totalInView": 5,
  },
};

final page2 = {
  "data": [
    {
      "id": 6,
      "muxPlaybackId": "https://test-streams.mux.dev/test_001/stream.m3u8",
      "thumbnailUrl": null,
      "title": "Katana",
      "status": "LIVE",
      "viewCount": "500",
      "reelItems": [
        {"itemId": 103, "displayOrder": 1, "price": 9999},
      ],
    },
    {
      "id": 7,
      "muxPlaybackId":
          "https://test-streams.mux.dev/x36xhzz/url_6/193039199_mp4_h264_aac_hq_7.m3u8",
      "thumbnailUrl": null,
      "title": "Bunny",
      "status": "LIVE",
      "viewCount": "17000",
      "reelItems": [
        {"itemId": 104, "displayOrder": 1, "price": 1499},
      ],
    },
  ],
  "pagination": {"nextCursor": null, "hasMore": false, "totalInView": 2},
};
