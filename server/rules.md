# AI Development Prompt: NestJS MBTI Chat Backend Architecture

## Context for AI Assistant
You are tasked with designing a production-ready NestJS backend architecture for an MBTI personality-based real-time chat application. Follow senior developer best practices and enterprise patterns.

## System Requirements

### Core Functionality
- **Real-time messaging** with WebSocket support
- **MBTI personality profiling** and matching algorithms
- **AI-powered conversation** suggestions based on personality types
- **User authentication** with JWT and refresh tokens
- **Message persistence** and chat history
- **Personality compatibility** scoring between users

## Architectural Design Requirements

### 1. Domain-Driven Design Structure

```
ORGANIZE modules by business domain:
- Auth Domain (authentication, authorization)
- User Domain (profiles, preferences)
- MBTI Domain (assessments, personality analysis)
- Chat Domain (messaging, rooms, real-time)
- AI Domain (conversation enhancement, suggestions)
- Analytics Domain (user behavior, compatibility metrics)
```

### 2. Technical Stack Requirements

```yaml
Core Technologies:
  - NestJS: v10+
  - TypeScript: v5+
  - Database: PostgreSQL with TypeORM
  - Cache: Redis for sessions and real-time data
  - WebSocket: Socket.io for real-time communication
  - Queue: Bull for background jobs
  - AI: OpenAI API integration
  
Security:
  - JWT with refresh token rotation
  - Rate limiting per endpoint
  - Input sanitization
  - SQL injection prevention
  - XSS protection
```

### 3. Data Models Schema

```typescript
// Core Entities Design
User {
  id: UUID
  email: string (unique)
  username: string (unique)
  passwordHash: string
  mbtiType: MBTI_ENUM
  isVerified: boolean
  lastActive: DateTime
  refreshTokens: RefreshToken[]
  profile: UserProfile
  chatRooms: ChatRoom[]
}

MBTIProfile {
  userId: UUID (FK)
  primaryType: MBTI_TYPE (INTJ, ENFP, etc.)
  cognitiveStack: CognitiveFunction[]
  assessmentHistory: Assessment[]
  compatibilityScores: Compatibility[]
  confidence: number
  lastAssessment: DateTime
}

ChatRoom {
  id: UUID
  type: ENUM (direct, group, mbti_match)
  participants: User[]
  messages: Message[]
  mbtiContext: MBTIContext
  isActive: boolean
  createdAt: DateTime
}

Message {
  id: UUID
  roomId: UUID (FK)
  senderId: UUID (FK)
  content: string (encrypted)
  type: ENUM (text, system, ai_suggestion)
  metadata: JSON
  readBy: UserRead[]
  createdAt: DateTime
}
```


## DOS - Best Practices

### Architecture DOS
✅ **DO** implement Clean Architecture principles
✅ **DO** use dependency injection for all services
✅ **DO** implement repository pattern for data access
✅ **DO** use DTOs for request/response validation
✅ **DO** implement CQRS for complex queries
✅ **DO** use event-driven architecture for real-time features
✅ **DO** implement circuit breaker for external services

### Security DOS
✅ **DO** hash passwords with bcrypt (min 10 rounds)
✅ **DO** implement refresh token rotation
✅ **DO** use parameterized queries
✅ **DO** validate all inputs with class-validator
✅ **DO** implement rate limiting (100 req/min default)
✅ **DO** use helmet for security headers
✅ **DO** encrypt sensitive data in database

### Performance DOS
✅ **DO** implement database indexing strategy
✅ **DO** use Redis for session management
✅ **DO** implement pagination for all list endpoints
✅ **DO** use database connection pooling
✅ **DO** implement lazy loading for relations
✅ **DO** cache MBTI compatibility calculations
✅ **DO** use queue for heavy computations

### Testing DOS
✅ **DO** maintain >80% code coverage
✅ **DO** write unit tests for all services
✅ **DO** implement E2E tests for critical paths
✅ **DO** use test databases for integration tests
✅ **DO** mock external services in tests

## DON'TS - Anti-patterns to Avoid

### Architecture DON'TS
❌ **DON'T** put business logic in controllers
❌ **DON'T** create circular dependencies
❌ **DON'T** bypass the service layer
❌ **DON'T** mix concerns in single module
❌ **DON'T** use synchronous operations for I/O
❌ **DON'T** create God services
❌ **DON'T** ignore SOLID principles

### Security DON'TS
❌ **DON'T** store plain text passwords
❌ **DON'T** expose sensitive data in logs
❌ **DON'T** trust client-side validation
❌ **DON'T** use JWT without expiration
❌ **DON'T** expose internal error details
❌ **DON'T** skip authentication middleware
❌ **DON'T** use weak encryption algorithms

### Database DON'TS
❌ **DON'T** use SELECT * queries
❌ **DON'T** skip database migrations
❌ **DON'T** ignore N+1 query problems
❌ **DON'T** store large files in database
❌ **DON'T** skip transaction management
❌ **DON'T** hardcode connection strings

### Code Quality DON'TS
❌ **DON'T** ignore TypeScript strict mode
❌ **DON'T** use 'any' type unnecessarily
❌ **DON'T** skip error handling
❌ **DON'T** ignore linting rules
❌ **DON'T** commit commented code
❌ **DON'T** skip code reviews

## Implementation Patterns

### 1. Service Layer Pattern
```typescript
// CORRECT: Separation of concerns
@Injectable()
export class MBTIService {
  constructor(
    private readonly repository: MBTIRepository,
    private readonly cacheService: CacheService,
    private readonly eventEmitter: EventEmitter2
  ) {}
  
  async calculateCompatibility(user1: string, user2: string): Promise<number> {
    // Business logic here
  }
}
```

### 2. Repository Pattern
```typescript
// CORRECT: Data access abstraction
@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>
  ) {}
  
  async findByMBTI(type: MBTIType): Promise<User[]> {
    return this.userRepo.find({ where: { mbtiType: type }});
  }
}
```

### 3. WebSocket Gateway Pattern
```typescript
// CORRECT: Real-time communication
@WebSocketGateway()
export class ChatGateway {
  @SubscribeMessage('message')
  async handleMessage(
    @MessageBody() data: SendMessageDto,
    @ConnectedSocket() client: Socket
  ) {
    // Validate, process, broadcast
  }
}
```

## Critical Success Factors

### 1. Scalability Considerations
- Implement horizontal scaling strategy
- Use microservices for AI processing
- Implement database sharding for user data
- Use CDN for static assets
- Implement message queue for async operations

### 2. Monitoring Requirements
- Application Performance Monitoring (APM)
- Error tracking with Sentry
- Centralized logging with ELK stack
- Health check endpoints
- Real-time metrics dashboard

### 3. MBTI-Specific Requirements
- Validate MBTI types strictly (16 types only)
- Implement cognitive function stacks
- Store assessment history for accuracy
- Calculate compatibility using validated algorithms
- Provide personality insights via AI

## Environment Configuration

```typescript
// CORRECT: Environment-based configuration
export default () => ({
  database: {
    type: 'postgres',
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT, 10),
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: process.env.NODE_ENV === 'production'
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: '15m',
    refreshExpiresIn: '7d'
  },
  redis: {
    host: process.env.REDIS_HOST,
    port: parseInt(process.env.REDIS_PORT, 10)
  },
  openai: {
    apiKey: process.env.OPENAI_API_KEY,
    model: 'gpt-4-turbo-preview'
  }
});
```


don't change other folder structure and codes, only change in the server folder

don't change my style and code and function



## Final Checklist for AI Implementation

- [ ] All modules follow single responsibility principle
- [ ] Authentication implemented with guards
- [ ] WebSocket authentication implemented
- [ ] Database migrations created
- [ ] Redis caching implemented
- [ ] Queue system for background jobs
- [ ] Rate limiting on all endpoints
- [ ] Input validation on all DTOs
- [ ] Error handling with custom exceptions
- [ ] Logging strategy implemented
- [ ] API documentation with Swagger
- [ ] Unit tests for services
- [ ] Integration tests for controllers
- [ ] E2E tests for critical flows
- [ ] Docker configuration ready
- [ ] CI/CD pipeline configured
- [ ] Environment variables documented
- [ ] Security headers configured
- [ ] CORS properly configured
- [ ] Health check endpoints ready