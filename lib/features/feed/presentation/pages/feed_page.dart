import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_reel/di/injection.dart';
import 'package:instagram_reel/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:instagram_reel/features/feed/presentation/bloc/feed_event.dart';
import 'package:instagram_reel/features/feed/presentation/bloc/feed_state.dart';
import 'package:instagram_reel/features/feed/presentation/widgets/reel_overlay.dart';
import 'package:instagram_reel/static.dart';
import 'package:video_player/video_player.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeedBloc>()..add(const LoadFeed()),
      child: const FeedView(),
    );
  }
}

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  int currentIndex = 0;

  final Map<int, VideoPlayerController> _controllers = {};
  final Set<int> _initializingIndices = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _evictOldControllers(int currentIndex) {
    const keepWindow = AppConstants.widowSize;

    final toRemove = _controllers.keys
        .where((i) => (i - currentIndex).abs() >= keepWindow)
        .toList();

    for (final i in toRemove) {
      _controllers[i]?.dispose();
      _controllers.remove(i);
      _initializingIndices.remove(i);
    }
  }

  Future<void> _initController(String url, int index) async {
    if (_controllers.containsKey(index)) return;
    if (_initializingIndices.contains(index)) return;

    _initializingIndices.add(index);

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await controller.initialize();
      await controller.setLooping(true);

      _controllers[index] = controller;

      if (index == currentIndex) {
        controller.play();
      }

      if (mounted) setState(() {});

      final state = context.read<FeedBloc>().state;
      _prefetchNext(state.reels, index);
    } catch (e) {
      controller.dispose();
    } finally {
      _initializingIndices.remove(index);
    }
  }

  void _prefetchNext(List reels, int index) {
    final nextIndex = index + 1;

    if (nextIndex >= reels.length) return;
    if (_controllers.containsKey(nextIndex)) return;
    if (_initializingIndices.contains(nextIndex)) return;

    final url = reels[nextIndex].muxPlaybackId;
    if (url == null) return;

    _initializingIndices.add(nextIndex);

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    controller
        .initialize()
        .then((_) async {
          await controller.setLooping(true);
          _controllers[nextIndex] = controller;
          if (mounted) setState(() {});
        })
        .catchError((e) {
          controller.dispose();
        })
        .whenComplete(() {
          _initializingIndices.remove(nextIndex);
        });
  }

  void _playPause(int index) {
    for (final entry in _controllers.entries) {
      if (!entry.value.value.isInitialized) continue;

      if (entry.key == index) {
        if (!entry.value.value.isPlaying) entry.value.play();
      } else {
        if (entry.value.value.isPlaying) entry.value.pause();
      }
    }
  }

  void _handlePagination(FeedState state, int index, BuildContext context) {
    if (index >= state.reels.length - AppConstants.widowSize && state.hasMore) {
      context.read<FeedBloc>().add(const LoadMoreFeed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state.isLoading && state.reels.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.reels.isEmpty) {
            return Center(child: Text(state.error!));
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: state.reels.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
              _evictOldControllers(index);

              _playPause(index);
              _handlePagination(state, index, context);

              // Always prefetch on every page change (no _hasScrolled guard)
              _prefetchNext(state.reels, index);
            },
            itemBuilder: (context, index) {
              final reel = state.reels[index];
              final controller = _controllers[index];

              // Kick off initialization if not yet started
              if (controller == null && reel.muxPlaybackId != null) {
                _initController(reel.muxPlaybackId!, index);
              }

              return Stack(
                children: [
                  if (controller != null && controller.value.isInitialized)
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    )
                  else
                    const ColoredBox(
                      color: Colors.black,
                      child: SizedBox.expand(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),

                  ReelOverlay(reel: reel),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
