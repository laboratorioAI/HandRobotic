function [predictedLabels, actualLabels, time] = posProcessLabels(predictedSeq, actualSeq)
numClasses = length(predictedSeq);
predictedLabels = [];
actualLabels = [];
time = cell(1, numClasses);
for class_i = 1:numClasses
    numTestingSamples_class_i = length(predictedSeq{class_i});
    finalPredictedLabels_class_i = [];
    finalActualLabels_class_i = [];
    for sample_j = 1:numTestingSamples_class_i
        predictions = predictedSeq{class_i}{sample_j};
        predictions(:, 1) = 1; % The first classification is always the class "rest"
        % Posprocessing labels
        pos_processedLabels = predictions;
        numLabels = size(predictions, 2);
        numClassifiers = size(pos_processedLabels, 1);
        time{class_i}{sample_j} = zeros(numClassifiers, numLabels);
        for label_i = 2:numLabels
            tStart = tic;
            cond = predictions(:, label_i) == predictions(:,label_i - 1);
            pos_processedLabels(:, label_i)  = 1*(cond) + predictions(:, label_i).*(1 - cond);
            time{class_i}{sample_j}(:, label_i) = toc(tStart)/numClassifiers;
        end
        time{class_i}{sample_j}(:, 1) = time{class_i}{sample_j}(:, 2);
        
        % Final label of the sample
        finalLabel = zeros(numClassifiers, 1);
        for classifier_i = 1:numClassifiers
            uniqueLabels = unique(pos_processedLabels(classifier_i, :));
            uniqueLabelsWithoutRest = uniqueLabels(uniqueLabels ~= 1);
            if isempty(uniqueLabelsWithoutRest)
                finalLabel(classifier_i) = 1; % No gesture detected
            else
                if length(uniqueLabelsWithoutRest) > 1
                    finalLabel(classifier_i) = uniqueLabelsWithoutRest(1); % Mistake
                else
                    finalLabel(classifier_i) = uniqueLabelsWithoutRest; % Correct
                end
            end
        end
        finalPredictedLabels_class_i = [finalPredictedLabels_class_i, finalLabel];
        aux = actualSeq{class_i}{sample_j}*ones(numClassifiers, 1);
        finalActualLabels_class_i = [finalActualLabels_class_i, aux];
    end
    predictedLabels = [predictedLabels, finalPredictedLabels_class_i];
    actualLabels = [actualLabels, finalActualLabels_class_i];
end
return