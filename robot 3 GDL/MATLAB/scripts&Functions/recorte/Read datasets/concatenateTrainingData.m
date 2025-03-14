function  [X, Y] = concatenateTrainingData(X_temp, Y_temp, X, Y)
numClasses = length(X_temp);
for class_i = 1:numClasses
    % Feature vectors
    X_temp_class_i = X_temp{class_i};
    Y_temp_class_i = Y_temp{class_i};
    numTrials_temp = length(X_temp_class_i);
    try
        X_class_i = X{class_i};
        Y_class_i = Y{class_i};
        numTrial = length(X_class_i);
    catch
        numTrial = 0;
    end
        
    for trial_j = 1:numTrials_temp
        numTrial = numTrial + 1;
        X_class_i{numTrial} = X_temp_class_i{trial_j};
        Y_class_i{numTrial} = Y_temp_class_i{trial_j};
    end
    X{class_i} = X_class_i;
    Y{class_i} = Y_class_i;
    delete('X_class_i','Y_class_i');
end
return