function c_cVal = crossCorrelation(train_X, window_emg)
numTrainingClasses = length(train_X);
c_cVal = cell(1, numTrainingClasses);
for class_i = 1:numTrainingClasses
    train_emg_class_i = train_X{class_i};
    numTrainingTrials_class_i = length(train_emg_class_i);
    for trial_j = 1:numTrainingTrials_class_i
        train_emg_class_i__trial_j = train_emg_class_i{trial_j};
        numChannels = size(train_emg_class_i__trial_j, 2);
        for chanNum = 1:numChannels
            kte = length(window_emg(:, chanNum));
            c_cVal{class_i}(trial_j, chanNum) = ...
                kte*max( xcorr(train_emg_class_i__trial_j(:, chanNum), window_emg(:, chanNum)) );
        end
    end
end
return