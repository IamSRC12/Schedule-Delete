# ScheduleDelete

## Overview

ScheduleDelete is a sophisticated task and appointment management system designed to help users efficiently manage their schedules, tasks, and deadlines. Built with modern web technologies, ScheduleDelete provides a comprehensive solution for personal and professional schedule management with advanced features like calendar integration, task prioritization, and deadline tracking.

## Key Features

- **Calendar Integration**: Seamless integration with Google Calendar, Outlook, and other calendar services
- **Task Management**: Create, organize, and prioritize tasks with due dates and dependencies
- **Schedule Management**: Manage appointments, meetings, and events with drag-and-drop functionality
- **Deadline Tracking**: Automatic deadline reminders and notifications
- **Collaboration**: Share schedules and tasks with team members
- **Reporting**: Generate reports and analytics on productivity and time management
- **Mobile Access**: Access your schedule from any device with mobile-responsive design
- **Automation**: Automate recurring events and task reminders

## Technology Stack

| Layer | Technology |
|-------|------------|
| Frontend | React, TypeScript, Tailwind CSS, Day.js |
| Backend | Node.js, Express, GraphQL |
| Database | PostgreSQL, Redis |
| Authentication | JWT, OAuth 2.0 |
| Calendar Integration | Google Calendar API, Outlook API |
| Build Tools | Vite, ESBuild |
| Deployment | Docker, Kubernetes |

## Project Structure

```
ScheduleDelete/
├── client/               # Frontend application
│   ├── src/             # Source code
│   │   ├── components/  # React components
│   │   ├── features/    # Application features
│   │   ├── hooks/      # Custom hooks
│   │   ├── services/    # API services
│   │   ├── stores/      # State management
│   │   └── utils/       # Utility functions
│   ├── public/          # Static assets
│   └── tests/           # Test files
├── server/               # Backend application
│   ├── src/             # Source code
│   │   ├── api/          # API routes
│   │   ├── models/       # Database models
│   │   ├── services/     # Business logic
│   │   ├── utils/        # Utility functions
│   │   └── config/       # Configuration
│   └── tests/           # Test files
├── docs/                 # Documentation
├── scripts/              # Deployment scripts
├── docker/              # Docker configuration
└── README.md             # This file
```

## Installation

### System Requirements

- Node.js 18+
- PostgreSQL 14+
- Redis 6+
- npm or pnpm

### Installation Steps

#### Clone Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/scheduledelete.git
# Navigate to the project directory
cd scheduledelete
```

#### Install Dependencies

```bash
# Install frontend dependencies
cd client
npm install
# or
pnpm install

# Navigate to server directory
cd ../server

# Install backend dependencies
npm install
# or
pnpm install
```

#### Configure Environment

Create a `.env` file in the server directory:

```env
# Database Configuration
DATABASE_URL=postgresql://username:password@localhost:5432/scheduledelete
REDIS_URL=redis://localhost:6379

# JWT Secret
JWT_SECRET=your-secret-key-here

# Server Configuration
PORT=3000
NODE_ENV=development

# Google Calendar API
GOOGLE_CALENDAR_CLIENT_ID=your-client-id
GOOGLE_CALENDAR_CLIENT_SECRET=your-client-secret
GOOGLE_CALENDAR_REDIRECT_URI=http://localhost:3000/api/auth/google/callback

# CORS Origin
CORS_ORIGIN=http://localhost:3000
```

#### Run Database

```bash
# Create database and tables
# Use your preferred PostgreSQL client
# Run SQL scripts from server/scripts/
```

#### Run Redis

```bash
# Start Redis server
redis-server
```

#### Start Application

```bash
# Start backend server
cd server
npm run dev

# Start frontend application
cd client
npm run dev

# Open browser to http://localhost:3000
```

## Usage

### Basic Usage

1. **Login/Register**
   - Click "Login" button
   - Enter credentials or use OAuth
   - Access your dashboard

2. **View Calendar**
   - Navigate between months using arrow buttons
   - Use drag-and-drop to move events
   - Click on time slots to create new events

3. **Manage Tasks**
   - Click "Tasks" tab
   - Create new tasks with due dates
   - Set priorities and categories
   - Assign tasks to team members

4. **View Schedule**
   - Click "Schedule" tab
   - See upcoming appointments
   - Manage meeting invitations
   - Set up recurring events

### Advanced Features

- **Calendar Integration**: Connect multiple calendar services
- **Task Dependencies**: Set up task dependencies and workflows
- **Team Collaboration**: Share schedules and tasks with team members
- **Analytics**: View productivity reports and analytics
- **Automation**: Set up automated reminders and recurring events
- **Mobile Access**: Access from mobile devices with responsive design
- **Export/Import**: Export data to CSV or import from other applications

## Configuration

### Environment Configuration

Create a `.env` file in the server directory with the following options:

```env
# Database Configuration
DATABASE_URL=postgresql://username:password@localhost:5432/scheduledelete
REDIS_URL=redis://localhost:6379
DATABASE_POOL_SIZE=20
DATABASE_MAX_IDLE_TIME=3000

# JWT Configuration
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=86400

# Server Configuration
PORT=3000
NODE_ENV=development
HOST=0.0.0.0
CORS_ORIGIN=http://localhost:3000
TRUST_PROXY_COUNT=0

# Google Calendar API
GOOGLE_CALENDAR_CLIENT_ID=your-client-id
GOOGLE_CALENDAR_CLIENT_SECRET=your-client-secret
GOOGLE_CALENDAR_REDIRECT_URI=http://localhost:3000/api/auth/google/callback
GOOGLE_CALENDAR_SCOPES=https://www.googleapis.com/auth/calendar.readonly

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Logging
LOG_LEVEL=info
LOG_FILE=logs/server.log
```

### Application Configuration

The application supports various configuration options:

- **Theme Settings**: Light/dark mode preferences
- **Notification Settings**: Customize notification preferences
- **Calendar Settings**: Default calendar views and time zones
- **Task Settings**: Default task categories and priorities
- **Integration Settings**: Configure third-party integrations

## Build Targets

### Development

| Target | Command | Description |
|--------|---------|-------------|
| `npm run dev` | Start development server | Hot reload, linting, type checking |
| `npm run build` | Build for production | Minified, optimized bundles |
| `npm run preview` | Preview production build | Local preview server |

### Production

| Platform | Command | Description |
|----------|---------|-------------|
| Docker | `docker-compose up --build` | Full stack deployment |
| Kubernetes | `kubectl apply -f k8s/` | Kubernetes deployment |
| Static Hosting | `npm run build` | Deploy static files |

### Docker Deployment

```bash
# Build and start all services
docker-compose up --build

# Build images only
docker-compose build

# Start services in background
docker-compose up -d

# Stop services
docker-compose down
```

### Kubernetes Deployment

```bash
# Apply Kubernetes manifests
kubectl apply -f k8s/

# Deploy with namespace
kubectl apply -f k8s/ --namespace=scheduledelete

# View deployment status
kubectl get deployments
```

## Development

### Running in Development Mode

```bash
# Start backend server
cd server
npm run dev

# Start frontend application in another terminal
cd client
npm run dev

# Open browser to http://localhost:3000
```

### Building for Production

```bash
# Build frontend
cd client
npm run build

# Build backend
cd server
npm run build

# Create Docker image
docker build -t scheduledelete .
```

### Testing

```bash
# Run unit tests
cd client
npm test
cd ../server
npm test

# Run integration tests
cd client
npm run test:integration
cd ../server
npm run test:integration

# Run e2e tests
cd client
npm run test:e2e
```

## Deployment

### Production Deployment

ScheduleDelete can be deployed to various platforms:

- **Cloud Platforms**: AWS ECS, Google Cloud Run, Azure Container Instances
- **Container Orchestration**: Kubernetes, Docker Swarm
- **Static Hosting**: Vercel, Netlify, AWS S3 + CloudFront
- **Server Hosting**: Direct deployment to VPS or dedicated servers

### Docker Deployment

```bash
# Build the Docker image
docker build -t scheduledelete .

# Run the application
docker run -p 3000:3000 scheduledelete

# With environment variables
docker run -p 3000:3000 \
  -e DATABASE_URL=postgresql://username:password@localhost:5432/scheduledelete \
  -e REDIS_URL=redis://localhost:6379 \
  -e JWT_SECRET=your-secret-key \
  scheduledelete
```

### Kubernetes Deployment

```bash
# Create namespace
kubectl create namespace scheduledelete

# Apply Kubernetes manifests
kubectl apply -f k8s/ --namespace=scheduledelete

# Expose service
kubectl expose deployment scheduledelete-server \
  --port=3000 --type=LoadBalancer \
  --namespace=scheduledelete

# Get service URL
kubectl get svc scheduledelete-server \
  --namespace=scheduledelete -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

## Contributing

### Contribution Guidelines

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Add tests**
5. **Commit your changes**
6. **Push to your branch**
7. **Create a pull request**

### Code Quality

- Follow ESLint and Prettier for code formatting
- Write comprehensive unit and integration tests
- Keep commit messages clear and descriptive
- Update documentation as needed
- Follow TypeScript best practices

## Troubleshooting

### Common Issues

#### Application Won't Start

1. **Check dependencies**
   ```bash
   npm install
   ```

2. **Check environment variables**
   Ensure all required environment variables are set

3. **Check port availability**
   Ensure port 3000 is available

#### Build Errors

1. **Clean node_modules**
   ```bash
   rm -rf node_modules
   npm install
   ```

2. **Check TypeScript configuration**
   Ensure tsconfig.json is correctly configured

#### Database Issues

1. **Check database connection**
   Ensure PostgreSQL and Redis are running

2. **Check database schema**
   Ensure all required tables are created

#### Performance Issues

1. **Clear browser cache**
   - Go to `chrome://settings/`
   - Click "Clear browsing data"
   - Select "Cached images and files"

2. **Check for memory leaks**
   Use browser developer tools to monitor memory usage

## Support

### Getting Help

- **GitHub Issues**: Report bugs and request features
- **Documentation**: Check the official documentation
- **Community**: Join the community forums

### Reporting Issues

When reporting an issue, please include:

- **Description of the problem**
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **Environment details** (OS, version, dependencies, etc.)

## License

ScheduleDelete is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgements

- **React**: For building a powerful UI library
- **TypeScript**: For type safety
- **Node.js**: For backend development
- **PostgreSQL**: For database management
- **Redis**: For caching and session management
- **Tailwind CSS**: For styling
- **All contributors**: For making this project better

## Contact

- **Website**: https://scheduledelete.example.com
- **Email**: support@example.com
- **GitHub**: https://github.com/example/scheduledelete
- **Twitter**: @scheduledelete

---

*ScheduleDelete - Your Ultimate Schedule Management Solution*
