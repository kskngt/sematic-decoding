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
&emsp; contains window-meaned high gamma powers (HGPs) for each participant  
&emsp; (actual data were represented by random numbers in this sample data)
&emsp;  - three-dimensional matrix : channel number x 80 (trials) x 10 (timepoints)  
&emsp;  - ECoG signals were recorded at a sampling rate of 2000 Hz, recalculated using an average reference,   
&emsp; &emsp; band-pass filtered (70 Hz to 150 Hz), and underwent the Hilbert transform
&emsp;  - cut from 500 ms pre- to 2000 ms post-stimulus presentation in each trial
&emsp;  - further divided into time bins of 250 ms, and the average HGP for each bin was calculated
* **data.tasklog**  
&emsp; 1 in column 1 and 1 to 20 in column 2 represents abstract word category,  
&emsp;&ensp; while 2 in column 2 and 21 to 40 in column 2 represents concrete word category  
* **data.gyrus**  
&emsp; gyrus for each electrode number
