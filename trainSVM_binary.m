function [trainedClassifier, validationAccuracy] = trainSVM_binary(trainingData)

% Auto-generated by MATLAB Statistics and Machine Learning Toolbox
% and modified by Keisuke Nagata in 2021, The University of Tokyo.

%{
  Returns a trained classifier and its accuracy. This code recreates the
  classification model trained in Classification Learner app. Use the
  generated code to automate training the same model with new data, or to
  learn how to programmatically train models.

   Input:
       trainingData: A table containing the same predictor and response
        columns as those imported into the app.

   Output:
       trainedClassifier: A struct containing the trained classifier. The
        struct contains various fields with information about the trained
        classifier.

       trainedClassifier.predictFcn: A function to make predictions on new data.

       validationAccuracy: A double containing the accuracy in percent. In
        the app, the History list displays this overall accuracy score for
        each model.

  Use the code to train the model with new data. To retrain your
  classifier, call the function from the command line with your original
  data or new data as the input argument trainingData.

  For example, to retrain a classifier trained with the original data set T, enter:
    [trainedClassifier, validationAccuracy] = trainClassifier(T)

  To make predictions with the returned 'trainedClassifier' on new data T2, use
    yfit = trainedClassifier.predictFcn(T2)

  T2 must be a table containing at least the same predictor columns as used
  during training. For details, enter:
    trainedClassifier.HowToPredict
%}

% Extract predictors and response
% This code processes the data into the right shape for training the model.
inputTable = trainingData;

predictorNames = {};
n = size(trainingData, 2) - 1;
if n == 1
    predictorNames = cellstr(['X']);
else
    for i = 1:n
        name = cellstr(['X' num2str(i)]);
        predictorNames(i) = name;
    end
end
predictors = inputTable(:, predictorNames);
response = inputTable.Category;
isCategoricalPredictor = repmat(false, 1, n);

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', [-1 1]);

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
if n == 1
    trainedClassifier.RequiredVariables = {'X'};
elseif n < 10 & n > 1
    B = {'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'X8', 'X9'};
    trainedClassifier.RequiredVariables = B(1:n);
elseif n < 100 & n > 9
    A = {};
    for i = 1:99
        ii = mod(i-1,11) + 1;
        i10 = floor((i-1)/11) + 1;
        if ii == 1
            j = i10;
        else
            j = 10*i10 + ii - 2;
        end
        A(i) = cellstr(['X' num2str(j)]);
    end
    B = {'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'X8', 'X9'};
    
    a = floor(n/10); b = n - 10*a;
    m = n - (9-a);
    C = {};
    C(1:m) = A(1:m);
    C(m+1:n) = B(a+1:9);
    trainedClassifier.RequiredVariables = C;
    
elseif n > 999
    AAA = {};
    for i = 1:9999
        ii = mod(i-1,1111); % ii=1~1110
        i1000 = floor((i-1)/1111) + 1;
        iii = mod(ii-1,111); % iii=1~110
        i100 = floor((ii-1)/111);
        i10 = floor((iii-1)/11);
        i1 = mod(iii-1,11) - 1;
        if ii == 0
            j = i1000;
        elseif iii == 0
            j = i1000*10 + i100;
        elseif i1 == -1
            j = i1000*100 + i100*10 + i10;
        else
            j = i1000*1000 + i100*100 + i10*10 + i1;
        end
        AAA(i) = cellstr(['X' num2str(j)]);
    end
    
    BBB = {};
    for i = 1:999
        ii = mod(i-1,111);
        i100 = floor((i-1)/111) + 1;
        i10 = floor((ii-1)/11);
        i1 = mod(ii-2,11);
        if ii == 0
            j = i100;
        elseif i1 == 10
            j = 10*i100 + i10;
        else
            j = 100*i100 + 10*i10 + i1;
        end
        BBB(i) = cellstr(['X' num2str(j)]);
    end
    
    a = floor(n/1000); b = floor((n-1000*a)/100); c = floor((n-1000*a-100*b)/10); d = n - 1000*a - 100*b - 10*c;
    m = 1111*(a-1) + 111*b + 11*c + d + 4;
    
    CCC = {};
    CCC(1:m) = AAA(1:m);
    CCC(m+1:n) = BBB(1000-n+m:999);
    trainedClassifier.RequiredVariables = CCC;
    
else
    AA={};
    for i = 1:999
        ii = mod(i-1,111);
        i100 = floor((i-1)/111) + 1;
        i10 = floor((ii-1)/11);
        i1 = mod(ii-2,11);
        if ii == 0
            j = i100;
        elseif i1 == 10
            j = 10*i100 + i10;
        else
            j = 100*i100 + 10*i10 + i1;
        end
        AA(i) = cellstr(['X' num2str(j)]);
    end
    
    BB = {};
    for i = 1:99
        i10 = floor((i-1)/11) + 1;
        if mod(i,11) == 1
            j = i10;
        else
            j = 10*i10 + mod((i-2),11);
        end
        BB(i) = cellstr(['X' num2str(j)]);
    end
    a = floor(n/100); b = floor((n-100*a)/10); c = n - 100*a - 10*b;
    m = 111*(a-1) + 11*b + c + 3;
    
    CC = {};
    CC(1:m) = AA(1:m);
    CC(m+1:n) = BB(100-n+m:99);
    trainedClassifier.RequiredVariables = CC;
end

trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2021a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 5);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
