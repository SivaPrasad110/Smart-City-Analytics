# Phase 3 - Smart Analytics Dashboard

## Overview

Complete Smart Analytics Dashboard built with **React.js**, **FastAPI**, and modern design principles.

## Features

### Dashboard (/dashboard)
- KPI Cards with live metrics
- Traffic density trends chart
- AQI distribution pie chart
- Hourly congestion bar chart
- Recent activity table
- Monitored locations grid

### Analytics (/analytics)
- Comparative zone analysis
- Performance radar chart
- Weekly traffic trends
- Distribution analysis
- Stats summary cards

### Traffic Analytics (/traffic)
- Real-time traffic flow chart
- Congestion by location
- Speed distribution
- Traffic records table

### Pollution Analytics (/pollution)
- AQI trend chart
- Pollutant levels comparison
- Air quality distribution
- Detailed readings table

### Weather Analytics (/weather)
- Temperature forecast
- Humidity trends
- Wind speed/direction
- Weather condition distribution

## Project Structure

```
phase3_backend/
├── requirements.txt
├── app/
│   ├── main.py          # FastAPI application
│   ├── config.py        # Settings
│   ├── database.py      # Database connection
│   ├── schemas.py        # Pydantic schemas
│   ├── models/          # SQLAlchemy models
│   └── services/        # Business logic

phase3_frontend/
├── package.json
├── public/
│   └── index.html
└── src/
    ├── App.js
    ├── App.css
    ├── index.js
    ├── components/
    │   ├── Sidebar.js
    │   ├── Navbar.js
    │   ├── KPIcard.js
    │   ├── LoadingSpinner.js
    │   └── AnalyticsTable.js
    ├── pages/
    │   ├── Dashboard.js
    │   ├── Analytics.js
    │   ├── TrafficPage.js
    │   ├── PollutionPage.js
    │   └── WeatherPage.js
    └── services/
        └── api.js
```

## Installation & Running

### Backend (FastAPI)

```bash
cd phase3_backend

# Create virtual environment
python -m venv venv
venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt

# Configure PostgreSQL (update .env or config.py)
# Default: postgresql://postgres:postgres@localhost:5432/smartcity

# Run server
uvicorn app.main:app --reload --port 8000
```

### Frontend (React)

```bash
cd phase3_frontend

# Install dependencies
npm install

# Run development server
npm start
```

### Seed Sample Data

After starting the backend, call:
```
POST http://localhost:8000/seed-data
```

Or use curl:
```bash
curl -X POST http://localhost:8000/seed-data
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /health | Health check |
| GET | /dashboard-stats | Aggregated dashboard stats |
| GET | /traffic-data | Traffic analytics data |
| GET | /pollution-data | Pollution analytics data |
| GET | /weather-data | Weather analytics data |
| GET | /traffic-stats | Traffic statistics |
| GET | /pollution-stats | Pollution statistics |
| GET | /weather-stats | Weather statistics |
| GET | /analytics/traffic-trends | Traffic trends data |
| GET | /analytics/aqi-trends | AQI trends data |
| GET | /analytics/weather-forecast | Weather forecast |
| POST | /seed-data | Seed sample data |

## Technologies Used

### Backend
- FastAPI 0.109.0
- SQLAlchemy 2.0.25
- PostgreSQL (asyncpg)
- Pydantic 2.5.3
- Uvicorn

### Frontend
- React 18.2.0
- React Router DOM 6
- Chart.js 4.4.1
- react-chartjs-2 5.2.0
- Bootstrap 5.3.2
- Axios 1.6.2
- Lucide React (icons)

## UI Components

- **Sidebar**: Collapsible navigation with icons
- **Navbar**: Search, notifications, user profile, clock
- **KPIcard**: Animated metric cards with gradients
- **AnalyticsTable**: Sortable data table with severity colors
- **LoadingSpinner**: Animated loading states

## Database Tables

- **traffic_data**: Traffic level, vehicle count, speed, congestion
- **pollution_data**: AQI, CO2, PM2.5, PM10, O3
- **weather_data**: Temperature, humidity, rainfall, wind, pressure

All tables include location and timestamp fields for time-series analysis.