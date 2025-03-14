function complexityEstimation = CE(s)
% s is a signal where rows are time samples and columns are channels
signalDiff = diff(s);
complexityEstimation = sqrt(sum(signalDiff.^2));
return