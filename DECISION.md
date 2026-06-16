## What you did with PROCESSING / null-playback reels, and why

Reels with a null muxPlaybackId are treated as non-playable content. During feed rendering, a video controller is only initialized when a valid playback URL exists. If the playback URL is null, no controller is created and the UI falls back to the loading/placeholder state.


## Your prefetch strategy: how many videos ahead and behind you keep, and what determines that

The implementation prefetches one video ahead of the currently initialized video. After a controller is successfully initialized, _prefetchNext() starts initializing the next reel's controller in the background.

To control memory usage, controllers are managed using a sliding window. Controllers that fall outside the configured window (AppConstants.widowSize) are disposed through _evictOldControllers(). The window size determines how many nearby videos remain in memory around the current position.


## One place AI produced something incorrect during your build, and how you caught it

One AI suggestion was to initialize a video controller when a reel became visible and dispose it as soon as the user scrolled away from that reel. While this approach worked functionally, it would have caused controllers to be repeatedly created and destroyed during normal scrolling.

I caught this issue while implementing controller caching and prefetching. I realized that if controllers were disposed immediately when a reel left the screen, scrolling back to a recently viewed reel would require the video to be initialized again, causing unnecessary network requests, additional initialization delays, and a poorer user experience.

To address this, I changed the strategy to keep controllers within a configurable sliding window around the current reel and only dispose controllers that are sufficiently far away. This allowed recently viewed videos to be reused instantly while still keeping memory usage under control.


## One thing you deliberately left out to meet the deadline

I deliberately left out persistent thumbnail/error states for reels that are still processing or whose video initialization fails.

For the assignment goals, the priority was delivering a smooth scrolling feed, autoplay behavior, pagination, retry handling, optimistic cart updates, and proper controller management. A production-ready implementation would likely display custom thumbnails, processing indicators, and richer fallback UI for non-playable content, but these were deferred to keep the scope manageable within the deadline.