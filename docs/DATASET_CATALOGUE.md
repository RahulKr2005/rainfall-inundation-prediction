# Official Dataset Catalogue & Provenance Metadata

This registry documents the 10 official satellite, radar, observational, NWP, and geospatial elevation/land-cover datasets integrated or adapted in the system.

---

| Source ID | Official Name | Official URL | Role | Status | Spatial Res | Temporal Res |
|-----------|---------------|--------------|------|--------|-------------|--------------|
| **NASA_GPM_IMERG** | NASA GPM IMERG Precipitation | [https://gpm.nasa.gov/data/imerg](https://gpm.nasa.gov/data/imerg) | Input & Validation | CONNECTED | 0.1° (~10 km) | 30 min (Early ~4h, Late ~14h, Final ~3.5 mo) |
| **IMD_GRIDDED_RAINFALL** | IMD 0.25° Daily Gridded Rainfall | [https://www.imdpune.gov.in/](https://www.imdpune.gov.in/) | Validation Reference | CONNECTED | 0.25° (~27 km) | 24-hour daily cumulative (08:30 to 08:30 IST) |
| **IMD_STATION_AWS** | IMD Surface AWS Observations | [https://dsp.imdpune.gov.in/](https://dsp.imdpune.gov.in/) | Input & Target | CONNECTED | Point Stations (Safdarjung, Palam, Ridge, etc.) | Hourly & 15-minute |
| **IMD_DWR_RADAR** | IMD Doppler Weather Radar | [https://mausam.imd.gov.in/responsive/radar.php](https://mausam.imd.gov.in/responsive/radar.php) | Input (Adapter Ready) | PENDING CREDENTIALS | 250 m – 1 km | 10–15 min volume scan |
| **NOAA_GFS_NWP** | NOAA Global Forecast System | [https://nomads.ncep.noaa.gov/](https://nomads.ncep.noaa.gov/) | Input Predictors | CONNECTED | 0.25° (~27 km) | 1h to 3h up to 120h lead time |
| **ECMWF_ERA5** | ECMWF ERA5 Reanalysis | [https://cds.climate.copernicus.eu/](https://cds.climate.copernicus.eu/) | Historical Baseline | CONNECTED | 0.25° (~27 km) | 1 hour (~5-day latency) |
| **NASA_SRTM_DEM** | NASA SRTM Elevation (SRTMGL1) | [https://www.earthdata.nasa.gov/](https://www.earthdata.nasa.gov/) | Topographic Input | CACHED PILOT | 1 arc-second (~30 m) | Static mission baseline |
| **ESA_WORLDCOVER** | ESA WorldCover 10m | [https://esa-worldcover.org/en/data-access](https://esa-worldcover.org/en/data-access) | Runoff Potential | CACHED PILOT | 10 m (aggregated to 100m) | Annual static |
| **COPERNICUS_SENTINEL1** | Copernicus Sentinel-1 SAR | [https://dataspace.copernicus.eu/](https://dataspace.copernicus.eu/) | Flood Extent Label | CACHED PILOT | 10 m pixel spacing | 6–12 days repeat cycle |
| **NRSC_BHUVAN_DISASTER** | ISRO NRSC Bhuvan Disaster Services | [https://bhuvan-app1.nrsc.gov.in/](https://bhuvan-app1.nrsc.gov.in/) | Flood Extent Label | CACHED PILOT | 10 m – 50 m vector/raster | Event activations (July 2023 flood) |

---

## Operational Latency and Lookahead Rules

1. **NASA GPM IMERG**:
   - Operational early warning experiments **must** use the **Early** or **Late** runs.
   - The **Final** run includes retrospective monthly rain-gauge adjustments and is strictly reserved for historical validation; using Final in operational early warning constitutes data leakage.

2. **IMD Gridded Rainfall**:
   - Released daily at ~11:00 IST for the preceding 24-hour cycle.
   - **Rule**: Daily observations are never interpolated into synthetic hourly rainfall values.

3. **IMD Doppler Weather Radar**:
   - Public web portal provides lossy 8-bit PNG images which cannot be converted to reliable numerical dBZ fields.
   - The adapter implements the schema for raw volumetric UF/NetCDF files with Marshall-Palmer $Z = 200 R^{1.6}$ relation.
   - Marked as `PENDING_OFFICIAL_ARCHIVE` until institutional credentials/data files are provided.

4. **ECMWF ERA5 vs NOAA GFS**:
   - ERA5 is a retrospective reanalysis with ~5-day latency and is **never** silently substituted for operational GFS forecasts.
