# UC Berkeley Master's Program -- ARGO Buoy Capstone

This repository contains the code, presentations, and final report for a semester-long group project by Axel Amzallag, Joshua Hug, and Timothy Kalnins as part of STAT 222 (Masters of Statistics Capstone Project) at the University of California, Berkeley. The goal of the project was to try and connect temperature levels in the Pacific Ocean to typhoon starting locations. The ocean data was collected from the ARGO project's buoy data provided by the University of California, San Diego: https://argo.ucsd.edu/. The typhoon data was from the United States Navy's Joint Typhoon Warning Center: https://www.metoc.navy.mil/jtwc/jtwc.html?western-pacific.

### Quick Reference

The best way to read about the project's process and findings in an organized fashion is the **Final_Report.pdf** file (https://github.com/AxelAmzallag/Berkeley_Capstone_Project/blob/main/Final_Report.pdf) in the main directory. The main analysis and conclusions are all described in some detail in this file. 

A short, 15-slide PowerPoint summarizing the basics of the project is in the **Final_Presentation.pptx** file. This cannot be viewed in a browser but can be downloaded if a speedy overview of the project is desired.

### Complete Directory Explanation

From the Root directory of the repository:
- **Current_Data_Analysis**: Contains all R files that created the outputs for the final PowerPoint presentation and the final report. These files WILL NOT RUN unless the cleaned buoy data is located on the local machine. Some of the plots used in the final presentation can be found in the Outputs sub-directory, and the saved version of the scattered t-distribution General Additive Model in the RData sub-directory.
-  **Data_Pipeline**: Contains the cleaned and raw typhoon data, as well as the bash script used to download the ARGO data and the R script used to clean the ARGO data.
-  **Papers_Books_Manuals**: Contains various research papers, textbooks, and user manuals collected throughout the project.
-  **Past_Data_Analysis**: Contains all R files for the 1st (~1/3 of semester) and second (~2/3 of semester) presentations, as well as the PowerPoints and some outputs for those presentations. Most of these files were further updated and consolidated; their final versions are in the Current_Data_Analysis directory.
-  **Final_Presentation.pptx**: The final PowerPoint presentation of the semester. Includes bullet points about the project from start to finish, with little detail.
-  **Final_Report.pdf**: The final report submitted by Axel Amzallag. This file contains a detailed walk-through of the project methods, models, analysis, and conclusions.

