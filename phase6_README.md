# Phase 6 - Real-Time Maps & Geospatial Analytics

## Overview

Phase 6 integrates interactive Leaflet maps and geospatial analytics into the Smart City Analytics platform, enabling visual monitoring of traffic, pollution, weather, and emergency data.

## Features

### Map Components

| Component | Description |
|-----------|-------------|
| `SmartMap.js` | Main map container with dark theme tiles |
| `TrafficLayer.js` | Traffic zone markers with color-coded congestion |
| `PollutionLayer.js` | AQI visualization with health advisories |
| `WeatherLayer.js` | Weather station markers with conditions |
| `EmergencyLayer.js` | Emergency hotspots and incident markers |
| `HeatmapLayer.js` | Heat map visualization for all categories |
| `LayerControl.js` | Toggle map layers on/off |
| `GeoAnalyticsPanel.js` | Floating analytics panel for selected zones |
| `MarkerPopup.js` | Specialized popup cards for each data type |

### Map Pages

| Route | Page | Description |
|-------|------|-------------|
| `/maps` | MainMapPage | Combined map with all layers |
| `/traffic-map` | TrafficMapPage | Dedicated traffic analytics |
| `/pollution-map` | PollutionMapPage | Air quality monitoring |
| `/weather-map` | WeatherMapPage | Weather conditions |
| `/emergency-map` | EmergencyMapPage | Emergency hotspots |

### Backend GeoJSON APIs

| Endpoint | Description |
|----------|-------------|
| `GET /maps/traffic-zones` | Traffic zones as GeoJSON |
| `GET /maps/pollution-zones` | Pollution zones as GeoJSON |
| `GET /maps/weather-zones` | Weather stations as GeoJSON |
| `GET /maps/emergency-zones` | Emergency hotspots as GeoJSON |
| `GET /maps/heatmap-data` | Heatmap point data |
| `GET /maps/city-overview` | City map configuration |

## Project Structure

```
phase3_frontend/src/
├── components/
│   └── maps/
│       ├── SmartMap.js           # Map container
│       ├── TrafficLayer.js       # Traffic visualization
│       ├── PollutionLayer.js     # Air quality viz
│       ├── WeatherLayer.js       # Weather station markers
│       ├── EmergencyLayer.js     # Emergency hotspots
│       ├── HeatmapLayer.js       # Heatmap overlays
│       ├── LayerControl.js        # Layer toggles
│       ├── GeoAnalyticsPanel.js   # Analytics sidebar
│       ├── MarkerPopup.js        # Popup cards
│       └── index.js
└── pages/
    └── maps/
        ├── MainMapPage.js         # Combined map
        ├── TrafficMapPage.js     # Traffic map
        ├── PollutionMapPage.js   # Pollution map
        ├── WeatherMapPage.js     # Weather map
        ├── EmergencyMapPage.js   # Emergency map
        └── index.js

phase3_backend/app/
├── main.py                       # API with maps router
└── maps.py                       # GeoJSON endpoints
```

## Installation

### Frontend Dependencies

New packages added to `package.json`:
```json
{
  "leaflet": "^1.9.4",
  "react-leaflet": "^4.2.1",
  "leaflet.heat": "^0.2.0"
}
```

Install:
```bash
cd phase3_frontend
npm install leaflet react-leaflet leaflet.heat
```

### Backend Updates

No additional backend dependencies required.

## Running the Application

### Start Backend
```bash
cd phase3_backend
uvicorn app.main:app --reload --port 8000
```

### Start Frontend
```bash
cd phase3_frontend
npm start
```

### Access Maps
- **Combined Map**: http://localhost:3000/maps
- **Traffic Map**: http://localhost:3000/traffic-map
- **Pollution Map**: http://localhost:3000/pollution-map
- **Weather Map**: http://localhost:3000/weather-map
- **Emergency Map**: http://localhost:3000/emergency-map

## API Examples

### Get Traffic Zones (GeoJSON)
```bash
curl http://localhost:8000/maps/traffic-zones?format=geojson
```

Response:
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [-74.0060, 40.7128]
      },
      "properties": {
        "name": "Downtown",
        "traffic_level": 78,
        "average_speed": 25,
        "congestion_index": 0.82,
        "vehicle_count": 450,
        "risk_level": "high"
      }
    }
  ]
}
```

### Get Heatmap Data
```bash
curl http://localhost:8000/maps/heatmap-data?category=traffic
```

Response:
```json
{
  "success": true,
  "category": "traffic",
  "points": [
    {"lat": 40.7128, "lng": -74.0060, "intensity": 0.78, "value": 78, "category": "traffic"}
  ]
}
```

### Get City Overview
```bash
curl http://localhost:8000/maps/city-overview
```

## Map Features

### Layer Controls
- Toggle individual layers on/off
- Visual indicators showing active layers
- Color-coded layer labels

### Heatmaps
- Traffic congestion heatmaps
- Pollution AQI heatmaps
- Emergency incident density maps
- Gradient colors: green → yellow → orange → red → purple

### Interactive Markers
- Click for detailed popup cards
- Color-coded by severity/value
- Size indicates intensity

### Analytics Panels
- Floating panels showing zone details
- Stats cards with icons
- Health advisories for pollution

## Technologies Used

### Frontend
- **React-Leaflet**: React bindings for Leaflet
- **Leaflet**: Interactive map library
- **Leaflet.heat**: Heatmap visualization
- **Bootstrap 5**: UI components

### Backend
- **FastAPI**: REST API framework
- **GeoJSON**: Geographic data format
- **SQLAlchemy**: Database ORM

### Map Styling
- **CartoDB Dark Matter**: Dark themed map tiles
- **OpenStreetMap**: Base layer attribution

## City Zones

Default city zones with coordinates:
| Zone | Latitude | Longitude |
|------|----------|-----------|
| Downtown | 40.7128 | -74.0060 |
| Midtown | 40.7549 | -73.9840 |
| Uptown | 40.7831 | -73.9712 |
| Airport District | 40.6413 | -73.7781 |
| Industrial Zone | 40.7282 | -73.7949 |

## Color Coding

### Traffic Levels
| Level | Color | Meaning |
|-------|-------|---------|
| 0-20% | `#00c853` | Minimal traffic |
| 20-40% | `#69f0ae` | Low traffic |
| 40-60% | `#ffc107` | Moderate traffic |
| 60-80% | `#ff9100` | High traffic |
| 80-100% | `#ff5252` | Critical congestion |

### Air Quality Index
| AQI | Color | Category |
|-----|-------|----------|
| 0-50 | `#00c853` | Good |
| 51-100 | `#ffc107` | Moderate |
| 101-150 | `#ff9100` | Unhealthy (Sensitive) |
| 151-200 | `#ff5252` | Unhealthy |
| 201-300 | `#9c27b0` | Very Unhealthy |
| 300+ | `#4a148c` | Hazardous |

### Emergency Severity
| Level | Color |
|-------|-------|
| Low | `#ffc107` |
| Medium | `#ff9100` |
| High | `#ff5252` |
| Critical | `#9c27b0` |

## All 6 Phases Complete

| Phase | Status | Key Deliverables |
|-------|--------|------------------|
| Phase 1 | ✅ | Backend, frontend, PostgreSQL |
| Phase 2 | ✅ | JWT authentication |
| Phase 3 | ✅ | Analytics dashboard |
| Phase 4 | ✅ | Analytics engine |
| Phase 5 | ✅ | ML prediction engine |
| Phase 6 | ✅ | Interactive GIS maps |

## Future Enhancements

- Real-time WebSocket updates
- User location tracking
- Route optimization
- Mobile responsive map UI
- Offline map caching