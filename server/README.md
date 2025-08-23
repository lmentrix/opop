# MBTI Chat Backend

A production-ready NestJS backend for an MBTI personality-based real-time chat application.

## Features

- 🔐 **JWT Authentication** with refresh token rotation
- 👥 **User Management** with MBTI personality profiling
- 💬 **Real-time Chat** with WebSocket support
- 🤖 **AI Integration** for conversation suggestions
- 📊 **Analytics** for user behavior and compatibility metrics
- 🚀 **Clean Architecture** with Domain-Driven Design
- 📚 **API Documentation** with Swagger
- 🔒 **Security** with rate limiting, CORS, and input validation
- ⚡ **Performance** with Redis caching and database optimization

## Tech Stack

- **Framework**: NestJS v11
- **Database**: PostgreSQL with TypeORM
- **Cache**: Redis
- **WebSocket**: Socket.io
- **Queue**: Bull
- **AI**: OpenAI API
- **Authentication**: JWT with Passport
- **Documentation**: Swagger/OpenAPI
- **Language**: TypeScript

## Project Structure

```
src/
├── auth/                 # Authentication module
│   ├── controllers/
│   ├── services/
│   ├── strategies/
│   ├── guards/
│   └── dto/
├── user/                 # User management module
│   ├── entities/
│   ├── controllers/
│   ├── services/
│   └── dto/
├── mbti/                 # MBTI assessment module
│   ├── entities/
│   ├── controllers/
│   ├── services/
│   └── dto/
├── chat/                 # Real-time chat module
│   ├── entities/
│   ├── controllers/
│   ├── services/
│   ├── gateways/
│   └── dto/
├── ai/                   # AI integration module
├── analytics/            # Analytics module
├── common/               # Shared utilities
│   ├── decorators/
│   ├── dto/
│   ├── entities/
│   ├── enums/
│   ├── exceptions/
│   ├── filters/
│   ├── guards/
│   ├── interceptors/
│   ├── interfaces/
│   ├── pipes/
│   └── utils/
├── config/               # Configuration files
├── migrations/           # Database migrations
└── main.ts              # Application entry point
```

## Prerequisites

Before running the application, ensure you have:

- Node.js (v18 or higher)
- PostgreSQL (v13 or higher)
- Redis (v6 or higher)
- npm or yarn

## Installation

1. **Clone the repository** (if from git):
   ```bash
   git clone <repository-url>
   cd server
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Set up environment variables**:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` file with your configurations:
   ```env
   # Database
   DB_HOST=localhost
   DB_PORT=5432
   DB_USERNAME=postgres
   DB_PASSWORD=your_password
   DB_NAME=mbti_chat_db
   
   # Redis
   REDIS_HOST=localhost
   REDIS_PORT=6379
   
   # JWT
   JWT_SECRET=your-super-secret-jwt-key
   JWT_REFRESH_SECRET=your-refresh-secret-key
   
   # OpenAI (optional)
   OPENAI_API_KEY=your-openai-api-key
   ```

4. **Set up the database**:
   ```bash
   # Create database
   createdb mbti_chat_db
   
   # Run migrations (when available)
   npm run migration:run
   ```

5. **Start Redis server**:
   ```bash
   redis-server
   ```

## Development

### Running the application

```bash
# Development mode with hot reload
npm run start:dev

# Debug mode
npm run start:debug

# Production mode
npm run start:prod
```

The server will start on `http://localhost:3000`

### API Documentation

Once the server is running, access the Swagger documentation at:
- **Swagger UI**: http://localhost:3000/api/docs

### Database Operations

```bash
# Generate migration
npm run migration:generate -- src/migrations/MigrationName

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert
```

### Testing

```bash
# Unit tests
npm run test

# Integration tests
npm run test:e2e

# Test coverage
npm run test:cov
```

### Code Quality

```bash
# Lint code
npm run lint

# Format code
npm run format

# Build for production
npm run build
```

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - User logout
- `GET /api/v1/auth/profile` - Get current user profile
- `POST /api/v1/auth/change-password` - Change password

### Users
- `GET /api/v1/users` - Get users (placeholder)

### MBTI
- `GET /api/v1/mbti` - MBTI operations (placeholder)

### Chat
- `GET /api/v1/chat/rooms` - Get chat rooms (placeholder)

### AI
- `POST /api/v1/ai/suggestions` - Get AI suggestions (placeholder)

### Analytics
- `GET /api/v1/analytics` - Get analytics (placeholder)

## WebSocket Events

### Chat Events
- `message` - Send/receive messages
- `join-room` - Join chat room
- `leave-room` - Leave chat room

## Database Schema

### Core Entities

#### Users
- Basic user information
- Authentication data
- MBTI type assignment
- Status and role management

#### User Profiles
- Extended user information
- Achievements
- Preferences and settings

#### MBTI Profiles
- Personality type data
- Assessment history
- Compatibility scores

#### Chat System
- Chat rooms (direct, group, MBTI-matched)
- Messages with encryption support
- Participant management
- Read receipts

## Security Features

- **JWT Authentication** with access/refresh token rotation
- **Rate Limiting** to prevent abuse
- **Input Validation** with class-validator
- **CORS** configuration
- **Helmet** for security headers
- **Password Hashing** with bcrypt
- **SQL Injection Protection** via TypeORM

## Performance Optimization

- **Database Connection Pooling**
- **Redis Caching** for sessions and frequently accessed data
- **Lazy Loading** for entity relations
- **Pagination** for list endpoints
- **Database Indexing** strategy

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | Database host | `localhost` |
| `DB_PORT` | Database port | `5432` |
| `DB_USERNAME` | Database username | `postgres` |
| `DB_PASSWORD` | Database password | `password` |
| `DB_NAME` | Database name | `mbti_chat_db` |
| `REDIS_HOST` | Redis host | `localhost` |
| `REDIS_PORT` | Redis port | `6379` |
| `JWT_SECRET` | JWT secret key | Required |
| `JWT_REFRESH_SECRET` | JWT refresh secret | Required |
| `OPENAI_API_KEY` | OpenAI API key | Optional |
| `PORT` | Server port | `3000` |
| `NODE_ENV` | Environment | `development` |

## Contributing

1. Follow the existing code style and architecture patterns
2. Write unit tests for new features
3. Update documentation for API changes
4. Use conventional commit messages
5. Ensure all linting and tests pass

## Deployment

### Docker (Recommended)

```bash
# Build image
docker build -t mbti-chat-backend .

# Run with docker-compose
docker-compose up -d
```

### Manual Deployment

1. Build the application:
   ```bash
   npm run build
   ```

2. Set production environment variables

3. Run migrations:
   ```bash
   npm run migration:run
   ```

4. Start the application:
   ```bash
   npm run start:prod
   ```

## Troubleshooting

### Common Issues

1. **Database connection errors**:
   - Verify PostgreSQL is running
   - Check connection credentials in `.env`
   - Ensure database exists

2. **Redis connection errors**:
   - Verify Redis server is running
   - Check Redis configuration

3. **Port already in use**:
   - Change `PORT` in `.env` file
   - Kill process using the port: `lsof -ti:3000 | xargs kill -9`

### Logs

Application logs are available in the console output. For production, consider implementing structured logging with tools like Winston or Pino.

## License

This project is licensed under the ISC License.

## Support

For support and questions, please refer to the project documentation or create an issue in the repository.