# AI/ML-Based Integrated Heavy Rainfall Early Warning & Inundation Prediction System (SIH26071)

[![Python 3.11](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-1.0.0-009688.svg)](https://fastapi.tiangolo.com/)
[![React 18](https://img.shields.io/badge/React-18.3-61DAFB.svg)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-3178C6.svg)](https://www.typescriptlang.org/)
[![Vite](https://img.shields.io/badge/Vite-5.4-646CFF.svg)](https://vitejs.dev/)
[![Tailwind CSS](https://img.shields.io/badge/TailwindCSS-3.4-38B2AC.svg)](https://tailwindcss.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An operational and scientifically honest research prototype designed for multi-source meteorological and geospatial data fusion, multi-horizon heavy rainfall forecasting, and topographic flood inundation susceptibility mapping over the **Delhi-NCR study area** (`28.30°N–28.88°N, 76.84°E–77.45°E`).

---

## 1. Problem Statement

Rapid urbanization and climate extremes have led to frequent heavy precipitation events and catastrophic localized urban inundation. Conventional weather forecasting frequently lacks hyper-local spatial resolution, while traditional hydraulic simulation models require heavy computational clusters and extensive proprietary input data.

This system addresses Problem Statement **SIH26071** by integrating:
- Spaceborne precipitation measurements (NASA GPM IMERG)
- Numerical Weather Prediction forecasts (NOAA GFS)
- Surface automated weather station networks (IMD AWS)
- High-resolution topography (NASA SRTM 30m)
- Satellite land use & land cover classification (ESA WorldCover 10m)
- Spaceborne Synthetic Aperture Radar water extent (Copernicus Sentinel-1 SAR)

The platform provides actionable early warnings and spatial inundation risk maps on commodity laptop hardware (< 4 GB RAM) without requiring heavy C-extensions or proprietary GIS software licenses.

---

## 2. Key Objectives & Features

1. **Multi-Horizon Precipitation Forecasting (6h, 12h, 24h)**:
   - Random Forest ML regressors trained with strict temporal discipline.
   - Evaluated against a rigorous Persistence Baseline and raw numerical NWP.
   - Zero lookahead data leakage: all predictors strictly indexed at forecast issuance time ($T_{\text{issue}}$).

2. **Physically Sound Flood Susceptibility Mapping**:
   - Pure-Python finite-difference computation of **Topographic Wetness Index (TWI)**, local slope, curvature, and elevation.
   - **Topographic Flood Susceptibility Index (TFSI)** synthesized with ESA WorldCover runoff curve numbers and distance-to-drainage factors.
   - Validated against empirical Sentinel-1 SAR water extent from the historical July 2023 Yamuna River flood event.

3. **Strict IMD Category Scaling**:
   - Rainfall warning tiers (No Rain, Light, Moderate, Heavy, Very Heavy, Extremely Heavy) scaled dynamically according to accumulation duration (e.g., 6h heavy rain $\ge 16.2$ mm; 24h heavy rain $\ge 64.5$ mm). Daily rainfall criteria are never improperly applied to sub-daily forecasts.

4. **Interactive GIS Dashboard & Analytics**:
   - Modern React + TypeScript interface powered by Tailwind CSS and Leaflet.
   - Real-time station observations, synoptic alerts, forecast timeline curves (Recharts), customizable thresholds, and administrative audit telemetry.

5. **Resource Efficiency**:
   - Pure-Python & NumPy/SciPy finite-difference terrain calculations (zero native GDAL/GEOS compilation hurdles).
   - Lightweight Scikit-Learn models consuming $< 10$ MB memory during runtime.

---

## 3. Technology Stack

### Backend
- **Language**: Python 3.11+
- **Web Framework**: FastAPI (Asynchronous REST API)
- **ASGI Server**: Uvicorn
- **Machine Learning**: Scikit-Learn (Random Forest, Ridge, Metrics), Joblib
- **Geospatial & Numerical Computation**: NumPy, SciPy (finite-difference digital elevation modeling)
- **Database**: SQLite3 (provenance registry, station observations, evaluation metrics, user preferences)
- **Validation**: Pydantic v2

### Frontend
- **Framework**: React 18
- **Language**: TypeScript
- **Bundler & Dev Server**: Vite 5
- **Styling**: Tailwind CSS, PostCSS, Autoprefixer
- **Mapping**: Leaflet 1.9, React-Leaflet
- **Data Visualization**: Recharts
- **Icons**: Lucide-React

---

## 4. System Architecture & Workflow

```
                                      [Official Data Ingestion]
  NASA GPM IMERG   |   IMD AWS Obs   |   NOAA GFS NWP   |   NASA SRTM DEM   |   ESA WorldCover   |   Sentinel-1 SAR
         \                  |                 /                   \                 /                  /
      [Data Ingestion Adapters & Quality Control]         [Geospatial Terrain & Hydrology Pipeline]
            - Delhi-NCR Bounding Box Subsetting                 - 30m Elevation Extraction (SRTMGL1)
            - Temporal UTC / IST Synchronization                - Finite-Difference Slope & Aspect
            - Rate vs Accumulation Normalization                - Topographic Wetness Index (TWI)
            - Provenance Tracking & Data Lineage                - Runoff Potential (WorldCover CN)
                          \                                                     /
                           +----------------------+----------------------------+
                                                  |
                                       [FastAPI Backend Engine]
                                - Model Inference Engine (6h, 12h, 24h)
                                - Dynamic Flood Susceptibility Synthesis
                                - SQLite Telemetry & Evaluation Store
                                                  |
                                       [React + Vite Frontend]
                                - Interactive GIS Leaflet Map Viewer
                                - Multi-Horizon Warning Banner & Charts
                                - Synoptic Station Telemetry & Settings
```

---

## 5. Project Directory Structure

```
rainfall-inundation-prediction/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   └── routes.py             # REST API routes (status, forecast, map layers, auth, telemetry)
│   │   ├── data/
│   │   │   ├── adapters/             # GFS, IMERG, IMD station, Radar, DEM, SAR adapters
│   │   │   ├── catalog.py            # Official dataset catalog (10 sources) & latency rules
│   │   │   └── pipeline.py           # Geospatial terrain modeling, TWI, and runoff calculations
│   │   ├── db/
│   │   │   └── database.py           # SQLite schema, provenance registry, and ORM layer
│   │   ├── ml/
│   │   │   ├── rainfall_model.py     # Multi-horizon Random Forest forecaster vs Persistence baseline
│   │   │   └── inundation_model.py   # Topographic flood susceptibility & SAR validation
│   │   ├── config.py                 # Study area bounding box and scaled IMD thresholds
│   │   └── main.py                   # FastAPI application initialization & CORS config
│   ├── data/                         # Data cache, raw, processed, and labels directories (.gitkeep)
│   ├── models/
│   │   └── artifacts/                # Trained Random Forest models (.joblib)
│   ├── tests/                        # Comprehensive unit & integration pytest suite
│   ├── .env.example                  # Environment template
│   └── requirements.txt              # Pinned Python dependencies
├── frontend/
│   ├── public/                       # Static brand assets and media
│   ├── src/
│   │   ├── components/               # Navbar, WarningBanner, MapViewer, Analytics, Modals
│   │   ├── services/
│   │   │   └── api.ts                # TypeScript backend API client
│   │   ├── types/
│   │   │   └── index.ts              # TypeScript interface definitions
│   │   ├── App.tsx                   # Main dashboard view
│   │   ├── index.css                 # Tailwind CSS declarations
│   │   └── main.tsx                  # React entrypoint
│   ├── package.json                  # Pinned frontend dependencies
│   ├── tailwind.config.js            # Tailwind theme configurations
│   ├── tsconfig.json                 # TypeScript compiler configurations
│   └── vite.config.js                # Vite build and development server config
├── docs/
│   ├── DATASET_CATALOGUE.md          # 10 official collections with citation and latency metadata
│   ├── MODEL_METHODOLOGY.md          # Mathematical formulations, TWI equations, and benchmark metrics
│   └── DATA_ACCESS_CHECKLIST.md      # Connection status and institutional access guidelines
├── run_dev.bat                       # 1-Click Windows Batch launcher
├── run_dev.ps1                       # 1-Click Windows PowerShell launcher
├── .gitignore                        # Comprehensive multi-stack ignore rules
└── README.md                         # Complete project documentation
```

---

## 6. Prerequisites & Installation

### Prerequisites
- **Python**: 3.11 or higher
- **Node.js**: 18.0 or higher (`npm` included)
- **Operating System**: Windows 10/11, Linux, or macOS

### Step-by-Step Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/RahulKr2005/rainfall-inundation-prediction.git
   cd rainfall-inundation-prediction
   ```

2. **Backend Setup**:
   ```powershell
   cd backend
   python -m venv .venv
   
   # Windows PowerShell:
   .\.venv\Scripts\Activate.ps1
   # Linux/macOS:
   # source .venv/bin/activate
   
   python -m pip install --upgrade pip
   pip install -r requirements.txt
   ```

3. **Frontend Setup**:
   ```powershell
   cd ../frontend
   npm install
   ```

---

## 7. Running the Application

### Option A: 1-Click Launch (Windows)
Double-click `run_dev.bat` or run in PowerShell:
```powershell
.\run_dev.ps1
```
This automatically verifies environments, boots FastAPI on port 8000 and Vite on port 5173, and launches your browser.

### Option B: Manual Startup

**Terminal 1 — Backend API**:
```powershell
cd backend
.\.venv\Scripts\activate
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

**Terminal 2 — Frontend UI**:
```powershell
cd frontend
npm run dev -- --host 127.0.0.1 --port 5173
```

- **Interactive UI Dashboard**: [http://127.0.0.1:5173](http://127.0.0.1:5173)
- **Backend REST API**: [http://127.0.0.1:8000](http://127.0.0.1:8000)
- **Interactive Swagger Documentation**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- **ReDoc Documentation**: [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)

---

## 8. Official Dataset Registry

| Source ID | Official Collection | Agency / Provider | Role in System | Resolution | Status |
|-----------|---------------------|-------------------|----------------|------------|--------|
| `NASA_GPM_IMERG` | GPM IMERG Precipitation | NASA | Input & Calibration | 0.1° (~10 km) / 30m | **CONNECTED** |
| `NOAA_GFS_NWP` | Global Forecast System | NOAA / NCEP | NWP Predictors | 0.25° (~27 km) / 3h | **CONNECTED** |
| `IMD_STATION_AWS` | Surface AWS Network | IMD Pune | Ground Truth & Validation | Point Gauges / Hourly | **CONNECTED** |
| `IMD_GRIDDED_RAINFALL` | 0.25° Daily Gridded Rainfall | IMD Pune | Historical Validation | 0.25° / 24h Daily | **CONNECTED** |
| `NASA_SRTM_DEM` | SRTM Elevation (SRTMGL1) | NASA / USGS | Topography & Slope | 1 arc-second (~30 m) | **CACHED PILOT** |
| `ESA_WORLDCOVER` | WorldCover 10m Land Cover | ESA | Impervious Surface & Runoff | 10 m / Annual | **CACHED PILOT** |
| `COPERNICUS_SENTINEL1` | Sentinel-1 SAR GRD | ESA Copernicus | Flood Extent Validation | 10 m / 6–12 days | **CACHED PILOT** |
| `NRSC_BHUVAN_DISASTER` | Disaster Management Support | ISRO NRSC | Historical Flood Baseline | 10–50 m / Event | **CACHED PILOT** |
| `ECMWF_ERA5` | ERA5 Reanalysis | ECMWF / Copernicus | Climatological Reference | 0.25° / 1h | **CONNECTED** |
| `IMD_DWR_RADAR` | Doppler Weather Radar | IMD | High-Res Rain Rate ($Z-R$) | 250m–1km / 10 min | **ADAPTER READY** |

*For complete collection metadata, latency constraints, and operational rules, see [docs/DATASET_CATALOGUE.md](docs/DATASET_CATALOGUE.md).*

---

## 9. Primary REST API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/status` | System health, RAM usage, and study area bounds |
| `GET` | `/api/forecast?horizon={6,12,24}` | Multi-horizon rainfall forecast and warning advisory |
| `GET` | `/api/map/layers?horizon={6,12,24}` | GeoJSON grid with DEM, TWI, Runoff, and Susceptibility |
| `GET` | `/api/catalog` | Metadata registry for all 10 official integrated datasets |
| `GET` | `/api/evaluation` | Continuous and categorical validation scores |
| `POST` | `/api/auth/login` | User authentication & role verification |
| `GET` | `/api/auth/me` | Fetch active user profile and preferences |
| `PUT` | `/api/auth/preferences` | Update user location, thresholds, and units |
| `GET` | `/api/analytics?days={7,14,30}` | Multi-period historical rainfall & alert frequency |
| `GET` | `/api/admin/telemetry` | Audit log counts, table telemetry, and system stats |
| `POST` | `/api/upload/station-csv` | Validate and ingest user-uploaded station CSV data |
| `GET` | `/api/bulletin/download` | Downloadable early warning research bulletin |

---

## 10. Verification & Test Suite

The backend includes a comprehensive pytest suite covering API contracts, scaled threshold math, lookahead leakage prevention, terrain calculus, and SAR metrics:

```powershell
cd backend
.\.venv\Scripts\python.exe -m pytest tests/ -v
```

**Verification Results**:
- `tests/test_api.py`: Status, catalog, forecast, map layers, evaluation, CSV upload, auth, analytics, telemetry (11 tests passed).
- `tests/test_config.py`: Scaled IMD 6h, 12h, and 24h thresholds (3 tests passed).
- `tests/test_models.py`: Random Forest vs Persistence baseline, zero lookahead leakage (2 tests passed).
- `tests/test_pipeline.py`: SRTM DEM finite difference gradient, TWI, WorldCover runoff CN, Sentinel-1 SAR spatial IoU (3 tests passed).
- **Total: 19 passed in 36 seconds (100% pass rate).**

Frontend Production Build Check:
```powershell
cd frontend
npm run build
```
Builds cleanly with Vite in ~35 seconds (`dist/` bundle verified).

---

## 11. Current Limitations & Future Scope

### Scientific Limitations & Disclaimer
1. **Flood Inundation Depth**:
   Digital Elevation Models (SRTM 30m) and empirical susceptibility indices (TWI/TFSI) predict **spatial flood likelihood**, not flood water depth. Accurately modeling water depth requires 2D shallow-water hydrodynamic solvers (such as HEC-RAS 2D, TELEMAC-2D, or EPA SWMM) with calibrated river cross-sections and stormwater pipe geometry. Water depth values are intentionally excluded to maintain scientific honesty.
2. **Doppler Radar Data Access**:
   Raw Level-II volumetric radar archives (UF/NetCDF formats) require formal institutional credentials from the IMD National Data Centre (Pune). The system includes a fully functional ingestion adapter with Marshall-Palmer conversion ($Z = 200 R^{1.6}$), pending official credentials.

### Future Scope
- Integration with OpenStreetMap urban stormwater drainage vector networks.
- Expansion of pilot study areas beyond Delhi-NCR to Mumbai, Chennai, and Bengaluru.
- Coupling with real-time Hathnikund Barrage discharge telemetry for riverine Yamuna flood routing.

---

## 12. Project Author & Citation

- **Author / Lead**: Rahul Kumar ([@RahulKr2005](https://github.com/RahulKr2005))
- **Project**: AI/ML-Based Integrated Heavy Rainfall Early Warning and Inundation Prediction System
- **Problem Statement ID**: SIH26071
- **Target Repository**: [https://github.com/RahulKr2005/rainfall-inundation-prediction](https://github.com/RahulKr2005/rainfall-inundation-prediction)
