homedir='/fs/project/PAS1305/';
proj='/vols/';
group='/ADULTS/';
subjlist='/fs/project/PAS1305/scripts/Jin/fMRI/EG_PROJ/adults_list'; 
%subjlist='zlab033_01';
cond=[1 2 3 4]; %W-1, SW-2, L-3, F-4, l-5, Constant-6
%BaseLine=[6]; %constant

if ~iscellstr(subjlist)
    if exist(subjlist,'file')
        fid = fopen(subjlist);
        list=textscan(fid,'%s','CommentStyle','%');
        subs = list{1};
        fclose(fid);
    elseif ischar(subjlist)
        subs = {subjlist};
    else
        error('bad subjects')
    end
end

runs=[1 2];

for iSub=1:length(subs)
    
        disp(['loading data for ' subs{iSub} '...']);
    
        %exp=['vwfa_scrambled-runs_' num2str(runs(iRun)) '-fmcpr-tvm1.sm0.norm'];
        exp1=['vwfa_run' num2str(runs(1))]; 
        exp2=['vwfa_run' num2str(runs(2))];
        
        %exp2=['vwfa_scrambled-runs_' num2str(runs{iRun}(2)) '-fmcpr-tvm1.sm0.norm'];
        
        beta1=MRIread([homedir group subs{iSub} '/inorig/' exp1 '/' 'beta1_nodistcorr_sm0.nii.gz']);
        tmp=beta1; 
        tmp.vol=beta1.vol(:,:,:,1:4)-nanmean(beta1.vol(:,:,:,1:4),4);
        %beta.vol is 256x256x256x4, and nanmean(beta.vol(:,:,:,1:4),4) is
        %256x256x256; 2 sizes are compatible, can subtract directly       
        MRIwrite(tmp,[homedir group subs{iSub} '/inorig/' exp1 '/' 'beta1.norm_nodistcorr_sm0.nii.gz']);
        
        
        beta2=MRIread([homedir group subs{iSub} '/inorig/' exp2 '/' 'beta1_nodistcorr_sm0.nii.gz']);
        tmp=beta2;%tmp.vol=zeros(tmp.volsize); this doesn't matter 
        tmp.vol=beta2.vol(:,:,:,1:4)-nanmean(beta2.vol(:,:,:,1:4),4);        
        MRIwrite(tmp,[homedir group subs{iSub} '/inorig/' exp2 '/' 'beta1.norm_nodistcorr_sm0.nii.gz']);
        disp(['done for ' subs{iSub} '!']);
        
end

%% does subtract mean change correlation between runs?

% % create a region which has 300 voxels, and responses to 4 conditions:
% % 4x300
% a=[rand(1,300);rand(1,300);rand(1,300);rand(1,300)]; 
% 
% % add some differences between categories
% a(2,:)=a(2,:)+1.5;
% a(4,:)=a(4,:)+3;
% a(2,:)=a(2,:)-3;
% 
% % create data from run 2
% b=a;
% 
% % add correlation within categories
% b(1,:)=a(1,:)*0.7+rand(1,300);
% b(2,:)=a(2,:)*0.2+rand(1,300);
% b(3,:)=a(3,:)*0.8+rand(1,300);
% b(4,:)=a(4,:)*1.2+rand(1,300);
% 
% % between runs corr
% %    0.5834   -0.0440    0.0067    0.0007
% %   -0.0389    0.1371   -0.0267    0.0488
% %    0.0057    0.0309    0.6117    0.0729
% %   -0.0170   -0.0056    0.1314    0.7865
% 
% % in the case where we subtract mean across conditions:
% 
% a2=a-mean(a,1);
% b2=b-mean(b,1);
% corr(a2',b2');
% 
% % between runs corr -- you can see the overall corr ma
% %    0.5916   -0.0503   -0.2070   -0.3001
% %   -0.0412    0.3154   -0.1076   -0.1075
% %   -0.1998   -0.0450    0.5530   -0.2643
% %   -0.3630   -0.2410   -0.2362    0.6966
            