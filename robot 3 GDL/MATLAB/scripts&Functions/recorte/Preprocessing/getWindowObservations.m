function [emg_out, label_out] = getWindowObservations(emg_in, label_in, options)
strideLength = options.strideLength;
windowLength = options.windowLength;
numClasses = length(emg_in);
emg_out = cell(1, numClasses);
label_out = cell(1, numClasses);
for class_i = 1:numClasses
    emgIn_class_i = emg_in{class_i};
    labelIn_class_i = label_in{class_i};
    numTrials = length(emgIn_class_i);
    count1 = 0;
    for trial_j = 1:numTrials
        emgIn_class_i__trial_j = emgIn_class_i{trial_j};
        labelIn_class_i__trial_j = labelIn_class_i{trial_j};
        emgLength = size(emgIn_class_i__trial_j, 1);
        count2 = 0;
        while true
            startPoint = strideLength*count2 + 1;
            endPoint = startPoint + windowLength - 1;
            if endPoint > emgLength
                break;
            end
            count1 = count1 + 1;
            count2 = count2 + 1;
            emg_out{class_i}{count1} = emgIn_class_i__trial_j(startPoint:endPoint, :);
            label_out{class_i}{count1} = labelIn_class_i__trial_j(startPoint:endPoint, 1);
        end
    end
end
return