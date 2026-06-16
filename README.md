# Instagram Reels Feed (Flutter)

## Overview

This project is a Flutter implementation of a short-form video feed similar to Instagram Reels.

The application displays a vertically scrollable feed of videos, supports automatic playback of the visible reel, pauses off-screen videos, prefetches the next video for smoother navigation, and loads additional content using cursor-based pagination.

The project follows a clean architecture approach with separate Data, Domain, and Presentation layers and uses Bloc for state management.

---

## Features

### Vertical Reels Feed
- Full-screen vertical `PageView`
- Swipe up/down to navigate between reels
- Smooth scrolling experience

### Video Playback
- Auto-play the currently visible reel
- Pause all off-screen reels
- Loop videos continuously
- Full-screen video display using `BoxFit.cover`

### Video Prefetching
- Prefetches the next reel's video controller in the background
- Reduces loading time when the user swipes to the next reel
- Prevents unnecessary duplicate initialization requests

### Cursor-Based Pagination
- Loads additional reels when the user approaches the end of the feed
- Uses the `nextCursor` returned by the API
- Stops requesting data when `hasMore` becomes `false`

### Rate Limit Handling
- Simulates API rate limiting (`429`)
- Automatically retries after the provided retry duration

### Edge Case Support
- Invalid cursor returns the first page
- `viewCount` handled as a string
- Supports `muxPlaybackId` being `null`
- Supports `thumbnailUrl` being `null`
- Handles pagination completion using `hasMore`

---

## Architecture

The project follows a layered architecture:

### Data Layer
Responsible for:
- API contracts
- Mock API implementation
- Response models
- Repository implementation

### Domain Layer
Responsible for:
- Repository abstractions
- Business logic contracts

### Presentation Layer
Responsible for:
- UI screens
- Widgets
- Bloc state management
- Video playback management

---

## State Management

The application uses Flutter Bloc.

### Events
- `LoadFeed`
- `LoadMoreFeed`

### State
- Loading state
- Pagination state
- Error state
- Reel list state

---

## Video Controller Management

Video controllers are managed manually to improve performance.

### Responsibilities
- Create controllers only when needed
- Reuse existing controllers
- Auto-play active reel
- Pause inactive reels
- Prefetch next reel
- Dispose controllers when the page is destroyed

---

## Mock API

The project uses a mock implementation of:

```http
GET /api/v1/feed?limit=20&cursor=<base64>&category_ids=5,6
```

Implemented behaviors:

- Cursor-based pagination
- Invalid cursor fallback
- Simulated 429 rate limiting
- Multiple feed pages
- Mock video URLs
- Pagination completion handling

---

## Tech Stack

- Flutter
- Dart
- Flutter Bloc
- Injectable
- GetIt
- Video Player

---

## Running the Project

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## Project Structure

```text
lib/
│
├── core/
│
├── di/
│
├── features/
│   └── feed/
│       ├── data/
│       │   ├── datasource/
│       │   ├── models/
│       │   └── repository/
│       │
│       ├── domain/
│       │   └── repository/
│       │
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
│
└── main.dart
```
