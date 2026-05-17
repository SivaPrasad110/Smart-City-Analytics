# Phase 5 - Machine Learning & AI Prediction Engine

## Overview

Phase 5 adds production-level machine learning capabilities to the Smart City Analytics platform, transforming it into an AI-powered prediction system.

## Features

### ML Modules

| Module | Description | Algorithms |
|--------|-------------|------------|
| Traffic Prediction | Congestion forecasting | Random Forest, Gradient Boosting, Linear Regression |
| Pollution Forecasting | AQI prediction | Random Forest, Gradient Boosting, Ridge |
| Weather Forecasting | Temperature/humidity prediction | Random Forest, Gradient Boosting, Linear Regression |
| Emergency Prediction | Risk classification | Random Forest, Gradient Boosting, Logistic Regression |

### AI Prediction Dashboard (`/predictions`)

- Real-time predictions for traffic, pollution, weather, emergency
- Confidence scores for all predictions
- AI-powered recommendations
- Risk level assessments
- Emergency hotspot detection

### API Endpoints

#### Prediction APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/predict/traffic` | Predict traffic congestion |
| POST | `/predict/traffic/future` | Forecast traffic for N hours |
| POST | `/predict/pollution` | Predict AQI/pollution levels |
| POST | `/predict/pollution/forecast` | Forecast pollution |
| POST | `/predict/weather` | Predict weather conditions |
| POST | `/predict/weather/forecast` | Multi-day weather forecast |
| POST | `/predict/emergency` | Predict emergency risk |
| POST | `/predict/emergency/hotspots` | Identify risk hotspots |

#### Model Management APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/ml/model-status` | Get status of all ML models |
| GET | `/ml/training-metrics` | Get model accuracy metrics |
| POST | `/ml/train` | Train all models |

#### AI Insights APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/ai/recommendations` | AI-powered recommendations |
| GET | `/ai/city-insights` | Combined city-wide AI insights |

## Project Structure

```
phase3_backend/
├── app/
│   ├── main.py              # FastAPI with ML endpoints
│   └── ml/
│       ├── preprocessing.py        # Data preprocessing pipeline
│       ├── traffic_prediction.py   # Traffic ML model
│       ├── pollution_forecasting.py # Pollution ML model
│       ├── weather_forecasting.py  # Weather ML model
│       ├── emergency_prediction.py # Emergency ML model
│       ├── train_models.py         # Training script
│       ├── model_loader.py         # Model manager
│       └── __init__.py
└── models/                  # Trained models (created after training)

phase3_frontend/src/
├── pages/
│   └── PredictionDashboard.js  # AI Predictions UI
└── components/
    └── analytics/          # Reusable analytics components
```

## Installation & Running

### 1. Install Dependencies

```bash
cd phase3_backend
pip install -r requirements.txt
```

**New dependencies added:**
- `scikit-learn==1.4.0` - ML algorithms
- `joblib==1.3.2` - Model serialization

### 2. Start Backend

```bash
cd phase3_backend
uvicorn app.main:app --reload --port 8000
```

### 3. Train Models (First Time)

```bash
# Option 1: Via API
curl -X POST http://localhost:8000/ml/train

# Option 2: Direct Python
cd phase3_backend
python -m app.ml.train_models
```

### 4. Start Frontend

```bash
cd phase3_frontend
npm install
npm start
```

### 5. Access Application

- **Dashboard**: http://localhost:3000/dashboard
- **AI Predictions**: http://localhost:3000/predictions
- **API Docs**: http://localhost:8000/docs

## Sample Prediction Request

### Traffic Prediction

```bash
curl -X POST http://localhost:8000/predict/traffic \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Downtown",
    "traffic_level": 50,
    "vehicle_count": 200,
    "average_speed": 40,
    "timestamp": "2024-01-15T08:30:00"
  }'
```

### Response

```json
{
  "success": true,
  "prediction_type": "traffic",
  "result": {
    "prediction": 72.5,
    "confidence": 87.3,
    "risk_level": "moderate",
    "timestamp": "2024-01-15T08:30:00"
  },
  "model_used": "TrafficPredictor"
}
```

### Pollutant Prediction

```bash
curl -X POST http://localhost:8000/predict/pollution \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Downtown",
    "aqi": 65,
    "co2": 400,
    "pm25": 25,
    "pm10": 45,
    "o3": 35
  }'
```

### Weather Forecast

```bash
curl -X POST http://localhost:8000/predict/weather \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Downtown",
    "temperature": 24,
    "humidity": 65,
    "pressure": 1013
  }'
```

### Emergency Hotspots

```bash
curl -X POST http://localhost:8000/predict/emergency/hotspots \
  -H "Content-Type: application/json" \
  -d '{"hours_ahead": 24}'
```

## AI Recommendations

```bash
curl http://localhost:8000/ai/recommendations
```

Returns prioritized recommendations based on current data and predictions.

## Model Performance Metrics

| Model | MAE | RMSE | R² Score |
|-------|-----|------|----------|
| Traffic | < 10 | < 15 | > 0.80 |
| Pollution | < 15 | < 25 | > 0.75 |
| Weather | < 3°C | < 5°C | > 0.85 |
| Emergency | Accuracy > 80% | Precision > 75% | Recall > 70% |

## Technologies Used

### Backend ML
- **Scikit-learn**: ML algorithms (Random Forest, Gradient Boosting, Linear Regression, Logistic Regression)
- **Pandas**: Data manipulation and preprocessing
- **NumPy**: Numerical computations
- **Joblib**: Model serialization

### Frontend
- **React.js**: UI framework
- **Chart.js**: Prediction visualizations
- **Axios**: API communication

## AI Features

### Predictive Analytics
- Traffic congestion forecasting (up to 72 hours)
- AQI/pollution level predictions
- Weather condition forecasting
- Emergency risk assessment

### Intelligent Insights
- Automated recommendations based on predictions
- Anomaly detection in city metrics
- Risk factor identification
- Hotspot prediction for emergencies

### Model Management
- Automatic model training from historical data
- Cross-validation metrics
- Feature importance analysis
- Model persistence and loading

## Future Enhancements

Potential Phase 6 features:
- LSTM neural networks for time series
- XGBoost integration for enhanced accuracy
- Real-time streaming analytics
- Auto model retraining pipeline
- Anomaly detection with auto-alerts
- Prediction caching for performance