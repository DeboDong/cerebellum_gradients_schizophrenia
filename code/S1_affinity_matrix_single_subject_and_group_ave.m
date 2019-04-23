%Scripts for calculating the affinity matrix for each subject and group average (all subjects), 
%created by Debo Dong, debo.dong@gmail.com
% data after preprocessing; organize file for each subject into specific format,
% like, '/your_data/sub001/Filtered_4DVolume.nii';'/your_data/sub002/Filtered_4DVolume.nii'
Timepoints=N;
pathdata='/your_data/';
outputpath='/affinity_matrix/';%path of output
mask_cerebral='/R_rcrebral_cortex.nii';% cerebral mask
mask_cerebellar='/Reslice_Cerebellum.nii';% cerebellar mask
mkdir(outputpath,'cerebellar_cerebellar');% to store  affinity matrix of cerebellar_cerebellar FC 
mkdir(outputpath,'cerebellar_cerebral');% to store  affinity matrix of cerebellar_cerebral FC 
filenames=dir(pathdata);
filenames(1:2,:)=[];
%connectivity
V_cerebral=spm_vol(mask_cerebral);
Y_cerebral=spm_read_vols(V_cerebral);
V_cerebellar=spm_vol(mask_cerebellar);
Y_cerebellar=spm_read_vols(V_cerebellar);
all_subjects_cerebellar_timeseries=zeros(Timepoints*length(filenames),length(find(Y_cerebellar>0)));
all_subjects_cerebral_timeseries=zeros(Timepoints*length(filenames),length(find(Y_cerebral>0)));
% affinity matrix for single subject 
for m=1:length(filenames)
     filenames11=[pathdata filenames(m).name filesep 'Filtered_4DVolume.nii'];
     V1=spm_vol(filenames11);
     Y1=spm_read_vols(V1);
     data=reshape(Y1,size(Y1,1)*size(Y1,2)*size(Y1,3),length(V1));
     clear V1 Y1;
     data_cerebral=data(Y_cerebral>0,:)'; 
     data_cerebellar=data(Y_cerebellar>0,:)'; 
     clear data;
     % normalization for connecting serises of all subjects to create group average FC
     data_N_cerebellar=zscore(data_cerebellar);
     data_N_cereberal=zscore(data_cerebral);
     all_subjects_cerebellar_timeseries(((m-1)*size(data_cerebellar,1)+1):m*size(data_cerebellar,1),:)=data_N_cerebellar;
     all_subjects_cerebral_timeseries(((m-1)*size(data_cerebral,1)+1):m*size(data_cerebral,1),:)=data_N_cereberal;
     clear data data_N_cerebellar data_N_cereberal;
     % con_w1:cerebellar-cerebellar FC, con_w2: cerebellar-cerebral FC
     con_w1=corr(data_cerebellar);
     con_w1=con_w1-diag(diag(con_w1));
%      con_w1=fisherz(con_w1);
%      con_w1=reshape(con_w1,length(find(Y_cerebellar>0)),length(find(Y_cerebellar>0)));
     con_w2=corr(data_cerebellar,data_cerebral);
%      con_w2= fisherz(con_w2);
%      con_w2=reshape(con_w2,length(find(Y_cerebellar>0)),length(find(data_cerebral>0)));
     % affnix matrix for con_w1;
     bb=prctile(con_w1,90);
     for kk=1:size(con_w1,1)
         con_w1(kk,con_w1(kk,:)<bb(1,kk))=0;
     end
     con_w1(con_w1<0)=0;
     clear kk bb;
     Cosine_w=1-pdist(con_w1,'cosine'); 
     index = 1:size(con_w1,1)*size(con_w1,1);
     index = reshape(index,size(con_w1,1),size(con_w1,1))';
     index = triu(index,1);
     index=index';
     index=index(:)';
     index(index==0)=[];
     Cosine_w_cerebellar_cerebellar = zeros(size(con_w1,1),size(con_w1,1));
     Cosine_w_cerebellar_cerebellar(index) = Cosine_w;
     Cosine_w_cerebellar_cerebellar=Cosine_w_cerebellar_cerebellar+Cosine_w_cerebellar_cerebellar';
     for kk=1:size(con_w1,1)
        Cosine_w_cerebellar_cerebellar(kk,kk)=1;
     end
    clear kk;
    save([outputpath 'cerebellar_cerebellar' filesep filenames(m).name],'Cosine_w_cerebellar_cerebellar');
    clear con_w1 index Cosine_w Cosine_w_cerebellar_cerebellar;
     % affnix matrix for con_w2;
     bb=prctile(con_w2',90);
    for kk=1:size(con_w2,1)
        con_w2(kk,con_w2(kk,:)<bb(1,kk))=0;
    end
    con_w2(con_w2<0)=0;
    clear kk bb;
    Cosine_w=1-pdist(con_w2,'cosine'); 
    index = 1:size(con_w2,1)*size(con_w2,1);
    index = reshape(index,size(con_w2,1),size(con_w2,1))';
    index = triu(index,1);
    index=index';
    index=index(:)';
    index(index==0)=[];
    Cosine_w_cerebellar_cerebral = zeros(size(con_w2,1),size(con_w2,1));
    Cosine_w_cerebellar_cerebral(index) = Cosine_w;
    Cosine_w_cerebellar_cerebral=Cosine_w_cerebellar_cerebral+Cosine_w_cerebellar_cerebral';
    for kk=1:size(con_w2,1)
        Cosine_w_cerebellar_cerebral(kk,kk)=1;
    end
    clear kk;
    save([outputpath 'cerebellar_cerebral' filesep filenames(m).name],'Cosine_w_cerebellar_cerebral');
    clear index con_w2 Cosine_w Cosine_w_cerebellar_cerebral;
    ['finished_' num2str((m)) '/' num2str(length(filenames))]
end
% affinity_matrix for cerebellar-cerebellar average FC
con_w1=corr(all_subjects_cerebellar_timeseries);
con_w1=con_w1-diag(diag(con_w1));
% con_w1= fisherz(con_w1);
% con_w1=reshape(con_w1,length(find(Y_cerebellar>0)),length(find(Y_cerebellar>0)));
bb=prctile(con_w1,90);
for kk=1:size(con_w1,1)
    con_w1(kk,con_w1(kk,:)<bb(1,kk))=0;
end
con_w1(con_w1<0)=0;
clear kk bb;
Cosine_w=1-pdist(con_w1,'cosine'); 
index = 1:size(con_w1,1)*size(con_w1,1);
index = reshape(index,size(con_w1,1),size(con_w1,1))';
index = triu(index,1);
index=index';
index=index(:)';
index(index==0)=[];
Cosine_w_cerebellar_cerebellar = zeros(size(con_w1,1),size(con_w1,1));
Cosine_w_cerebellar_cerebellar(index) = Cosine_w;
Cosine_w_cerebellar_cerebellar=Cosine_w_cerebellar_cerebellar+Cosine_w_cerebellar_cerebellar';
for kk=1:size(con_w1,1)
     Cosine_w_cerebellar_cerebellar(kk,kk)=1;
end
clear kk;
save([outputpath 'cerebellar_cerebellar' filesep 'Ave_cerebellar_cerebellar'],'Cosine_w_cerebellar_cerebellar');
clear con_w1 index Cosine_w Cosine_w_cerebellar_cerebellar;
% affinity_matrix for cerebellar-cerebral average FC
con_w2=corr(all_subjects_cerebellar_timeseries,all_subjects_cerebral_timeseries);
% con_w2= fisherz(con_w2);
% con_w2=reshape(con_w2,length(find(Y_cerebellar>0)),length(find(data_cerebral>0)));
bb=prctile(con_w2',90);
for kk=1:size(con_w2,1)
    con_w2(kk,con_w2(kk,:)<bb(1,kk))=0;
end
con_w2(con_w2<0)=0;
clear kk bb;
Cosine_w=1-pdist(con_w2,'cosine'); 
index = 1:size(con_w2,1)*size(con_w2,1);
index = reshape(index,size(con_w2,1),size(con_w2,1))';
index = triu(index,1);
index=index';
index=index(:)';
index(index==0)=[];
Cosine_w_cerebellar_cerebral = zeros(size(con_w2,1),size(con_w2,1));
Cosine_w_cerebellar_cerebral(index) = Cosine_w;
Cosine_w_cerebellar_cerebral=Cosine_w_cerebellar_cerebral+Cosine_w_cerebellar_cerebral';
for kk=1:size(con_w2,1)
    Cosine_w_cerebellar_cerebral(kk,kk)=1;
end
clear kk;
save([outputpath 'cerebellar_cerebral' filesep 'Ave_cerebellar_cerebral'],'Cosine_w_cerebellar_cerebral');
clear index con_w2 Cosine_w Cosine_w_cerebellar_cerebral;
clear;

