# Official Data Access Checklist & Action Items

| Dataset | Connection Status | Required Action / Blocker | User Action Needed? |
|---------|-------------------|---------------------------|---------------------|
| **NOAA GFS NWP** | **CONNECTED** | Operating via Open-Meteo GFS 0.25° public mirror | None (Automated) |
| **NASA GPM IMERG** | **CONNECTED** | Early/Late/Final runs ingested; Delhi-NCR pilot cached | Optional: Add Earthdata login in `.env` for bulk retrospective sync |
| **IMD AWS Observations** | **CONNECTED** | Hourly Delhi network active; QC validator active | None (Public synoptic feed + local CSV import ready) |
| **NASA SRTM 30m DEM** | **CACHED PILOT** | Tile N28E077 processed; TWI & slope generated | None (Offline cached) |
| **ESA WorldCover 10m** | **CACHED PILOT** | Land cover classes and runoff coefficients calibrated | None (Offline cached) |
| **Copernicus Sentinel-1** | **CACHED PILOT** | July 2023 Yamuna flood SAR mask calibrated | None (Offline cached) |
| **ISRO Bhuvan Disaster** | **CACHED PILOT** | Yamuna flood hazard reference integrated | None (Reference mapped) |
| **ECMWF ERA5** | **CONNECTED** | 1991-2020 Delhi monsoon climatological baseline mapped | None (Baseline cached) |
| **IMD Gridded Rainfall** | **CONNECTED** | 0.25° daily validation grid calibrated | None (Validation target active) |
| **IMD Doppler Radar** | **PENDING CREDENTIALS** | Official numerical level-II volume archives (UF/NetCDF) require formal institutional requisition to IMD National Data Centre (Pune) | **Yes**: Formal data requisition needed if official raw volumetric radar files are desired; local NetCDF/GeoTIFF upload adapter is fully operational. |
