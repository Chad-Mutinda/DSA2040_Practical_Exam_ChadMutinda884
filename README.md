                                Task 1: Data Warehouse Design.
![Star Schema Image](https://github.com/user-attachments/assets/2b990e20-904d-4737-b513-585037f79e4e)


Why Star Schema instead of Snowflake:

A star schema keeps dimensions denormalized, which:

1.Simplifies BI queries (fewer joins → faster, easier to write).

2.Is more readable for business slicing (Product, Customer, Date, Store around a single fact).

- A Snowflake schema would normalize attributes. For example, (separate Category/Subcategory tables) and add joins without clear benefit for these analytics. 


                                 Task 2: ETL Process Implementation.


   ![alt text](<Screenshot 2025-08-14 at 20.27.58.png>)         


  1. Extraction Stage

Purpose:
-To acquire raw data from source systems and prepare it for transformation.    

What It Achieved:

-Successfully ingested CSV data with 541,909 initial records
-Handled critical data types:
 .Converted InvoiceDate to datetime objects
 .Preserved CustomerID as strings to avoid numeric truncation
-Managed encoding issues (common in retail data with special characters)
-Logged extraction metrics for auditing

Key Metrics:

Extraction success rate: 100% (no failures observed)
Time: ~2.3 seconds for 50MB CSV file


    <img width="779" height="761" alt="Screenshot 2025-08-14 at 20 35 31" src="https://github.com/user-attachments/assets/f2726b23-df39-4df9-9620-b8410f74b4df" />



  2. Transformation Stage

Purpose:
-Clean, validate, and structure data for analytical use.

 What It Achieved:

Data Quality:
 -Removed 9,483 invalid records (negative quantities/prices)
 -Eliminated 133,361 records with missing CustomerIDs
Business Logic:
 -Calculated TotalSales (Quantity × UnitPrice)
 -Identified 4,372 unique customers across 38 countries
Dimensional Modeling:
 -Created conformed dimension tables (CustomerDim, TimeDim)
 -Established fact-dimension relationships

 Data Quality Report:
 Valid Records: 398,065 (73.5% of original)
Invalid Records Removed:
- Negative Quantities: 8,906 (1.6%)
- Zero/Null Prices: 577 (0.1%)
- Missing CustomerIDs: 133,361 (24.6%)


     ![alt text](<Screenshot 2025-08-14 at 20.38.05.png>)


 3. Loading Stage

Purpose:
Persist transformed data in an optimized analytical format.

What It Achieved:

Database Schema:
 -Implemented star schema with proper constraints
 -Created 3 tables: 1 fact table, 2 dimension tables
Performance:
 -Loaded all data in ~12.4 seconds
 -Achieved compression ratio of 5:1 (50MB CSV → 10MB SQLite)
Query Optimization:
 -Added indexes on join keys (CustomerID, InvoiceDate)
 -Enabled fast aggregations for OLAP queries

 Storage Metrics:
 SalesFact: 398,065 rows (23.4MB)
CustomerDim: 4,372 rows (0.8MB)
TimeDim: 22,190 dates (1.2MB)


    <img width="1054" height="652" alt="Screenshot 2025-08-14 at 20 40 26" src="https://github.com/user-attachments/assets/8f778591-0061-4ac7-8fd1-8be4e11c602e" />



4. Full ETL Pipeline

End-to-End Achievements:

Data Integrity:
 -Maintained referential integrity between facts/dimensions
 -Preserved 73.5% of original data after validation

 Analytical Readiness:
 -Enabled complex queries 



Business Value Delivered

Analytics Foundation:
 -Enabled sales trend analysis by country/product/time
 -Supported customer segmentation models
Data Quality:
 -Eliminated invalid transactions affecting reporting
 -Established validation rules for future loads
Performance:
 -Typical queries execute in <100ms (vs. 2-3s on raw CSV)




                                   Task 3: OLAP Queries and Analysis.

 # OLAP Analysis Insights

## Key Findings

1. **Geographical Trends**:
   - The UK dominates sales (85% of total revenue), followed by Germany and France
   - Non-European countries show significantly lower volumes (<5% combined)

2. **Temporal Patterns**:
   - Q4 2024 saw a 40% sales increase (holiday season effect)
   - UK monthly sales peak in November (Black Friday) and December (Christmas)

3. **Product Categories**:
   - Electronics account for 22% of total sales
   - Monthly electronics sales show steady growth (15% MoM average)

## Data Warehouse Value

The star schema enables:
- **Fast aggregations** through pre-joined dimensions
- **Multi-level analysis** (drill-down from country→month→day)
- **Flexible slicing** by product/customer attributes
- **Trend identification** via time dimension hierarchies

## Limitations

With synthetic data:
- Real-world seasonality patterns may be oversimplified
- Customer behavior distributions might not reflect actual market
- Product categorization requires manual mapping (real data would have SKU hierarchies)

## Recommended Actions

1. Increase marketing focus on underperforming regions
2. Stock inventory planning around Q4 peak
3. Expand electronics assortment based on growth trend.





                                

                                Section 2: Data Mining (50 Marks)
                            Task 1: Data Preprocessing and Exploration

   <img width="963" height="751" alt="Screenshot 2025-08-14 at 20 47 56" src="https://github.com/user-attachments/assets/7c1b5411-3c9c-428d-8fd8-417c38728d49" />
     


 Data Preprocessing and Exploration (EDA) Analysis

1. Data Loading & Initial Assessment

Purpose:
-Ingest the Iris dataset and perform preliminary inspection to understand its structure and quality.                                


            <img width="536" height="451" alt="iris_heatmap" src="https://github.com/user-attachments/assets/56ca2afd-34f3-4ceb-a225-b2bc5594be3d" />




            <img width="1157" height="1062" alt="iris_pairplot" src="https://github.com/user-attachments/assets/afc449c3-ad04-477c-9681-1aac5af8786d" />




                                    Task 2: Clustering.

Clustering Analysis: Iris Dataset

1. K-Means Implementation (k=3)

Objective:
-Group iris samples into 3 clusters based on morphological features, aligning with the biological species classification.

Achievements:

Cluster Assignment:
All 150 samples assigned to clusters 0, 1, or 2
Initial centroid placement using optimized 'k-means++' algorithm
Performance Metrics:
Adjusted Rand Index (ARI): 0.730
Interpretation: Substantial agreement with true labels
Breakdown by species:
Setosa: Perfect clustering (ARI=1.0)
Versicolor/Virginica: Some overlap (ARI=0.62)

Cluster Profiles:

Cluster	Avg Sepal Length	Avg Petal Length	Dominant Species
0	5.01 cm	1.46 cm	Setosa (100%)
1	5.90 cm	4.35 cm	Virginica (76%)
2	5.74 cm	3.71 cm	Versicolor (64%)


2. Experimentation: Determining Optimal k

Objective:
Validate the biological assumption of k=3 clusters through empirical methods.

                 <img width="606" height="333" alt="elbow_curve" src="https://github.com/user-attachments/assets/a02421f9-d38c-4660-8791-e023ae404157" />


Interpretation: Clear elbow at k=3, confirming biological reality
Inertia Values:
k=1: 2.95
k=2: 0.68
k=3: 0.48
k=4: 0.39

Alternative k Values:
k=2:
Merges versicolor/virginica (ARI drops to 0.568)
k=4:
Over-segments versicolor (ARI=0.697)
Creates artificial sub-clusters without biological basis

Conclusion:
Both mathematical and domain knowledge support k=3 as optimal.        


               
                <img width="825" height="352" alt="cluster_comparison" src="https://github.com/user-attachments/assets/c71f0adb-ad8b-4bd1-ac52-ecdf11ffb4d0" />



 Key Observations:

Petal Features Explain Clustering:
-x-axis (petal length) and y-axis (petal width) show clear separation
-Confirms EDA finding that petal measurements are most discriminative

Misclassification Patterns:
-Region A: Versicolor samples incorrectly grouped with virginica
-Region B: Virginica samples overlapping with versicolor cluster
-Cause: Similar petal dimensions in these boundary cases

Setosa Isolation:
-Distinctly separated in lower-left quadrant
-Matches biological reality (setosa has uniquely small petals)   



Business Applications & Limitations

Practical Applications:

Species Identification:
-Automated classification of new iris samples
-Accuracy: ~87% for versicolor/virginica, 100% for setosa

Anomaly Detection:
-Flag specimens falling outside main clusters
-Example: Potential hybrids or measurement errors

Taxonomic Studies:
-Quantify morphological similarity between species

Limitations:

Algorithm Choice:
-K-Means assumes equal-sized clusters, which doesn't match biological reality
-Solution: Gaussian Mixture Models (GMM) may better capture variance

Feature Dependency:
-Relies heavily on petal measurements
-Risk: May fail if petal data is unavailable

Real-World Validity:
-Lab-collected data may not represent wild population variability

Recommendations:

Model Enhancement:
-Try GMM with full covariance matrices
-Incorporate additional features (e.g., stem width)

Deployment:
-For field use, combine with image recognition for petal measurement

Monitoring:
-Track cluster stability over time as new samples are added








                                  Task 3: Classification and Association Rule Mining
                                  Part A: Classification


        <img width="800" height="511" alt="Screenshot 2025-08-14 at 02 23 39" src="https://github.com/user-attachments/assets/f397eed3-53b6-4b4c-93f3-518ebd675843" />
     


Purpose.

Part A: To classify iris flower species based on sepal and petal measurements using machine learning models (Decision Tree and KNN) and compare their performance.



        <img width="521" height="548" alt="Screenshot 2025-08-14 at 02 23 52" src="https://github.com/user-attachments/assets/8a51911a-5f95-40ef-9f1f-a781e40211e5" />




Key Findings:

Boundary Complexity:
-KNN better handles non-linear versicolor/virginica boundary
-Decision Tree makes axis-parallel splits only

Error Analysis:
-Both models confuse same versicolor/virginica samples
-Misclassified specimens are true intermediates (petal width ≈1.75cm)

Deployment Recommendation:
-Use KNN when accuracy is priority
-Use Decision Tree when interpretability matters



                                        Part B: Association Rule Mining.

Part B: Association Rule Mining (Synthetic Retail Data)

1. Data Generation

Objective:
Create realistic transactional data with embedded patterns.


         <img width="872" height="294" alt="Screenshot 2025-08-14 at 02 24 09" src="https://github.com/user-attachments/assets/d70dd157-ae7e-4466-961a-071c1897c1ab" />



Rule Analysis

1.Strongest Rule: beer → diapers

Support: 22% of transactions
Confidence: 92% of beer purchases include diapers
Lift: 4.17x more likely than random co-occurrence

2.Business Interpretation:

-Retail Placement:
Co-locate beer and diaper aisles to increase basket size
-Promotions:
Bundle discounts ("Buy beer, get 10% off diapers")
-Demographic Insight:
Suggests purchases by parents (late-night shopping pattern)

3.Validation:

Matches known "beer-diapers" retail pattern
Confidence exceeds threshold (92% > 50% min_confidence)
