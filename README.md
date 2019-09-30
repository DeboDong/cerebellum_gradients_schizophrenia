# cerebellum_gradients_schizophrenia
This is the matlab repository for the cerebellar gradient analysis in schizophrenia with preprocessed images (4D,nii) as input.

Requirements:
matlab >=2017b, SPM12 and preprocessed images (4D,nii)

How to run:

1.download and extract the 'gradients_analysis.rar'

2.organize preprocessed image file for each subject into specific format, put them into the dir '\gradients_analysis\data\', like, '\gradients_analysis\data\data\sub001\Filtered_4DVolume.nii';
'\gradients_analysis\data\data\sub002\Filtered_4DVolume.nii';etc

3.copy the 'mica_diffusionEmbedding.m' and 'mica_iterativeAlignment.m' from https://github.com/MICA-MNI/micaopen/tree/master/diffusion_map_embedding into the dir '\gradients_analysis\code\'

4. Add path in matlab, run addpath ('\gradients_analysis\code\')

5.set parameters like Timepoints, input file and run 'gradients_analysis\gradients_analysis.m'

please note, kb loop in the gradients_analysis.m cannot be run directly, but seperately run kb = 1 for cerebellar-cerebellar gradients; kb = 2 for cerebellar-cerebral cortex gradients; kb = 3 for cerebral-cerebellar cortex gradient; 
for example, run kb=1 till line 284, then based on the value of number_c (e.g., 14), change the number of 'nComponents',12 in the line 290 into 'nComponents',14.

Before running the gradients_analysis.m, please read the comments in gradients_analysis.m. 

Citation: Debo Dong, M.Sc, Dezhong Yao, Ph.D*, Xavier Guell, M.D, Yulin Wang, M.Sc, Hui He, Ph.D, Mingjun Duan, PhD, Simon B. Eickhoff, M.D, Cheng Luo, Ph.D1*. Compression of cerebellar functional gradients in schizophrenia. Under review.
Contact:debo.dong@gmail.com
