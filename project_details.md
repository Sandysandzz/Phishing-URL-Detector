# Phishing URL Detection System — Project Details

---

## 1. Features of the Project

The Phishing URL Detection System is a complete machine learning pipeline with a web-based front end for real-time phishing URL classification. The key features are:

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Real-Time URL Classification** | Users enter a URL and instantly receive a verdict — *Legitimate* (✅ Green) or *Phishing* (⚠️ Red). |
| 2 | **Machine Learning–Based Detection** | Instead of relying on static blacklists, the system uses a trained Random Forest model to dynamically classify previously unseen URLs. |
| 3 | **Automated Feature Extraction** | Eight numerical features are automatically extracted from every URL (length, digit count, special characters, HTTPS presence, domain length, subdomain depth, path length, suspicious keywords). |
| 4 | **Web Interface (Flask)** | A clean, responsive HTML5/CSS3 interface served by a Flask backend lets any user analyze URLs without command-line knowledge. |
| 5 | **Model Comparison Pipeline** | The project includes scripts that train and compare **Random Forest** and **Logistic Regression** side-by-side, using Accuracy, Precision, Recall, and F1-Score. |
| 6 | **Comprehensive Model Evaluation** | Evaluation scripts generate a full set of performance visualizations: Confusion Matrix, ROC Curve, Precision-Recall Curve, Feature Importance chart, and F1-Score bar graph. |
| 7 | **Cross-Validation** | 5-fold cross-validation is performed during training to ensure the model generalizes well and is not overfitting. |
| 8 | **Prediction Logging** | Predictions are logged to `predictions_log.csv` for auditing and review. |
| 9 | **URL Normalization** | Trailing slashes are stripped so that `site.com` and `site.com/` are treated identically, improving consistency. |
| 10 | **Modular & Maintainable Codebase** | Feature extraction, model training, model evaluation, and the web server are separated into distinct Python modules for clarity and reuse. |

---

## 2. Algorithms Used — What, Why, and How They Work

### 2.1 Random Forest Classifier (Primary Algorithm)

**What it is:**
Random Forest is a *supervised ensemble learning* algorithm. It constructs a collection (forest) of Decision Trees during training and outputs the class that is the **majority vote** of the individual trees.

**Why it was chosen:**
| Reason | Explanation |
|--------|-------------|
| High Accuracy | Handles the non-linear relationships among URL features effectively. |
| Robustness to Overfitting | By averaging many independent trees, variance is reduced compared to a single Decision Tree. |
| Mixed Feature Support | Works naturally with both continuous features (e.g., `url_length`) and binary features (e.g., `has_https`). |
| Fast Inference | Predictions are essentially parallel tree look-ups, making it ideal for a real-time web application. |
| Feature Importance | Provides a built-in mechanism to rank which features contribute most to the classification. |

**How it works (step-by-step):**
1. **Bootstrap Sampling** — For each tree, a random sample (with replacement) of the training data is drawn.
2. **Tree Construction** — Each tree is grown by selecting the best split from a random subset of features at every node, using criteria like Gini Impurity.
3. **Ensemble Voting** — At prediction time, every tree independently classifies the input URL. The final prediction is the **majority vote** across all trees.
4. **Probability Output** — The proportion of trees that voted for a given class is returned as its probability, enabling ROC and Precision-Recall analysis.

```
URL → Feature Extraction → [Tree 1: Phishing]
                           [Tree 2: Legitimate]
                           [Tree 3: Phishing]
                           ...
                           [Tree N: Phishing]
                           → Majority Vote → Final Prediction: Phishing
```

**Configuration used:**
```python
RandomForestClassifier(random_state=42)   # Scikit-learn default 100 trees
```

---

### 2.2 Logistic Regression (Comparison Baseline)

**What it is:**
Logistic Regression is a *linear classification* algorithm. It models the probability of the positive class (Phishing) using a logistic (sigmoid) function applied to a linear combination of the input features.

**Why it was included:**
It serves as a **baseline** to compare against Random Forest. If a simple linear model performs almost as well, the added complexity of Random Forest would not be justified. In practice, Random Forest **outperformed** Logistic Regression on this feature set, validating its selection.

**How it works:**
1. Computes a weighted sum of the input features: `z = w₁x₁ + w₂x₂ + ... + wₙxₙ + b`
2. Passes the result through the **sigmoid function**: `P(Phishing) = 1 / (1 + e⁻ᶻ)`
3. If `P(Phishing) ≥ 0.5`, the URL is classified as Phishing; otherwise, Legitimate.
4. Weights are learned by minimizing the **log-loss** (cross-entropy) during training.

**Configuration used:**
```python
LogisticRegression(max_iter=1000)
```

---

### 2.3 Feature Extraction Algorithm (Heuristic / Rule-Based)

The feature extraction is a **custom, rule-based algorithm** that transforms a raw URL string into an 8-dimensional numerical vector. This is a critical preprocessing step that enables the ML model to operate on structured data.

**Features extracted:**

| Feature | Type | Extraction Logic |
|---------|------|------------------|
| `url_length` | Integer | `len(url)` — total character count |
| `num_digits` | Integer | Count of digit characters (0-9) in the URL |
| `num_special_chars` | Integer | Count of non-alphanumeric characters |
| `has_https` | Binary (0/1) | `1` if URL starts with `https://`, else `0` |
| `domain_length` | Integer | Length of the domain portion (parsed from the URL) |
| `subdomain_count` | Integer | Number of dots in the domain minus one |
| `path_length` | Integer | Length of the URL path after the domain |
| `has_suspicious_keyword` | Binary (0/1) | `1` if URL contains any of: `login`, `secure`, `account`, `update`, `confirm` |

**Design rationale:**
- Phishing URLs tend to be *longer* than legitimate ones (to mimic real domains).
- Phishing sites use *more digits* (e.g., random IDs, IP-based domains).
- Excessive *special characters* (e.g., `@`, `-`, `.`) are a common phishing indicator.
- Lack of *HTTPS* may signal a less trustworthy site.
- *Suspicious keywords* like "login" or "confirm" are commonly used in social engineering URLs.

---

### 2.4 Model Evaluation Algorithms / Metrics

| Metric / Technique | Purpose |
|---------------------|---------|
| **Accuracy** | Overall percentage of correct predictions |
| **Precision** | Proportion of predicted-phishing URLs that are truly phishing (minimizes false alarms) |
| **Recall** | Proportion of actual phishing URLs that the model catches (minimizes missed threats) |
| **F1-Score** | Harmonic mean of Precision and Recall — balances both concerns |
| **ROC-AUC** | Area Under the ROC Curve — measures the model's ability to discriminate between classes across all thresholds |
| **Average Precision** | Area under the Precision-Recall curve — important for imbalanced datasets |
| **Confusion Matrix** | Breaks down True Positives, True Negatives, False Positives, and False Negatives |
| **5-Fold Cross-Validation** | Splits data into 5 folds, trains on 4 and tests on 1 (rotated), to estimate generalization performance |
| **Feature Importance** | Built-in Random Forest metric that ranks features by their contribution to classification decisions |

---

## 3. Datasets Used

### 3.1 Training Dataset
| Property | Detail |
|----------|--------|
| **Legitimate URLs file** | `legitimate_urlss.csv` |
| **Phishing URLs file** | `phishing_urlss.csv` |
| **Location** | `C:/Users/Sharan/Downloads/dataset/` |
| **Structure** | Each CSV contains a `url` column with raw URL strings |
| **Labeling** | Legitimate = `0`, Phishing = `1` (assigned during feature extraction) |

### 3.2 Test Dataset
| Property | Detail |
|----------|--------|
| **Legitimate test URLs file** | `test_legitimate_urls.csv` |
| **Phishing test URLs file** | `test_phishing_urls.csv` |
| **Combined test file** | `test_data_phishing_urls.csv` (with a `type` column for labels) |
| **Location** | `C:/Users/Sharan/Downloads/dataset/` |

### 3.3 Data Characteristics
- The dataset contains **thousands of labeled URLs** spanning both legitimate and phishing categories.
- Legitimate URLs are sourced from open-source repositories of top-ranking websites.
- Phishing URLs are sourced from verified phishing URL repositories (e.g., PhishTank, UCI ML Repository).
- The data is used **strictly for academic purposes**; no personal or live user data is involved.

---

## 4. Programming Languages Used

| Language | Usage in the Project |
|----------|----------------------|
| **Python** | Core language for the entire project — machine learning (scikit-learn), data processing (pandas, numpy), web server (Flask), model serialization (joblib), evaluation & visualization (matplotlib, seaborn). |
| **HTML5** | Frontend markup for the web interface (`index.html`) — form inputs, buttons, and result display containers. |
| **CSS3** | Styling the web interface — gradient backgrounds, card layout with glassmorphism, responsive design, hover transitions, and result color-coding (green for safe, red for phishing). |
| **JavaScript** | Client-side logic embedded within `index.html` — handles the asynchronous `fetch` POST request to the `/predict` endpoint, parses the JSON response, and dynamically updates the DOM with the result. |

### Key Libraries & Frameworks

| Library / Framework | Version / Type | Role |
|---------------------|---------------|------|
| `Flask` | Python web framework | Serves the HTML frontend and exposes the `/predict` REST API endpoint |
| `scikit-learn` | ML library | Provides `RandomForestClassifier`, `LogisticRegression`, metrics, and cross-validation |
| `pandas` | Data manipulation | Loads CSV datasets, applies feature extraction, normalizes feature dictionaries into DataFrames |
| `numpy` | Numerical computing | Supports array operations in evaluation scripts |
| `joblib` | Serialization | Saves and loads the trained model as `random_forest_model.pkl` |
| `matplotlib` | Visualization | Generates ROC Curve, Precision-Recall Curve, Feature Importance, and F1-Score plots |
| `seaborn` | Visualization | Renders the Confusion Matrix heatmap |

---

## 5. Where Are the Algorithms Implemented — File-by-File Breakdown

### 5.1 Active (Production) Code

| File | Path | Purpose |
|------|------|---------|
| **`features.py`** | `src/features.py` | Contains the **Feature Extraction Algorithm**. The `extract_features(url)` function takes a raw URL and returns a dictionary of 8 numerical features. Also includes `extract_features_df(url)` wrapper for single-instance prediction. |
| **`train_model.py`** | `src/train_model.py` | Contains the **Random Forest Training Pipeline**. Loads training and test CSVs, calls `extract_features`, trains `RandomForestClassifier`, saves the model to `models/random_forest_model.pkl`, and evaluates on the test set. |
| **`app.py`** | `src/app.py` | Contains the **Flask Web Server** and **Prediction API**. Loads the trained `.pkl` model, serves the HTML frontend at `/`, and handles POST requests at `/predict` to classify user-submitted URLs. |
| **`index.html`** | `src/templates/index.html` | Contains the **Frontend UI and Client-Side JavaScript**. The HTML form collects URLs, and the embedded JavaScript sends asynchronous requests and renders results. |
| **`random_forest_model.pkl`** | `models/random_forest_model.pkl` | The **serialized trained Random Forest model** (~9 MB) used by the Flask app for inference. |

### 5.2 Legacy / Supplementary Code

| File | Path | Purpose |
|------|------|---------|
| **`training.py`** | `src/legacy/training.py` | Original monolithic training + evaluation script (includes both training and test phases in a single file). |
| **`compare.py`** | `src/legacy/compare.py` | **Algorithm Comparison Script**. Trains both **Random Forest** and **Logistic Regression** on the same data with an 80/20 train-test split, and prints a side-by-side comparison of Accuracy, Precision, Recall, and F1-Score. |
| **`evaluate.py`** | `src/legacy/evaluate.py` | **Advanced Evaluation Script**. Performs 5-fold cross-validation, tests on separate test data, and computes Average Precision and mAP@50-95 metrics. |
| **`model_evaluate.py`** | `src/legacy/model_evaluate.py` | **Visualization Evaluation Script**. Generates Confusion Matrix, ROC Curve, Precision-Recall Curve, Feature Importance, and F1-Score plots using matplotlib and seaborn. |
| **`model_inference.py`** | `src/legacy/model_inference.py` | **Standalone Inference Script**. Loads the model, predicts a sample URL, prints feature importance rankings, and reports cross-validation mean accuracy. |
| **`debug_features.py`** | `debug_features.py` | Debugging utility to verify feature extraction logic on sample URLs. |
| **`test_normalization.py`** | `test_normalization.py` | Tests the URL normalization (trailing slash stripping) logic. |

### 5.3 Other Files

| File | Purpose |
|------|---------|
| `requirements.txt` | Lists Python dependencies: `flask`, `pandas`, `scikit-learn`, `joblib`, `numpy` |
| `predictions_log.csv` | Log of past predictions for auditing |
| `confusion_matrix.png` | Pre-generated Confusion Matrix visualization |
| `roc_curve.png` | Pre-generated ROC Curve visualization |
| `precision_recall_curve.png` | Pre-generated Precision-Recall Curve |
| `feature_importance.png` | Pre-generated Feature Importance bar chart |
| `phishing_report.md` | Full project report (Introduction, Abstract, Workflow, etc.) |
| `MINI_PROJECT_FINALppt[1].pptx` | Project presentation slide deck |
| `Phishing_URL_Detection_Viva_QA.docx` | Viva Q&A preparation document |

---

## 6. Different AI / ML Uses in the Project

The project demonstrates multiple aspects of Artificial Intelligence and Machine Learning applied to cybersecurity:

### 6.1 Supervised Classification (Core AI Use)
- **What:** The primary AI task is **binary classification** — distinguishing phishing URLs from legitimate ones.
- **How:** A labeled dataset of known phishing and legitimate URLs is used to train a supervised model (Random Forest). The model learns statistical patterns that separate the two classes.
- **Where:** `src/train_model.py`, `src/legacy/training.py`

### 6.2 Ensemble Learning
- **What:** Random Forest is an **ensemble method** — it combines the predictions of many weak learners (Decision Trees) to produce a stronger, more reliable classifier.
- **How:** Each tree is trained on a different bootstrap sample and a random subset of features, reducing correlation between trees and improving generalization.
- **Where:** `src/train_model.py` → `RandomForestClassifier(random_state=42)`

### 6.3 Feature Engineering for Natural Language Inputs
- **What:** Raw URL strings (unstructured text) are converted into structured numerical features through **hand-crafted heuristic rules** — a key AI preprocessing technique.
- **How:** Domain knowledge about phishing patterns (long URLs, suspicious keywords, lack of HTTPS) is encoded into extraction functions.
- **Where:** `src/features.py` → `extract_features(url)`

### 6.4 Model Evaluation & Selection
- **What:** Multiple ML models are trained and their performances are **compared** using standard metrics to select the best one.
- **How:** Random Forest and Logistic Regression are evaluated on the same dataset using Accuracy, Precision, Recall, and F1-Score. Random Forest was selected as the winner.
- **Where:** `src/legacy/compare.py`

### 6.5 Cross-Validation
- **What:** **K-Fold Cross-Validation** (k=5) is used to estimate the model's real-world performance and detect overfitting.
- **How:** The training data is split into 5 folds; the model is trained on 4 folds and tested on the remaining 1, rotating 5 times.
- **Where:** `src/legacy/evaluate.py` → `cross_val_score(rf_model, X_train, y_train, cv=5)`

### 6.6 Real-Time ML Inference via API
- **What:** The trained model is deployed as a **REST API** that performs real-time predictions on user-submitted URLs.
- **How:** Flask serves a `/predict` endpoint. The submitted URL is feature-extracted and passed to the loaded `.pkl` model, which returns its prediction instantly.
- **Where:** `src/app.py` → `/predict` route

### 6.7 Model Interpretability (Feature Importance)
- **What:** The system provides **explainability** by ranking which features contribute most to the model's decisions.
- **How:** Random Forest's built-in `feature_importances_` attribute is used to generate a bar chart showing each feature's importance score.
- **Where:** `src/legacy/model_evaluate.py`, `src/legacy/model_inference.py`

### 6.8 Performance Visualization & Diagnostics
- **What:** Standard ML evaluation visualizations are generated for thorough model diagnostics.
- **How:** Confusion Matrix (with seaborn heatmap), ROC Curve (with AUC score), Precision-Recall Curve (with Average Precision), and F1-Score bar graph are plotted using matplotlib.
- **Where:** `src/legacy/model_evaluate.py`

---

## Summary Table

| Aspect | Details |
|--------|---------|
| **Project Type** | ML-based Cybersecurity Application |
| **Primary Algorithm** | Random Forest Classifier |
| **Comparison Algorithm** | Logistic Regression |
| **Feature Extraction** | 8 heuristic URL features (length, digits, special chars, HTTPS, domain, subdomains, path, keywords) |
| **Dataset** | Labeled CSV files of legitimate and phishing URLs |
| **Languages** | Python, HTML5, CSS3, JavaScript |
| **ML Framework** | scikit-learn |
| **Web Framework** | Flask |
| **Model File** | `models/random_forest_model.pkl` (~9 MB) |
| **AI Techniques** | Supervised Classification, Ensemble Learning, Feature Engineering, Cross-Validation, Model Comparison, Real-Time Inference, Feature Importance (Explainability) |

---
