class Pagination {
  final String? nextCursor;
  final bool hasMore;
  final int totalInView;

  const Pagination({
    required this.nextCursor,
    required this.hasMore,
    required this.totalInView,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      nextCursor: json['nextCursor'],
      hasMore: json['hasMore'],
      totalInView: json['totalInView'],
    );
  }
}
