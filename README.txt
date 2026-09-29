DATASETS - README
=================

This folder is where the training/test CSV datasets should be placed
if you want to RETRAIN the model from scratch.

The following files are expected:
  - legitimate_urlss.csv   (training: legitimate URLs with a 'url' column)
  - phishing_urlss.csv     (training: phishing URLs with a 'url' column)
  - test_legitimate_urls.csv  (test set)
  - test_phishing_urls.csv    (test set)

NOTE: You do NOT need these files to run the web application.
The pre-trained model (models/random_forest_model.pkl) is already included
and the app will load it automatically.

These datasets are only required if you run: python src/train_model.py

Recommended public dataset sources:
  - https://www.kaggle.com/datasets/taruntiwarihp/phishing-site-urls
  - https://www.phishtank.com/
  - https://archive.ics.uci.edu/dataset/327/phishing+websites
