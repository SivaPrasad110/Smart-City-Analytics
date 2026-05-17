# ✅ DEPLOYMENT GUIDE - Smart City Analytics

**Repository:** https://github.com/SivaPrasad110/Smart-City-Analytics  
**Last Updated:** 2026-05-17  
**Version:** 2.0 (Fixed)

---

## 📋 Quick Start (5 Minutes)

### Prerequisites
- Docker & Docker Compose installed
- 4GB RAM available
- Ports 3000, 8000, 5432 available

### Step 1: Clone Repository
```bash
git clone https://github.com/SivaPrasad110/Smart-City-Analytics.git
cd Smart-City-Analytics
```

### Step 2: Configure Environment
```bash
# Copy template
cp .env.example .env

# Edit with secure values
nano .env

# Required: Change these values
# DB_PASSWORD=your_strong_password_here
# SECRET_KEY=your_32_character_secret_key_here
# JWT_SECRET=your_32_character_jwt_secret_here
```

### Step 3: Deploy
```bash
chmod +x deploy.sh
./deploy.sh deploy
```

### Step 4: Access Services
- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **Health:** http://localhost:8000/health

---

## 🔧 Detailed Deployment

### 1. Environment Setup

#### Create .env File
```bash
cp .env.example .env
```

#### Edit .env with Production Values
```env
# DATABASE
DB_PASSWORD=MySecurePassword123!@#$%

# SECURITY (Generate with: python -c "import secrets; print(secrets.token_urlsafe(32))")
SECRET_KEY=sxKqL8mN9pQ0rS1tU2vW3xY4zA5bC6dE7fG8hI9jK
JWT_SECRET=jK0lM1nO2pQ3rS4tU5vW6xY7zA8bC9dE0fG1hI2jK

# ENVIRONMENT
ENVIRONMENT=production
DEBUG=false
LOG_LEVEL=INFO
```

### 2. Build Services
```bash
# Build backend
docker-compose build --no-cache backend

# Build frontend
docker-compose build frontend

# View images
docker images | grep smart-city
```

### 3. Start Services
```bash
# Start all services
docker-compose up -d

# Monitor startup
docker-compose logs -f
```

### 4. Verify Health
```bash
# Check container status
docker-compose ps

# Check backend health
curl http://localhost:8000/health

# Check frontend
curl http://localhost:3000

# Detailed health check
./deploy.sh health
```

### 5. Seed Sample Data (Optional)
```bash
# Backend should have API endpoint
curl -X POST http://localhost:8000/seed-data

# Or check backend logs
docker-compose logs backend | grep seed
```

---

## 🎯 Common Operations

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db

# Last 50 lines
docker-compose logs --tail=50

# Real-time with grep
docker-compose logs -f backend | grep ERROR
```

### Scale Backend
```bash
# Scale to 3 replicas
./deploy.sh scale 3

# Verify
docker-compose ps | grep backend
```

### Restart Services
```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart backend
docker-compose restart frontend
```

### Stop Services
```bash
# Stop all (keep volumes)
docker-compose stop

# Stop and remove (keep volumes)
docker-compose down

# Stop and remove everything (including volumes)
docker-compose down -v --remove-orphans
```

### Clean Up
```bash
# Full cleanup (interactive)
./deploy.sh cleanup

# Manual cleanup
docker-compose down -v --remove-orphans
docker system prune -f
```

---

## 🔒 Security Best Practices

### ✅ DO:
- [x] Change all default passwords
- [x] Use strong, unique secrets (32+ characters)
- [x] Keep .env file secure (never commit to git)
- [x] Use HTTPS in production
- [x] Enable authentication on all endpoints
- [x] Set ENVIRONMENT=production
- [x] Set DEBUG=false
- [x] Regular backups of database
- [x] Monitor logs for suspicious activity
- [x] Keep Docker and dependencies updated

### ❌ DON'T:
- [ ] Use placeholder/default values in production
- [ ] Commit .env to version control
- [ ] Use DEBUG=true in production
- [ ] Expose database port to internet (5432)
- [ ] Skip environment validation
- [ ] Use weak passwords
- [ ] Run containers as root
- [ ] Disable security headers

---

## 🐛 Troubleshooting

### Problem: "DB_PASSWORD not set"
```bash
# Solution 1: Check .env exists
ls -la .env

# Solution 2: Verify DB_PASSWORD is set
grep "^DB_PASSWORD=" .env

# Solution 3: Update .env
nano .env
```

### Problem: Container won't start
```bash
# Check logs
docker-compose logs db

# Option A: Wrong password - check logs for auth errors
# Option B: Port conflict - change in docker-compose.yml
# Option C: No space - check disk: df -h
```

### Problem: Frontend can't connect to backend
```bash
# Check REACT_APP_API_URL
docker-compose exec frontend env | grep REACT_APP_API_URL

# Check network
docker network ls
docker network inspect smart-city-analytics_smartcity-network

# Test connectivity
docker-compose exec frontend curl http://backend:8000/health
```

### Problem: Health check timeout
```bash
# Check service logs
docker-compose logs --tail=100 backend

# Increase retry count
# Edit docker-compose.yml: retries: 10

# Restart services
docker-compose restart
```

### Problem: Port already in use
```bash
# Find process using port 3000
lsof -i :3000

# Kill process or change port
# Edit docker-compose.yml: "3001:3000"
```

---

## 🚀 Production Deployment

### Checklist
- [ ] Use docker-compose.yml (or docker-compose-fixed.yml)
- [ ] Configure .env with production values
- [ ] Set ENVIRONMENT=production
- [ ] Set DEBUG=false
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall (only expose ports 80, 443)
- [ ] Set up monitoring & alerting
- [ ] Configure log aggregation
- [ ] Set up automated backups
- [ ] Create admin user account
- [ ] Test health endpoints
- [ ] Load test application
- [ ] Document deployment procedure

### Resources Needed
- **CPU:** 4+ cores recommended
- **Memory:** 8GB+ recommended
- **Storage:** 100GB+ (depends on data)
- **Network:** 10Mbps+ connection
- **Backup:** Separate storage for PostgreSQL backups

### Performance Tuning
```yaml
# docker-compose.yml backend service
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 4G
    reservations:
      cpus: '2'
      memory: 2G
```

### Database Maintenance
```bash
# Backup database
docker-compose exec db pg_dump -U postgres smartcity > backup.sql

# Restore database
cat backup.sql | docker-compose exec -T db psql -U postgres

# Vacuum database
docker-compose exec db vacuumdb -U postgres smartcity
```

---

## 📊 Monitoring

### Health Endpoints
```bash
# Backend health
curl http://localhost:8000/health
# Response: {"status": "ok"}

# Frontend health
curl http://localhost:3000
# Response: HTML page
```

### Container Status
```bash
# Check all containers
docker-compose ps

# Expected output:
# NAME                      STATUS
# smartcity-db             Up (healthy)
# smartcity-backend        Up (healthy)
# smartcity-frontend       Up (running)
```

### Resource Usage
```bash
# Memory and CPU
docker stats

# Disk usage
docker system df

# Detailed info
docker-compose ps --format "table {{.Service}}\t{{.State}}\t{{.Status}}"
```

---

## 🔄 Updating Application

### Update Code
```bash
# Get latest
git pull origin main

# Rebuild images
docker-compose build --no-cache backend
docker-compose build frontend

# Restart services
docker-compose restart
```

### Update Dependencies
```bash
# Backend
# Edit phase3_backend/requirements.txt
docker-compose build --no-cache backend

# Frontend
# Edit phase3_frontend/package.json
docker-compose build frontend
```

---

## 📞 Support & Documentation

### Local Documentation
- `README.md` - Project overview
- `phase3_README.md` - Phase 3 features
- `phase5_README.md` - ML features
- `phase6_README.md` - Maps features
- `phase8_ENTERPRISE.md` - Enterprise features
- `BUG_FIXES_DETAILED.md` - Bug fixes explanation

### Online Resources
- **Repository:** https://github.com/SivaPrasad110/Smart-City-Analytics
- **Issues:** https://github.com/SivaPrasad110/Smart-City-Analytics/issues
- **Discussions:** https://github.com/SivaPrasad110/Smart-City-Analytics/discussions

### API Documentation
- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc
- **OpenAPI JSON:** http://localhost:8000/openapi.json

---

## ✅ Post-Deployment Verification

### 1. Services Running
```bash
docker-compose ps
# All services should show "Up" status
```

### 2. Health Checks
```bash
./deploy.sh health
# Both backend and frontend should be ready
```

### 3. Database Connected
```bash
curl http://localhost:8000/health
# Should return {"status": "ok"}
```

### 4. API Accessible
```bash
curl http://localhost:8000/docs
# Should return Swagger UI HTML
```

### 5. Frontend Loaded
```bash
curl http://localhost:3000
# Should return main dashboard HTML
```

### 6. No Errors in Logs
```bash
docker-compose logs | grep -i error
# Should return nothing (or only expected errors)
```

---

## 🎓 Learning Resources

### Docker Compose Docs
- https://docs.docker.com/compose/

### FastAPI Docs
- https://fastapi.tiangolo.com/

### React Docs
- https://react.dev/

### PostgreSQL Docs
- https://www.postgresql.org/docs/

---

## 🆘 Getting Help

1. **Check Documentation:** Review README.md and phase-specific files
2. **Check Logs:** `docker-compose logs -f`
3. **Search Issues:** https://github.com/SivaPrasad110/Smart-City-Analytics/issues
4. **Create Issue:** Include logs and steps to reproduce
5. **Ask in Discussions:** https://github.com/SivaPrasad110/Smart-City-Analytics/discussions

---

**Happy Deploying! 🚀**
