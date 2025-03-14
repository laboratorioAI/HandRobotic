function Pr = computeProbability(simMeasure, train_Y, k, method)
numClasses = length(simMeasure);
[numSamplesForEachGesture, numChannels] = size(simMeasure{1});
fullSimMeasure = zeros(numClasses*numSamplesForEachGesture, numChannels);
labelMatrix = zeros(numClasses*numSamplesForEachGesture, numChannels);
for i = 1:numClasses
    startPoint = (i - 1)*numSamplesForEachGesture + 1;
    endPoint = i*numSamplesForEachGesture;
    fullSimMeasure(startPoint:endPoint, :) = simMeasure{i};
    labelMatrix(startPoint:endPoint, :) = train_Y{i}{1}(1);
end

switch method
    case 'entropy'
        %% Entropy method
        [dummy, indices] = sort(fullSimMeasure);
        sorted_labelMatrix = labelMatrix(indices);
        % Estimating the probabilities
        kNearestLabels = sorted_labelMatrix(1:k, :);
        probMatrix = zeros(numClasses, numChannels);
        for i = 1:numClasses
            for chanNum = 1:numChannels
                matchVector = find(kNearestLabels(:, chanNum) == i);
                probMatrix(i, chanNum) = length(matchVector)/k;
            end
        end
        % Entropy
        PlogP = probMatrix.*log10(probMatrix)/log10(6);
        PlogP(isnan(PlogP)) = 0;
        entropy = -1*sum(PlogP);
        % Weights
        alpha = (1 - entropy)/(numChannels - sum(entropy));
        alpha( isnan(alpha) ) = 1/numChannels;
        % Mean Probabilty
        Pr = sum(probMatrix.*repmat(alpha, 6, 1), 2);
        
    case 'sumDTW'
        %% DTW method
        sum_DTWMatrix = sum(fullSimMeasure, 2);
        [dummy, indices] = sort(sum_DTWMatrix);
        sorted_labelVector = labelMatrix(indices, 1);
        % Estimating the probabilities
        kNearestLabels = sorted_labelVector(1:k);
        Pr = zeros(numClasses, 1);
        for i = 1:numClasses
            matchVector = find(kNearestLabels == i);
            Pr(i) = length(matchVector)/k;
        end
        
    case 'crossCorrelation'
        %% Cross-Correlation method
        mean_crossCorrelation = mean(fullSimMeasure, 2);
        [dummy, indices] = sort(mean_crossCorrelation, 'descend');
        sorted_labelVector = labelMatrix(indices, 1);
        % Estimating the probabilities
        kNearestLabels = sorted_labelVector(1:k);
        Pr = zeros(numClasses, 1);
        for i = 1:numClasses
            matchVector = find(kNearestLabels == i);
            Pr(i) = length(matchVector)/k;
        end
end
return