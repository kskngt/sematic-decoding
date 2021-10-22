%% Decoding abstract and comncrete word representation from ECoG high gamma activity
% conduct linear support vector machine classification
% leave-one-out cross validation: 79 trials as training data, the rest one trial as test data

% load sampledata.mat as demonstration

win = 500;  % bin width = 250ms
binnum = 10; % total time bins
binstart = 3; binend = 8; % analysis time window [0ms 2000ms]
KF = 'linear'; % type of Kernel Function 
PO = []; % Polynomial Order 
KS = 'auto'; % Kernel Scale 
BC = 1; % Box Constraints 

% epoch [-500ms 2000ms] is devided into time bins of 250ms width
for t = 1:binnum
    meanHGP(:,:,t) = nanmean(data.HGP(:,:,win*(t-1)+1:win*(t-1)+win),3);
end

Y = data.tasklog(:,1);
Y(Y==2) = -1; % Y==1:abstract, Y==-1:concrete
chIFG = data.gyrus.IFG;
chSM1 = data.gyrus.SM1;


% conduct SVM classification by two target-selection scheme
%   target 1: whole features (0-1500ms in all brain regions)
%   target 2: targeted features (250-1250ms in IFG & 1000-1500ms in SM1)
for target = 1:2
    % leave-one-out cross validation (80 folds in total)
    W = zeros(80,size(meanHGP,1),6);
    for T = 1:80 % T=test trial
        % normalization via [epostart~0]
        % convert to pseudo-Zscore via common baseline across the training data
        meanHGP_train = meanHGP;
        meanHGP_train(:,T,:) = [];
        
        for ch = 1:size(meanHGP_train,1)
            blpow_train = reshape(meanHGP_train(ch,:,1:binstart-1), [79*(binstart-1) 1]); % baseline is [-500ms 0ms]
            [Z, mu, sigma] = zscore(blpow_train);
            nmHGPch = (squeeze(meanHGP(ch,:,:)) - mu*ones(80,binnum))./(sigma*ones(80,binnum));
            nmHGP(ch,:,:) = nmHGPch;
        end
        clearvars ch i t Z mu sigma nmHGPch blpow_train
        
        % feature selection: Wilcoxon's rank sum test（p<0.05）
        retained_features = [];
        nmHGP_test = nmHGP(:,T,:);
        nmHGP_train = nmHGP;
        nmHGP_train(:,T,:) = NaN;
        
        absPower = nmHGP_train(:,find(Y==1),:);
        concPower = nmHGP_train(:,find(Y==-1),:);
        
        for ch = 1:size(nmHGP,1)
            abs = squeeze(absPower(ch,:,:));
            conc = squeeze(concPower(ch,:,:));
            if mean(isnan(abs),'all') ~= 1
                for t = 1:size(nmHGP,3)
                    [p, h] = ranksum(abs(:,t),conc(:,t)); % significant if h == 1
                    res(2,t) = p; res(1,t) = h;
                    AllPval(ch,t) = p;
                end
                a = find(res(1,:)==1);
                feature = zeros(3,size(a,2));
                feature(1,:) = ch; % ch
                feature(2,:) = a;  % bin
                feature(3,:) = res(2,a); % p value (extract if p<0.05)
                retained_features = [retained_features, feature];
            else
                AllPval(ch,:) = NaN;
            end
            clearvars a feature res
        end
        clearvars abs absPower ch conc concPower h p t
        
        
       %% SVM classification
        % 79trials as train data, the rest one trial as test data
        if target == 1
            final_features = retained_features(:,find(retained_features(2,:) >= binstart & retained_features(2,:) <= binend));
        elseif target == 2
            feat_IFG = retained_features(:,ismember(retained_features(1,:),chIFG));
            feat_IFG = feat_IFG(:,ismember(feat_IFG(2,:),[4 5 6 7]));
            feat_SM1 = retained_features(:,ismember(retained_features(1,:),chSM1));
            feat_SM1 = feat_SM1(:,ismember(feat_SM1(2,:),[7 8]));
            final_features = [feat_IFG feat_SM1];
        end
        
        X = []; % feature matrix
        for t = 1:size(final_features,2)
            aa = final_features(1,t); % ch
            bb = final_features(2,t); % bin
            X = [X, nmHGP(aa,:,bb)'];
        end
        
        rawMatrix = array2table(X);
        rawMatrix.Category = Y;
        traindata = rawMatrix;
        traindata(T,:) = [];
        testdata = rawMatrix(T,:);
        Ytest = Y(T,1);
        
        % Linear SVM
        [trainedClassifier, valAcc] = trainSVM_binary(traindata, KF, PO, KS, BC);
        Yfit = trainedClassifier.predictFcn(testdata);
        
        predAcc(T) = (Yfit == Ytest);
        F(T,:,:) = AllPval;
        
        % extract the weight of each predictors
        weight = trainedClassifier.ClassificationSVM.Beta;
        for i = 1:size(final_features,2)
            W(T,final_features(1,i),final_features(2,i)) = weight(i);
        end
    end
    
    PredictionAccuracy(target) = mean(predAcc,2)
    Pvalue_all{target} = F;
    PredictorWeights{target} = W;
    clearvars -except data win binnum binstart binend KF KS PO BC...
        PredictionAccuracy Pvalue_all PredictorWeights meanHGP Y chIFG chSM1 target P
end
