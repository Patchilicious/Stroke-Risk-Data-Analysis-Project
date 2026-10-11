Stroke Risk Analysis & Prevention



San Diego State University

MIS401: Business Intelligence & Analytics


Adam Bland

Patrick Nguyen

Gavin Robinett

Tristan Do

Zachary Wheeler


Executive Summary: 
	Strokes remain one of the leading causes of death and disability worldwide, making early detection and prevention extremely important. In this project, we analyzed a healthcare dataset from Kaggle containing demographics and medical information to identify key factors associated with stroke risk which we used to build predictive models.
Using logistic regression, k-nearest neighbors (kNN), and decision tree models, we examined relationships between patient characteristics and stroke occurrence. Our analysis found that age, hypertension, and heart disease are the most significant predictors of stroke.
Similar to how the sample report analyzes trends and external impacts on gas prices, our project focuses on identifying patterns and risk factors that influence stroke outcomes. The results of our models may very well benefit healthcare providers to better identify high-risk individuals and implement preventative measures against strokes.
Overall, predictive analytics in healthcare can improve decision-making, reduce costs, and enhance patient outcomes by enabling earlier intervention. With a health condition like a stroke, every minute matters and prevention is the way to beat it.


Discovery and Data Preparation: 
	The dataset used in this analysis was obtained from Kaggle and contains patient-level healthcare information related to stroke risk. Each observation represents one individual and includes demographic, medical, and lifestyle characteristics. The response variable is stroke, where a value of 1 indicates that the individual experienced a stroke and a value of 0 indicates that the individual did not. The dataset includes continuous variables such as age, average glucose level, and BMI, as well as categorical variables such as gender, work type, smoking status, hypertension, heart disease, and marital status.
Before building the models, the dataset was cleaned and prepared for analysis. Missing values were reviewed, especially in the BMI variable since it contained various incomplete observations. These missing values were handled so that the models could be run consistently. Categorical variables were converted into factor variables, and continuous variables were examined through summary statistics and visualizations. Because the response variable is binary, classification models such as logistic regression, k-nearest neighbors, and decision tree were appropriate for the analysis.
A preliminary exploration of the data showed clear differences between individuals who experienced a stroke and those who did not. Figure 2.1 compares age, average glucose level, and BMI by stroke outcome. The boxplots show that individuals who experienced a stroke tend to be older than those who did not. Average glucose level also appears higher among stroke cases, while BMI shows more overlap between the two groups. These results suggest that age and glucose level may be stronger predictors of stroke than BMI.
Categorical variables were also examined to better understand differences across groups. Figure 2.2 shows stroke outcome by gender, marital status, and work type. The gender plot shows similar stroke proportions for males and females, suggesting that gender may not be one of the strongest predictors in this dataset. The marital status plot shows a higher stroke proportion among individuals who have been married, which may be related to age since older individuals are more likely to have been married. The work type plot shows that self-employed individuals have a higher stroke proportion compared with other groups, which may also reflect age and lifestyle differences.
Additional plots were used to examine the most important risk factors before model building. Figure 2.3 shows the relationship between stroke risk and age, employment type, glucose level, hypertension, smoking status, and heart disease. The visual patterns show that stroke risk increases sharply with age and rises as glucose level increases. Individuals with hypertension and heart disease also show much higher stroke risk compared with individuals without those conditions. Smoking status and work type show some variation, but their effects appear less consistent than age, glucose level, hypertension, and heart disease.
Overall, the discovery and preparation stage provided a clear understanding of the dataset and helped guide the modeling process. The exploratory analysis suggested that age, average glucose level, hypertension, and heart disease were likely to be important predictors of stroke risk. These findings were then tested using logistic regression, k-nearest neighbors, and decision tree models in the following sections.


Results and Performance: 
3.1 Logistic Regression Analysis
	Logistic regression was used as the primary model due to the binary nature of the response variable (stroke vs. no stroke). The model provides both predictive performance and interpretability, allowing us to identify key variables that influence stroke risk.
The model achieved an overall accuracy of 80.33%, indicating a strong ability to correctly classify individuals. The confusion matrix shows that 439 non-stroke cases were correctly classified, while 43 stroke cases were correctly identified. However, the model misclassified 96 stroke cases as non-stroke, resulting in a Type II error rate of 0.338, which is a key limitation given the importance of detecting stroke cases.
The Type I error rate of 0.179 indicates that some non-stroke individuals were incorrectly predicted as having a stroke. The ROC curve shows strong model performance, with an AUC of approximately 0.8399, demonstrating that the model performs well in distinguishing between stroke and non-stroke cases.
Overall, logistic regression provides a strong balance between performance and interpretability, making it a valuable model for this analysis.


3.2 Top Contributing Factors: 
	To better understand the drivers of stroke risk, we analyzed the most influential variables identified in the logistic regression model.
Age shows the strongest relationship with stroke risk, with probability increasing sharply as age increases. This aligns with the dataset summary, where the average stroke patient age is significantly higher than the overall population. Similarly, average glucose level shows a positive relationship with stroke risk, indicating that individuals with elevated glucose levels are more likely to experience a stroke.
Medical conditions such as hypertension and heart disease also have a substantial impact. Additionally, stroke patients were significantly more likely to have hypertension, reinforcing its importance as a predictor.
Other variables such as smoking status and employment type show moderate variation in stroke risk, but their effects are less consistent compared to age and medical conditions. Overall, these results suggest that biological and medical factors play a larger role than demographic factors alone.
Figure 3.2.1 (Top contributing factors to stroke risk)



3.3 Decision Tree Analysis: 
  A decision tree model was developed to provide a more visual representation of stroke classification. As shown in Figure 3.3.1, the model identifies age as the most important variable, with the first split occurring at approximately 72 years.
Subsequent splits are based on average glucose level, BMI, and smoking status. These splits highlight how combinations of variables contribute to stroke risk. For example, individuals above a certain age with high glucose levels and elevated BMI are more likely to be classified as stroke cases.
The decision tree achieved an overall accuracy of approximately 84.83%, which is slightly higher than logistic regression. However, as shown in the confusion matrix (Figure 3.3.2), the model failed to correctly predict a large number of stroke cases, missing 86 stroke instances. Additionally, the model produced only a small number of false positives.
Despite its high accuracy, the p-value of 0.661 suggests that the model is not statistically strong in predicting stroke outcomes. This indicates that the model may be influenced by class imbalance and is less reliable for identifying true stroke cases.



3.4 kNN Analysis: 
	The kNN model was used to capture nonlinear relationships in the data. The model achieved an overall accuracy of 88.17%, the highest among the three models.
However, despite this high accuracy, the model performs poorly in identifying stroke cases. The confusion matrix shows that only 4 stroke cases were correctly predicted, while many stroke cases were misclassified. This results in an extremely high Type II error rate of 0.9385, indicating that the model fails to detect most stroke cases.
This highlights a key issue with imbalanced datasets, high accuracy does not necessarily indicate good performance. The model is heavily biased toward predicting the majority class (non-stroke), making it less useful for practical applications where identifying stroke cases is critical.


Conclusion: 
This project demonstrates how machine learning models can be used to analyze and predict stroke risk using healthcare data. By applying logistic regression, decision tree, and kNN models, we identified key variables that contribute to stroke and evaluated the effectiveness of different predictive approaches.
The analysis shows that age, hypertension, heart disease, and glucose levels are the most significant predictors of stroke. Age being the strongest predictor of stroke risk, with risk increasing dramatically in older populations. This suggests that screening programs and preventative care should prioritize aging individuals. Logistic regression provides the best balance of interpretability and predictive performance, while decision trees offer clear visualization of decision rules. Although kNN achieved the highest accuracy, it performed poorly in detecting stroke cases, making it less suitable for this problem.
One major limitation of this analysis is the imbalance in the dataset, which affects the ability of models to accurately predict stroke cases. Future work could involve techniques such as resampling to improve detection performance.
Overall, this project highlights the importance of predictive analytics in healthcare. By identifying high-risk individuals early, organizations can implement preventative strategies, reduce costs, and ultimately save lives.
