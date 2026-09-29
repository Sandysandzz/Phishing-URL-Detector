1. Project Overview

Phishing attacks are one of the most common cybersecurity threats, where malicious websites impersonate legitimate services to steal sensitive user information.
This project presents a machine learning–based system that detects whether a given URL is phishing or legitimate by analyzing its structural and lexical features.

Unlike blacklist-based approaches, this system classifies URLs dynamically using a trained Machine Learning model, enabling detection of previously unseen phishing links.

2. Problem Statement

Traditional phishing detection techniques rely heavily on static blacklists, which fail to detect newly created or modified phishing URLs.
There is a need for an intelligent system that can analyze URL characteristics and predict malicious intent in real time.

This project aims to address this problem using Machine Learning classification techniques.

3. Objectives

To design a system that detects phishing URLs using Machine Learning

To extract meaningful features from URLs for classification

To compare multiple ML algorithms and select the best-performing model

To provide a user-friendly web interface for real-time prediction

To demonstrate a complete cybersecurity ML pipeline for academic evaluation

4. System Architecture

The system follows a three-layer architecture:

Frontend Layer

HTML5 and CSS3-based web interface

Accepts user input (URL) and displays results

Backend Layer

Flask-based Python application

Handles HTTP requests and processes input URLs

Machine Learning Layer

Trained Random Forest Classifier

Performs phishing classification based on extracted features

5. Dataset Description

The model is trained on a dataset containing thousands of labeled URLs

URLs are categorized as phishing or legitimate

Dataset is publicly available and used strictly for academic purposes

No personal or live user data is involved

6. Feature Extraction

The following features are extracted from each URL:

URL length

Presence of suspicious keywords (e.g., login, verify, update)

Use of IP address instead of domain name

Count of special characters such as @, ., and /

Domain and path structure analysis

These features are converted into numerical values and passed to the ML model.

7. Machine Learning Models Used

The following algorithms were implemented and evaluated:

Logistic Regression

Random Forest Classifier

After evaluation, Random Forest was selected due to its:

Higher classification accuracy

Robustness against overfitting

Strong performance on tabular feature data

8. Model Evaluation

The models were evaluated using standard performance metrics:

Accuracy

Precision

Recall

Comparative analysis results are documented in the project report.

9. Application Workflow

User enters a URL through the web interface

Backend receives the request

URL features are extracted and normalized

Features are passed to the trained ML model

Model predicts:

Legitimate (Green)

Phishing (Red)

Result is displayed to the user in real time

10. Technology Stack

Programming Language: Python

Backend Framework: Flask

Machine Learning: scikit-learn

Frontend: HTML5, CSS3

Data Processing: pandas, numpy

11. Project Structure
phishing-url-detection-ml/
│
├── backend/
│   ├── app.py
│   ├── model.pkl
│   └── feature_extraction.py
│
├── frontend/
│   ├── index.html
│   └── styles.css
│
├── docs/
│   ├── Project_Report.docx
│   ├── Presentation.pptx
│   └── Diagrams/
│
├── requirements.txt
└── README.md

12. Setup Instructions
Prerequisites

Python 3.9 or higher

pip package manager

Installation Steps

Extract the ZIP file

Navigate to the project directory

Install dependencies:

pip install -r requirements.txt


Navigate to the backend directory:

cd backend


Run the Flask application:

python app.py


Open your browser and access:

http://127.0.0.1:5000

Common Setup Notes

Ensure Python is added to the system PATH

Make sure port 5000 is not already in use

Using a virtual environment is optional

13. System Requirements

Operating System: Windows / macOS / Linux

Hardware: Standard system (no GPU required)

14. Limitations

Designed for academic and demonstration purposes

Not intended for real-world production deployment

Model performance depends on dataset quality

Does not replace enterprise-grade security systems

15. Future Enhancements

Integration of deep learning models

Real-time dataset updates

Browser extension support

Deployment using cloud services

16. Academic Use Disclaimer

This project is developed strictly for educational and academic purposes.
It should not be used for commercial or production-level security deployments without further enhancements and validation.

17. License & Support

Academic / educational use only

No personalized support or customization included

Users are expected to modify and extend the project independently if required

18. Conclusion

This project demonstrates a practical application of Machine Learning in Cybersecurity, providing a clear example of how phishing detection can be implemented using feature-based URL analysis and supervised learning techniques.