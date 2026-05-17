# Smart City Analytics & Prediction Platform

![Version](https://img.shields.io/badge/version-7.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Python](https://img.shields.io/badge/python-3.11+-orange.svg)
![React](https://img.shields.io/badge/react-18.2-yellow.svg)

A comprehensive full-stack smart city analytics platform featuring real-time dashboards, AI-powered predictions, interactive maps, and geospatial analytics.

## 🌟 Features

### Core Analytics
- **Traffic Monitoring** - Real-time traffic level tracking, congestion analysis, vehicle counts
- **Pollution Tracking** - AQI monitoring, CO2 levels, PM2.5/PM10 particles, ozone tracking
- **Weather Monitoring** - Temperature, humidity, rainfall, wind speed, pressure readings
- **Emergency Analytics** - Incident tracking, hotspot detection, response time analysis

### AI & Machine Learning (Phase 5)
- **Traffic Prediction** - ML-based congestion forecasting (Random Forest, Gradient Boosting)
- **Pollution Forecasting** - AQI prediction with health advisories
- **Weather Forecasting** - Temperature and condition predictions
- **Emergency Prediction** - Risk classification and hotspot detection

### Maps & Geospatial (Phase 6)
- **Interactive Leaflet Maps** - Dark-themed CartoDB tiles
- **Traffic Heatmaps** - Visual congestion density
- **Pollution Heatmaps** - Air quality visualization
- **Emergency Hotspots** - Risk zone identification
- **Multi-layer Control** - Toggle between data views

### Production Features (Phase 7)
- **JWT Authentication** - Secure user access
- **RESTful APIs** - Complete API documentation
- **Docker Deployment** - Containerized setup
- **CI/CD Pipeline** - GitHub Actions automation
- **PostgreSQL Integration** - Reliable data storage

## 🏗️ Tech Stack

### Backend
| Technology | Purpose |
|------------|---------|
| FastAPI | High-performance web framework |
| PostgreSQL | Primary database |
| SQLAlchemy | ORM |
| Scikit-learn | Machine learning |
| Pandas/NumPy | Data processing |
| JWT | Authentication |
| Pydantic | Data validation |

### Frontend
| Technology | Purpose |
|------------|---------|
| React 18 | UI framework |
| React Router | Routing |
| Chart.js | Charts and graphs |
| React-Leaflet | Interactive maps |
| Leaflet.heat | Heatmap visualization |
| Bootstrap 5 | Styling |
| Lucide React | Icons |
| Axios | HTTP client |

### DevOps
| Technology | Purpose |
|------------|---------|
| Docker | Containerization |
| Docker Compose | Multi-container orchestration |
| GitHub Actions | CI/CD pipeline |
| Render | Cloud hosting |
| Nginx | Reverse proxy |

## 📁 Project Structure

```
smart-city-analytics/
├── phase3_backend/              # FastAPI backend
│   ├── app/
│   │   ├── main.py             # FastAPI application
│   │   ├── database.py         # Database configuration
│   │   ├── maps.py             # GeoJSON map endpoints
│   │   ├── config.py           # Configuration
│   │   ├── production.py       # Production settings
│   │   ├── models/             # Database models
│   │   ├── schemas/            # Pydantic schemas
│   │   ├── api/                # API routes
│   │   ├── analytics/          # Analytics modules
│   │   └── ml/                 # ML prediction modules
│   ├── requirements.txt
│   └── Dockerfile
│
├── phase3_frontend/            # React frontend
│   ├── src/
│   │   ├── components/         # React components
│   │   │   ├── maps/           # Map components
│   │   │   └── analytics/      # Analytics components
│   │   ├── pages/              # Page components
│   │   │   └── maps/           # Map pages
│   │   ├── App.js              # Main app
│   │   └── index.js            # Entry point
│   ├── package.json
│   └── Dockerfile
│
├── docker/                     # Docker configuration
│   ├── nginx.conf             # Nginx reverse proxy
│   ├── nginx.frontend.conf    # Frontend nginx config
│   ├── init.sql               # Database initialization
│   ├── backend.Dockerfile
│   └── frontend.Dockerfile
│
├── .github/
│   └── workflows/
│       └── deploy.yml         # CI/CD pipeline
│
├── .env.example               # Environment template
├��─ .dockerignore
├── docker-compose.yml         # Docker orchestration
├── README.md
└── LICENSE
```

## 🚀 Quick Start

### Prerequisites
- Python 3.11+
- Node.js 18+
- Docker & Docker Compose
- PostgreSQL 15+ (if not using Docker)

### Option 1: Docker Deployment (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/smart-city-analytics.git
cd smart-city-analytics

# Copy environment file
cp .env.example .env

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Access the application
echo "Frontend: http://localhost:3000"
echo "Backend API: http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"
```

### Option 2: Manual Local Setup

#### Backend Setup

```bash
cd phase3_backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
.\venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt

# Set environment variables
export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/smartcity
export SECRET_KEY=your-secret-key-here

# Start the server
uvicorn app.main:app --reload --port 8000
```

#### Frontend Setup

```bash
cd phase3_frontend

# Install dependencies
npm install

# Start development server
npm start
```

#### Access Points
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

## 📋 API Reference

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | User login |
| GET | `/api/auth/me` | Get current user |

### Analytics Data
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/traffic-data` | Get traffic data |
| GET | `/pollution-data` | Get pollution data |
| GET | `/weather-data` | Get weather data |
| GET | `/dashboard/stats` | Dashboard statistics |

### Analytics Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/analytics/trends` | Get data trends |
| GET | `/analytics/heatmap` | Get heatmap data |
| GET | `/analytics/forecast-summary` | Get forecast summary |

### ML Predictions
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/predict/traffic` | Predict traffic level |
| POST | `/predict/pollution` | Predict AQI |
| POST | `/predict/weather` | Predict weather |
| POST | `/predict/emergency` | Predict emergency risk |
| GET | `/ai/recommendations` | Get AI recommendations |

### Map Data
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/maps/traffic-zones` | Traffic GeoJSON |
| GET | `/maps/pollution-zones` | Pollution GeoJSON |
| GET | `/maps/weather-zones` | Weather GeoJSON |
| GET | `/maps/emergency-zones` | Emergency GeoJSON |
| GET | `/maps/heatmap-data` | Heatmap data |
| GET | `/maps/city-overview` | City map config |

## 🐳 Docker Deployment

### Docker Compose Services

| Service | Port | Description |
|---------|------|-------------|
| db | 5432 | PostgreSQL database |
| backend | 8000 | FastAPI server |
| frontend | 3000 | React application |
| nginx | 80/443 | Reverse proxy |

### Building Images

```bash
# Build backend image
docker build -t smartcity-backend:latest -f docker/backend.Dockerfile .

# Build frontend image
docker build -t smartcity-frontend:latest -f docker/frontend.Dockerfile .

# Pull pre-built images
docker pull ghcr.io/yourusername/smart-city-analytics/backend:latest
docker pull ghcr.io/yourusername/smart-city-analytics/frontend:latest
```

### Environment Variables

Create a `.env` file:

```env
# Database
DB_PASSWORD=your_secure_password

# Security
SECRET_KEY=your-super-secret-key-minimum-32-chars
JWT_SECRET=your-jwt-secret-key

# Application
ENVIRONMENT=production
DEBUG=false
```

## ☁️ Cloud Deployment

### Render Deployment

1. Connect GitHub repository to Render
2. Create new Web Service for Backend
3. Configure environment variables
4. Deploy with Docker

**Render Service IDs** (set in GitHub Secrets):
- `RENDER_SERVICE_ID_BACKEND`
- `RENDER_API_KEY`

### Railway Deployment

1. Fork and import repository
2. Add PostgreSQL database
3. Deploy backend and frontend
4. Configure environment variables

### Manual Cloud Setup

```bash
# Set environment variables on cloud provider
export DATABASE_URL=postgresql://user:pass@host:5432/smartcity
export SECRET_KEY=your-production-secret
export JWT_SECRET=your-jwt-secret
export ENVIRONMENT=production

# Start services
docker-compose -f docker-compose.production.yml up -d
```

## 🔄 CI/CD Pipeline

GitHub Actions workflow automatically:
- Runs code quality checks (ESLint)
- Executes Python syntax validation
- Runs backend unit tests
- Builds React frontend
- Builds Docker images
- Deploys to Render on main branch

### Workflow Triggers
- Push to `main` or `develop` branches
- Pull requests to `main`

## 📊 Features by Phase

| Phase | Features |
|-------|----------|
| Phase 1 | Backend setup, frontend scaffolding, PostgreSQL |
| Phase 2 | JWT authentication system |
| Phase 3 | Analytics dashboard with charts |
| Phase 4 | Advanced analytics, Pandas processing, reports |
| Phase 5 | ML prediction engine, AI models |
| Phase 6 | Interactive Leaflet maps, GeoJSON APIs |
| Phase 7 | Docker, CI/CD, production deployment |

## 🔒 Security Features

- JWT token authentication
- Password hashing with bcrypt
- CORS origin whitelisting
- Rate limiting
- Input validation
- SQL injection prevention
- Secure environment variable handling

## 📈 Performance Optimizations

- Gunicorn workers for FastAPI
- React code splitting
- Lazy loading components
- Database query optimization
- Caching strategies
- Map tile caching
- Bundle minification

## 🧪 Testing

```bash
# Backend tests
cd phase3_backend
pytest tests/ -v

# Frontend tests
cd phase3_frontend
npm test -- --coverage

# Docker tests
docker-compose ps
docker-compose logs
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Support

For questions or support:
- Create an issue on GitHub
- Email: support@smartcity.com

## 🙏 Acknowledgments

- OpenStreetMap for base map tiles
- CartoDB for dark theme tiles
- Scikit-learn for ML algorithms
- FastAPI for the excellent web framework

---

**Built with ❤️ for Smart City Analytics**

Version 7.0.0 | Made with Python + React + PostgreSQL