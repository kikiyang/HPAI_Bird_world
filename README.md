# HPAI_Bird_world
- Supplementary materials for _Synchrony of Bird Migration with Global Dispersal of Avian Influenza H5 Clade 2.3.4.4 Reveals Exposed Bird Orders_
- [Preprint](https://www.biorxiv.org/content/10.1101/2023.05.22.541648v1.full)
- [OSF project](https://osf.io/7a2uk/)
- This README is for code; Data information is in the other two README files.

## System requirements
- The Python code should be run on Python 3.7, IDE: Jupyter Lab/Jupyter Notebook/Visual Studio Code
- The R code should be run on R 4.2.1
- The Matlab code should be run on Matlab 2020a
- BEAST scripts should be run by [BEAST v1.10.4](https://github.com/beast-dev/beast-mcmc)

## Installation guide
- Download the code on your computer
- Install BEAST v1.10.4, R 4.2.1 and Python 3.7 (See installation time on their websites)

## Demo
- The input data (or demo data) are in each folder for data analysis scripts
- The expected output demo is in each folder; the intermediate data are in folders or [OSF project](https://osf.io/7a2uk/) when the file size is too large.

## Instructions for use
1. PoultryTrade: run the script UNComtrade.py to collect poultry trade data with partnerCode.json as the input; run china_trade.m with china_trade.mat as input to add trade data within China
2. BEAST_Scripts: xml files for running phylogenetic analysis, discrete-trait phylogeography analysis, GLM-extended phylogeography analysis by BEAST; sequence data files
3. Bird_month_dist: 
  - SDM: Species distriution model in Python that uses 'basemap' of ecological variables (Table S1) and bird tracking data (demo is in the folder) to infer bird monthly distribution maps (outputs are on [OSF project](https://osf.io/7a2uk/))
  - Location_Bird_Prob: Extract bird distribution probability at locations of virus lineage movements
4. Markove Jump: run extract_jumpTrees.ipynb ([input: 2.3.4.4fAreaDTA+MJ.location.history.trees](https://osf.io/pkv9c/)) to extract virus lineage movement distribution (output: 2.3.4.4fAreaDTA_MJs_bi.txt in the folder); the output is used as input for running hist_markovJumps.ipynb to summarize virus lineage movement frequency during a year (output: virus_od_month_migtimes_bf3.csv) and plot violin polot in Figure 3; the output is used as input for running MarkovJumpMonthDis.R to plot histogram.
5. Association_Bird_Virus: using virus_od_month_migtimes_bf3.csv (output in 4) and 2.3.4.4_bird.csv (output in 3) as inputs to run ccf.R to calculate the correlation between virus lineage movements and bird distribution probablity, and also account for multiple comparisons. Outputs are in the folder.

## Data acknowledgement
We gratefully acknowledge all data contributors of virus genome sequences, i.e., the authors and their originating laboratories responsible for obtaining the specimens, and their submitting laboratories for generating the genetic sequence and metadata and sharing via the GISAID Initiative, on which this research is based. The metadata of the virus genome sequences are listed in Supplementary Dataset 1 and [README_GISAID_DATA.md](https://github.com/kikiyang/HPAI_Bird_world/blob/main/README_GISAID_DATA.md).

We also gratefully acknowledge all bird tracking data contributors, i.e., the authors and other researchers in their originating groups collecting the data and metadata and sharing via Movebank, on which this research is based. The principle investigator, contact person, citation or data repository DOI are listed in Supplementary Dataset 2 and [README_MOVEBANK_DATA.md](https://github.com/kikiyang/HPAI_Bird_world/blob/main/README_MOVEBANK_DATA.md). 

## Citation
## Citation
- For the article: Yang, Q., Wang, B., Lemey, P., Dong, L., Mu, T., Wiebe, R. A., Guo, F., Trovão, N. S., Park, S. W., Lewis, N., Tsui, J. L.-H., Bajaj, S., Cheng, Y., Yang, L., Haba, Y., Li, B., Zhang, G., Pybus, O. G., Tian, H., & Grenfell, B. (2024). Synchrony of Bird Migration with Global Dispersal of Avian Influenza Reveals Exposed Bird Orders. Nature Communications, 15(1), Article 1. https://doi.org/10.1038/s41467-024-45462-1
- For the GitHub Repository: Yang, Q., Wang, B. & Lemey, P. HPAI_Bird_world v1.0.0 https://doi.org/10.5281/zenodo.10480799
