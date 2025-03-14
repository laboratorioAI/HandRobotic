function dtwMatrix = dtwDistance(train_X, window_emg, w)
numTrainingClasses = length(train_X);
dtwMatrix = cell(1, numTrainingClasses);
for class_i = 1:numTrainingClasses
    train_emg_class_i = train_X{class_i};
    numTrainingTrials_class_i = length(train_emg_class_i);
    for trial_j = 1:numTrainingTrials_class_i
        train_emg_class_i__trial_j = train_emg_class_i{trial_j};
        numChannels = size(train_emg_class_i__trial_j, 2);
        for chanNum = 1:numChannels
            dtwMatrix{class_i}(trial_j, chanNum) = ...
                dtw_c(train_emg_class_i__trial_j(:, chanNum), window_emg(:, chanNum), w);
        end
    end
end
return