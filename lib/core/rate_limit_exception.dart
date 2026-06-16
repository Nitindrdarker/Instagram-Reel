class RateLimitException implements Exception {
  final int retryAfterSeconds;

  RateLimitException({required this.retryAfterSeconds});
}
