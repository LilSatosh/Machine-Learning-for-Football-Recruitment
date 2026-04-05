# Machine-Learning-for-Football-Recruitment
# Football Tactical Role Discovery (2024/25)

Machine learning framework for discovering and validating tactical player 
roles from performance data across the Top 5 European Leagues (2024/25).

#Project Overview
Traditional positional labels (DF/MF/FW) fail to capture modern hybrid 
roles. This project uses FBref and Transfermarkt data to:
1. Validate traditional labels using supervised classifiers (LR, DT, SVM)
2. Discover data-driven tactical archetypes via UMAP + HDBSCAN clustering
3. Interpret each archetype using SHAP analysis
4. Deliver findings via a cosine similarity player recommendation engine

# Repository Structure
 `notebooks/dataset_preparations.ipynb` 
 `scripts/transmarket_data.R` 
 `notebooks/tm_dob.ipynb` 
 `scripts/fbref_transmkrt_merge.R` 
 `notebooks/initial_classification_and_clustering.ipynb` 
 `notebooks/classification_on_hdbscan_clusters.ipynb` 

# Execution Order
Run the pipeline in this exact order:
1. `transmarket_data.R`
2. `dataset_preparations.ipynb`
3. `tm_dob.ipynb`
4. `fbref_transmkrt_merge.R`
5. `initial_classification_and_clustering.ipynb`
6. `classification_on_hdbscan_clusters.ipynb`

# Data Sources
- Standard stats: https://fbref.com/en/comps/Big5/2024-2025/stats/players/
- Defensive stats: https://fbref.com/en/comps/Big5/2024-2025/defense/players/
- Market values: Transfermarkt via worldfootballR

## Dependencies
**Python**
pip install pandas numpy scikit-learn matplotlib seaborn umap-learn hdbscan shap lightgbm xgboost yellowbrick scipy

**R**
install.packages(c("worldfootballR", "tidyverse"))
