# MUSIX

A music streaming application built with Flutter and Dart Frog.

## Features

### Mobile App (Flutter)
- Play/pause songs with audio controls
- Skip to next/previous track
- Browse songs and albums
- Favorite songs
- Playlist management
- Dark/Light theme support
- Offline playback with manual download caching
- Works on Android, iOS, and Web

### Backend API (Dart Frog)
- JWT-based authentication
- Songs CRUD with search
- Playlists CRUD
- Favorites management
- File uploads (audio & cover images)
- JSON file persistence

---

## Project Structure

```
musix/
├── musix/                    # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart        # App entry point
│   │   ├── models/          # Data models
│   │   ├── pages/           # Screen widgets
│   │   ├── services/         # API services
│   │   └── themes/          # Theme configuration
│   └── pubspec.yaml
│
└── musix_backend/           # Dart Frog API backend
    ├── lib/
    │   ├── models/          # User, Song, Playlist, Favorite
    │   ├── services/        # AuthService, StorageService
    │   └── repositories/    # DataStore (JSON persistence)
    ├── routes/              # API endpoints
    ├── public/              # Static files (uploaded media)
    ├── data/                # JSON data storage
    └── pubspec.yaml
```

---

## Quick Start

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.11+
- Dart Frog CLI

### Backend Setup

```bash
cd musix_backend

# Activate Dart Frog CLI (if not installed)
dart pub global activate dart_frog_cli

# Install dependencies
dart pub get

# Start development server
~/.pub-cache/bin/dart_frog dev --port 8080
```

The backend will run at `http://localhost:8080`

### Flutter App Setup

```bash
cd musix

# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Or build for production
flutter build apk
flutter build ios
flutter build web
```

---

## Backend API

### Authentication

#### Register
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123","username":"username"}'
```

#### Login
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

### Songs

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/songs` | No | Get all songs |
| GET | `/songs/search?q=` | No | Search songs |
| GET | `/songs/:id` | No | Get song by ID |
| POST | `/songs/create` | Yes | Create song |
| DELETE | `/songs/:id` | Yes | Delete song |

### Playlists

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/playlists` | No | Get all playlists |
| POST | `/playlists` | Yes | Create playlist |
| GET | `/playlists/:id` | No | Get playlist |
| PUT | `/playlists/:id` | Yes | Update playlist |
| DELETE | `/playlists/:id` | Yes | Delete playlist |
| POST | `/playlists/:id/songs` | Yes | Add song to playlist |

### Favorites

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/favorites` | Yes | Get user favorites |
| POST | `/favorites/:songId` | Yes | Toggle favorite |

### File Uploads

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/upload/audio` | Yes | Upload audio file |
| POST | `/upload/cover` | Yes | Upload cover image |

---

## Configuration

### Backend Environment Variables

For production, set these environment variables:
- `JWT_SECRET` - Secret key for JWT signing
- `DATABASE_URL` - Database connection (for production DB)

### Flutter App

Update the API base URL in your services:
```dart
static const String baseUrl = 'http://localhost:8080';
```

---

## Architecture

### Flutter App
- **Provider** for state management
- **Model-View-Service** architecture
- **Offline support** via manual download caching

### Backend
- **Dart Frog** - Minimal backend framework
- **JWT** for authentication
- **bcrypt** for password hashing
- **JSON files** for data persistence (MVP)

---

## Deployment

### Backend - Globe.dev

```bash
cd musix_backend
dart pub global activate globe
globe deploy
```

### Backend - Docker

```dockerfile
FROM dart:3.11.0
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get
COPY . .
RUN dart compile exe bin/server.dart -o server
CMD ["server"]
```

### Flutter App

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web
```

---

## Screenshots

[Add screenshots here]

---

## Roadmap

- [x] Basic music playback
- [x] User authentication
- [x] Songs CRUD
- [x] Playlists management
- [x] Favorites system
- [x] File uploads
- [ ] Admin dashboard
- [ ] Artist profiles
- [ ] Social features
- [ ] Search filters
- [ ] Music recommendations

---

## License

MIT
