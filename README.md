# Decoding abstract and concrete word representation from electrocorticographic high gamma activity
Written by Keisuke Nagata in 2021, The University of Tokyo


## OVERVIEW
This Matlab script is for an original article titled “Spatiotemporal target selection for intracranial neural decoding of abstract and concrete semantics”(under submission).

It aims for decoding the inner representation of a word meaning from human cortical activity during the semantic property identification task.
The actual datasets applyed to this script are not readily available because the participants of this study did not agree for their data to be publicly shared.
Requests to access the datasets should be directed to the corresponding author of the article.  


## SAMPLE DATA 
Sample data is provided for demonstration. 

* **data.hemisphere**  
&emsp; shows whether the recorded hemisphere was language-dominant or non-language-domionant  
* **data.HGP**  
&emsp; contains high gamma powers (HGPs) for each participant (consists of random numbers in this sample data)  
&emsp;  - three-dimensional matrix : channel number x 80 (trials) x 5001 (timepoints)  
&emsp;  - ECoG signals were recorded in sampring rate of 2000 Hz, recalculated by average reference, band-pass filtered (70 to 150 Hz)   
&emsp; &emsp; and underwent Hilbert transform  
&emsp;  - start of word presentation period is regarded as 0 ms   
&emsp;  - epoched via [-500 to 2000 ms] for each trial  
* **data.tasklog**  
&emsp; 1 in column 1 and 1 to 20 in column 2 represents abstract word category,  
&emsp;&ensp; while 2 in column 2 and 21 to 40 in column 2 represents concrete word category  
* **data.gyrus**  
&emsp; gyrus for each electrode number
