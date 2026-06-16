import 'package:instagram_reel/features/feed/data/models/reel_item.dart';

class Reel {
  final int id;
  final String? muxPlaybackId;
  final String? thumbnailUrl;
  final String title;
  final String status;
  final String viewCount;
  final List<ReelItem> reelItems;

  const Reel({
    required this.id,
    required this.muxPlaybackId,
    required this.thumbnailUrl,
    required this.title,
    required this.status,
    required this.viewCount,
    required this.reelItems,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'],
      muxPlaybackId: json['muxPlaybackId'],
      thumbnailUrl: json['thumbnailUrl'],
      title: json['title'],
      status: json['status'],
      viewCount: json['viewCount'],
      reelItems: (json['reelItems'] as List)
          .map((e) => ReelItem.fromJson(e))
          .toList(),
    );
  }
}
