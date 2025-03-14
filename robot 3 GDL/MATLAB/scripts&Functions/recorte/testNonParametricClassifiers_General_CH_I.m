clc;
close all;
clear all;
warning off all;

addpath(genpath(pwd));
%% TOOLBOXES
%% =======================================================================
addpath('Read datasets');
addpath('Preprocessing');
addpath('Detect muscle activity');
addpath('Non parametric classifiers - toolbox');
addpath('Posprocessing');

%% COMMON DATA
%% =======================================================================
% Write a list for the rest of users OR load from a variable
users = {'JonathanZea',...
    'EdisonChung',...
    'EduardoCarrion',...
    'JefersonNarvaez',...
    'PatricioChavez',...
    'CristhianMotoche',...
    'KathyVivanco',...
    'MayRosero',...
    'GabyRamos',...
    'NathyCumbicos'};

%% SETTINGS
%% =======================================================================
gestures = {'relax', 'fist', 'wave_in', 'wave_out', 'fingers_spread', 'double_tap'};
% Filter configuration
options.rectFcn = 'abs'; % Function for emg rectification
[options.Fb, options.Fa] = butter(4, 0.05, 'low'); % Filter values
options.detectMuscleActivity = true; % Activates the detection of muscle activity
options.fs = 200; % Sampling frequency of the emg
options.minWindowLengthOfMuscleActivity = 150;
options.threshForSumAlongFreqInSpec = 10; % Threshold for detecting the muscle activity
options.plotSignals = true;
% Window classification parameters
options.dtwWindow = 50;
options.strideLength = 50;
options.windowLength = 200;
options.k = 5;
% Training and testing data folder
pathName = 'data';

%% Leave one out test
numIterations = length(users);
predictions = [];
targets = [];
time = [];
for it_i = 1:numIterations
    fprintf('Leave one out, iteration: %d/%d\n', it_i, length(users));
    %% TRAINING
    train_FilteredX = {};
    train_Y = {};
    for user_i = 1:length(users)
        if  user_i ~= it_i
            % Training samples
            version = 'training';
            [train_RawX_temp, train_Y_temp] = getTotalXnYByUser_mb(pathName, users{user_i}, version, gestures);
            train_FilteredX_temp = preProcessEMG(train_RawX_temp, options);
            
            % Concatenate training samples
            [train_FilteredX, train_Y] = ...
                concatenateTrainingData(train_FilteredX_temp, train_Y_temp, train_FilteredX, train_Y);
        end
    end
    %% TESTING
    % Testing sample
    version = 'testing';
    [test_RawX, test_Y] = getTotalXnYByUser_mb(pathName, users{it_i}, version, gestures(2:end));
    
    % Classification
    [predictedSeq, actualSeq, timeClassif] = classifyEMG_nonParametric(train_FilteredX, train_Y, ...
        test_RawX, test_Y, options);
    
    % Pos-processing labels
    [predictedLabels, actualLabels, timePos] = posProcessLabels(predictedSeq, actualSeq);
    
    % Concatenating predictions of several users
    predictions = [predictions, predictedLabels];
    targets = [targets, actualLabels];
    
    % Computing the time of processing
    estimatedTime = computeTime(timeClassif, timePos);
    time = [time, estimatedTime];
end

%% CONFUSION MATRIX AND TIME OF PROCESSING
listOfClassifiers = {'Entropy - DTW - kNN', 'DTW - kNN',...
    'Ensamble (Entropy - DTW - kNN)', 'Cross-Correlation - kNN',...
    'Ensamble (Cross-Correlation - DTW - kNN)'};
[numClassifiers, N] = size(predictions);
numClasses = length(gestures);
for classifier_i = 1:numClassifiers
    % Confusion matrix
    % Maps each label to a 0-1 vector
    predictions_01 = full(sparse(predictions(classifier_i, :), 1:N, 1, numClasses, N));
    targets_01 = full(sparse(targets(classifier_i, :), 1:N, 1, numClasses, N));
    figure;
    plotconfusion(targets_01, predictions_01);
    title(['Classifier: ' listOfClassifiers(classifier_i)]);
    drawnow;
    
    % Time of processing
    figure;
    histogram(time(classifier_i, :), 'EdgeColor', [0 0 0], 'FaceColor', 'auto',...
        'Normalization', 'count', 'NumBins', 175);
    title(['Classifier: ' listOfClassifiers(classifier_i)]);
    drawnow;
end