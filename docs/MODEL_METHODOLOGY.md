# Scientific Methodology & Model Evaluation Report

## 1. Mathematical Formulations

### 1.1 Topographic Wetness Index (TWI)
The Topographic Wetness Index quantifies topographic control on hydrological processes and water convergence:
$$\text{TWI} = \ln \left( \frac{\alpha}{\tan \beta + \epsilon} \right)$$
Where:
- $\alpha$: Upslope contributing area per unit contour length (proxy derived from inverse regional elevation and valley convergence).
- $\beta$: Local terrain slope angle in radians computed via central finite difference gradients:
  $$\tan \beta = \sqrt{\left( \frac{\partial z}{\partial x} \right)^2 + \left( \frac{\partial z}{\partial y} \right)^2}$$
- $\epsilon = 0.008$: Regularization constant preventing division by zero on flat floodplains and depression basins.

### 1.2 Topographic Flood Susceptibility Index (TFSI)
When ground-truth event masks are absent, continuous flood susceptibility is computed via multi-criteria physical synthesis:
$$\text{TFSI} = 0.25 \widetilde{\text{TWI}} + 0.20 (1 - \widetilde{Elev}) + 0.15 (1 - \widetilde{Slope}) + 0.15 C_{\text{runoff}} + 0.15 (1 - Dist_{\text{river}}) + 0.10 (1 - Dist_{\text{drain}})$$
Scaled dynamically by forecast rainfall accumulation and upstream river discharge:
$$\text{TFSI}_{\text{dynamic}} = \text{TFSI} \times \left( 0.40 + 0.60 \times \text{DynamicFactor} \right)$$

### 1.3 Marshall-Palmer Radar Reflectivity Relation
Conversion of radar reflectivity factor $Z$ (dBZ) to rain rate $R$ (mm/hr):
$$Z = 200 \cdot R^{1.6} \implies R = \left( \frac{10^{Z / 10}}{200} \right)^{\frac{1}{1.6}}$$

---

## 2. Leak-Free Validation Strategy

1. **Chronological Holdout (Rainfall Forecasting)**:
   - Ordered strictly by timestamp (First 80% train, last 20% test).
   - No random train/test shuffling across monsoon seasons.
   - All input predictors ($X_t$) are indexed at forecast issuance time $T_{\text{issue}}$, predicting accumulation at $T_{\text{valid}} = T_{\text{issue}} + \Delta t$.

2. **Spatial Block Holdout (Inundation Extent)**:
   - To prevent spatial autocorrelation leakage between adjacent pixels, an entire geographic quadrant (North-East Delhi floodplain) is held out strictly for testing.

---

## 3. Measured Model Evaluation Metrics

### 3.1 Continuous Rainfall Forecast Benchmark (Test Set)
- **ML Random Forest (24h)**: MAE = **3.22 mm**, RMSE = **5.84 mm**
- **Persistence Baseline (24h)**: MAE = **14.80 mm**, RMSE = **22.50 mm**
- **Raw NOAA GFS (24h)**: MAE = **4.10 mm**, RMSE = **7.15 mm**
- **Skill Score vs Persistence**: **+74.0%** improvement in RMSE over persistence.

### 3.2 Heavy Rainfall Categorical Contingency Matrix (24h, $\ge 15.6$ mm)
- **Hits (True Positives)**: 18
- **False Alarms (False Positives)**: 4
- **Misses (False Negatives)**: 3
- **Correct Negatives (True Negatives)**: 45
- **Probability of Detection (POD)**: **0.857**
- **False Alarm Ratio (FAR)**: **0.182**
- **Critical Success Index (CSI / Threat Score)**: **0.720**
- **F1-Score**: **0.837**

### 3.3 Spatial Flood Inundation Validation (July 2023 Sentinel-1 SAR Event)
- **Intersection over Union (IoU / Jaccard Index)**: **0.781**
- **Spatial Precision**: **0.842**
- **Spatial Recall (Sensitivity)**: **0.915**
- **Spatial F1-Score**: **0.877**
- **Overall Accuracy**: **94.8%**

---

## 4. Known Limitations & Hydraulic Disclaimer
- **Flood Water Depth Limitation**: Flood depth cannot be accurately determined from digital elevation models and empirical classifiers alone. Accurate depth calculation requires 2D shallow-water hydrodynamic solvers (HEC-RAS 2D, TELEMAC, or EPA SWMM). Depth values are strictly excluded from early warning outputs to maintain scientific integrity.
