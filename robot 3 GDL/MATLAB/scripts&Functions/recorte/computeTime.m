function totalTime = computeTime(timeClassification, timePosprocessing)
numClasses = length(timeClassification);
totalTime = [];
for class_i = 1:numClasses
    timeC_class_i = timeClassification{class_i};
    timeP_class_i = timePosprocessing{class_i};
    numTimes_class_i = length(timeC_class_i);
    for trial_j = 1:numTimes_class_i
        time_classification = timeC_class_i{trial_j};
        time_posprocessing = timeP_class_i{trial_j};
        totalTime = [totalTime time_classification + time_posprocessing];
    end
end
return