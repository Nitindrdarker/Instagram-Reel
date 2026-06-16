# AI Interaction Log (Example Format)


## I need to build a Flutter application that mimics Instagram Reels.

Requirements:

* Vertical full-screen feed
* Autoplay visible video
* Pause off-screen videos
* Pagination support
* Bloc state management
* Clean Architecture
* Controller prefetching
* Retry handling for rate-limited API responses
* Product overlay with Add to Cart action

---




## How should I structure the project?

**AI:**

Use a feature-first Clean Architecture approach.

Suggested structure:

features/
feed/
data/
datasource/
models/
repository/
domain/
repository/
presentation/
bloc/
pages/
widgets/

core/
di/



Accepted. Used feature-first organization with data, domain, and presentation layers.

---





## Given the following API response JSON, generate Dart models for the feed response.

**AI:**

Generated model classes for:

* FeedResponse
* Pagination
* Reel
* ReelItem

along with `fromJson()` parsing methods.



I used the generated models as a starting point and verified them against the API contract. The generated structure matched the response shape, which helped speed up development and reduce manual boilerplate code.

This allowed me to focus more on feed behavior, video playback, pagination, and state management rather than manually creating model classes from the JSON response.




## The API returns nextCursor and hasMore. How should pagination work?

**AI:**

Store:

* nextCursor
* hasMore

When the user approaches the end of the feed:

* Dispatch LoadMoreFeed
* Append new items to the existing list
* Update pagination metadata



Implemented pagination in FeedBloc using nextCursor and hasMore.

---

## The API can return a rate-limit error with a retry duration.

**AI:**

Catch the exception separately.

Example flow:

1. Receive RateLimitException
2. Wait retryAfterSeconds
3. Retry automatically



Implemented retry logic inside LoadMoreFeed handler.

---



## How should video playback be handled in a PageView?

**AI:**

Only the currently visible page should play.

When page changes:

* Pause all other controllers
* Play active controller



Implemented _playPause() to ensure only one video plays at a time.

---



## I am worried about memory usage if every video controller stays alive.

**AI:**

Maintain a sliding window.

Example:

Current Index = 10

Keep:

* 8
* 9
* 10
* 11
* 12

Dispose everything else.



Implemented _evictOldControllers() using a configurable window size.

---


## Videos take time to initialize.

**AI:**

Prefetch the next video while the current video is playing.

Flow:

Current = 5

Initialize:

* Video 5
* Video 6

This reduces waiting time when the user scrolls.



Implemented _prefetchNext() after controller initialization and page changes.

---



## How should loading states be represented?

**AI:**

Use separate flags:

* isLoading
* isLoadingMore

This prevents pagination loading from blocking the entire UI.



Implemented both loading states in FeedState.

---


## The assignment requires optimistic UI updates.

**AI:**

Recommended flow:

1. User taps Add To Cart
2. Immediately update UI
3. Call backend
4. If failure occurs, rollback UI state



Implemented optimistic update with rollback using a simulated success/failure response.

---


## What should happen if video initialization fails?

**AI:**

Dispose failed controller and continue rendering the feed without crashing.



Implemented try/catch around controller initialization and disposal logic.

---

## Final Notes

AI assistance was used for:

* Architecture discussions
* Bloc design
* Pagination strategy
* Video controller lifecycle
* Prefetching strategy
* Error handling ideas

Final implementation, debugging, testing, optimization, and code decisions were completed by the developer.
