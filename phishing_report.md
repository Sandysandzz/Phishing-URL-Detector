# Project Report: Phishing URL Detection System

## Introduction
The rapid expansion of the internet has led to a significant increase in cyber threats, with phishing being one of the most prevalent forms of social engineering attacks. Phishing involves malicious actors creating deceptive websites to steal sensitive information such as login credentials, financial details, and personal data. Traditional detection methods, which largely rely on static blacklists, are often reactive and fail to protect users from newly created or zero-day phishing sites.

This project introduces a **Machine Learning-based Phishing URL Detection System** designed to identify malicious URLs in real-time based on their structural and lexical characteristics. By leveraging a Random Forest Classifier, the system provides a dynamic and proactive security solution that operates independently of known-bad databases. The application is delivered via a user-friendly web interface powered by the Flask framework.

## Abstract
This project addresses the critical need for real-time detection of phishing URLs. Unlike static blacklist approaches, we implemented a supervised Machine Learning pipeline that analyzes the intrinsic properties of a URL. The system extracts a set of heuristic features—such as URL length, presence of special characters, and domain characteristics—to distinguish between legitimate and phishing links.

The core classification engine uses the **Random Forest algorithm**, selected for its high accuracy and robustness against overfitting. The model was trained on a balanced dataset of legitimate and phishing URLs. The outcome is a lightweight, responsive web application that accepts a user-provided URL and outputs a binary classification ("Legitimate" or "Phishing") with high confidence.

## Workflow
The system follows a structured pipeline from data input to final prediction. The complete workflow is described below:

### 1. Input Data Flow
The process begins when a user enters a specific URL into the search bar of the web interface. This string is transmitted to the backend Flask server via a secure HTTP POST request.

### 2. Preprocessing
Upon receiving the URL, the system performs basic preprocessing to ensure consistency:
- **Normalization**: content input is stripped of trailing slashes (e.g., `site.com/` becomes `site.com`) to treat variations of the same URL identically.

### 3. Feature Extraction
The raw URL is transformed into a numerical feature vector. The extraction logic works as follows:
- **Lexical Features**:
  - `url_length`: Total number of characters in the URL.
  - `num_digits`: Count of numeric characters (0-9).
  - `num_special_chars`: Count of non-alphanumeric characters.
  - `has_https`: Binary indicator (1 if HTTPS is present, else 0).
- **Domain-Based Features**:
  - `domain_length`: Length of the primary domain part.
  - `subdomain_count`: Number of dots in the domain, indicating subdomain depth.
- **Path-Based Features**:
  - `path_length`: Length of the resource path after the domain.
  - `has_suspicious_keyword`: Binary indicator checking for common phishing terms (e.g., "login", "secure", "account", "update", "confirm").

These extracted values form a structured row (DataFrame) that serves as the input for the machine learning model.

### 4. Classification Algorithm
The extracted feature vector is passed to the **Random Forest Classifier**.
- The model consists of multiple decision trees that independently analyze the features.
- It aggregates the votes from individual trees (ensemble learning) to make a robust prediction.
- If the majority of trees classify the input as malicious, the model outputs `1` (Phishing); otherwise, it outputs `0` (Legitimate).

### 5. Prediction Logic and Output
The binary output from the classifier is mapped to a human-readable label:
- **0 -> Legitimate** (Displayed in Green)
- **1 -> Phishing** (Displayed in Red)

This result is sent back to the frontend and displayed to the user instantly.

## Dataset
The model was trained on a comprehensive dataset specifically curated for phishing detection tasks.
- **Data Sources**: The dataset combines legitimate URLs (e.g., from open-source repositories of top-ranking websites) and verified phishing URLs (e.g., from PhishTank or similar repositories).
- **Structure**: The raw data consists of URL strings labeled as `0` (Legitimate) or `1` (Phishing).
- **Usage**: The data was split into training and testing sets to validate the model's performance.

## Algorithms Used
The project utilizes the **Random Forest Classifier** as the primary detection algorithm.

**Why Random Forest?**
1.  **High Accuracy**: It effectively handles non-linear relationships between URL features.
2.  **Robustness**: By averaging multiple decision trees, it reduces the risk of overfitting compared to single Decision Trees.
3.  **Feature Handling**: It works well with the mix of continuous (lengths) and binary (flags) features extracted from the URLs.
4.  **Performance**: It offers fast prediction times suitable for a real-time web application.

A comparison was initially considered with **Logistic Regression**, but Random Forest was chosen for its superior performance on this specific feature set.

## Detection / Working Method
The detection method relies purely on **heuristic analysis** of the URL string. It does not inspect the content of the webpage (e.g., HTML source, images).
1.  **Static Analysis**: The code analyzes the string patterns without visiting the site, making it safe and fast.
2.  **Feature Engineering**: The core "intelligence" lies in the selected features (e.g., phishing sites often have long URLs, multiple subdomains, or suspicious keywords like "confirm-account").
3.  **Supervised Learning**: The model learns the statistical correlation between these features and the "Phishing" label during the training phase.

## Output and Performance
The system's performance was evaluated using standard metrics on a held-out test set.

- **Accuracy**: The model demonstrates high classification accuracy, correctly identifying the majority of legitimate and phishing links.
- **Precision**: High precision ensures a low False Positive Rate (legitimate sites are rarely flagged as phishing).
- **Recall**: High recall ensures a low False Negative Rate (phishing sites are rarely missed).

*Visualizations generated during training (Confusion Matrix, ROC Curve, Feature Importance) validate the model's effectiveness.*

## Limitations
While effective, the current system has identified limitations:
1.  **URL-Only Dependencies**: The model only analyzes the URL string. Sophisticated phishing attacks hosted on compromised legitimate domains (short URLs) might be misclassified.
2.  **Shortened URLs**: URL shorteners (e.g., bit.ly) mask the true structure of the URL, potentially bypassing the feature extraction logic.
3.  **Static Dataset**: The model's knowledge is limited to the patterns present in the training dataset. New, evolving phishing trends may require retraining.

**Future Improvements**:
- Integration of a "URL Expander" to resolve shortened links before analysis.
- Adding content-based features (e.g., checking for forms or logos on the target page) for hybrid detection.
- Implementing an automated retraining pipeline to update the model with fresh phishing feeds.

## References
1.  Scikit-Learn Documentation: Ensemble Methods (Random Forest).
2.  Flask Web Framework Documentation.
3.  Pandas Library for Data Analysis.
4.  UCI Machine Learning Repository (Reference for Phishing Datasets).

## Conclusion
The **Phishing URL Detection System** successfully demonstrates the application of Machine Learning in cybersecurity. By automating the analysis of URL characteristics, the project provides a fast, accurate, and user-friendly tool to help users identify potential threats. The use of Random Forest ensures robust performance, making this a reliable prototype for enhanced web security.
