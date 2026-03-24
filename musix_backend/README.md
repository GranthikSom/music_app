# Musix Backend

A Dart Frog backend for the Musix music streaming app.

## Features

- **Authentication** - JWT-based user registration and login
- **Songs** - CRUD operations with search functionality
- **Playlists** - Create and manage playlists
- **Favorites** - Toggle songs as favorites
- **File Uploads** - Upload audio files and cover images
- **Offline Support** - Designed for manual download caching on Flutter client

## Quick Start

### Prerequisites

- Dart SDK 3.11.0+
- Dart Frog CLI

### Installation

```bash
# Activate Dart Frog CLI (if not installed)
dart pub global activate dart_frog_cli

# Install dependencies
cd musix_backend
dart pub get
```

### Running the Server

```bash
# Development mode with hot reload
~/.pub-cache/bin/dart_frog dev --port 8080

# Or add to PATH and use
export PATH="$PATH:$HOME/.pub-cache/bin"
dart_frog dev --port 8080
```

The server runs at `http://localhost:8080`

## API Endpoints

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register new user |
| POST | `/auth/login` | Login and get JWT token |

#### Register
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123","username":"username"}'
```

Response:
```json
{
  "user": {
    "id": "uuid",
    "username": "username",
    "avatar_url": null,
    "created_at": "2024-01-01T00:00:00.000000"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
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
| POST | `/songs/create` | Yes | Create new song |
| DELETE | `/songs/:id` | Yes | Delete song |

#### Get All Songs
```bash
curl http://localhost:8080/songs
```

#### Create Song (requires auth)
```bash
curl -X POST http://localhost:8080/songs/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "title": "Song Title",
    "artist": "Artist Name",
    "audio_url": "/uploads/audio/user-id/timestamp.mp3",
    "cover_url": "/uploads/covers/user-id/timestamp.jpg"
  }'
```

### Playlists

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/playlists` | No | Get all public playlists |
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

#### Upload Audio
```bash
curl -X POST http://localhost:8080/upload/audio \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@song.mp3"
```

Response:
```json
{"url": "/uploads/audio/user-id/1234567890.mp3"}
```

### Static Files

Uploaded files are served from:
- Audio: `/uploads/audio/:path`
- Covers: `/uploads/covers/:path`

## Project Structure

```
musix_backend/
├── lib/
│   ├── models/          # Data models (User, Song, Playlist, Favorite)
│   ├── services/        # Business logic (AuthService, StorageService)
│   └── repositories/    # Data persistence (DataStore)
├── routes/              # API endpoints
│   ├── auth/           # Authentication routes
│   ├── songs/          # Songs CRUD
│   ├── playlists/      # Playlists CRUD
│   ├── favorites/      # User favorites
│   └── upload/         # File uploads
├── public/             # Static files (uploaded media)
├── data/               # JSON data storage
└── pubspec.yaml
```

## Data Storage

Uses JSON files for persistence:
- `data/users.json` - User accounts
- `data/songs.json` - Song metadata
- `data/playlists.json` - User playlists
- `data/favorites.json` - User favorites

**Note**: For production, replace with a proper database (PostgreSQL, MongoDB, etc.)

## Deployment

### Globe.dev

```bash
# Install globe CLI
dart pub global activate globe

# Deploy
globe deploy
```

### Docker

```dockerfile
FROM dart:3.11.0

WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get
COPY . .
RUN dart compile exe bin/server.dart -o server

CMD ["server"]
```

## Environment Variables

For production, set these:
- `JWT_SECRET` - Secret key for JWT signing
- `DATABASE_URL` - Database connection string (for production DB)

## License

MIT
