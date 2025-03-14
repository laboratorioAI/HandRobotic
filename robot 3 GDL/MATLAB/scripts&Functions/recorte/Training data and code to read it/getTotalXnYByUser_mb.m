function [X, Y] = getTotalXnYByUser_mb(pathname, username, version, gestures)
numClasses = length(gestures);
X = cell(1, numClasses);
Y = cell(1, numClasses);
for class_i = 1:numClasses
    gestureData = LoadDataByGesture_mb(pathname, username, version, gestures{class_i});
    [tmpX, tmpY] = getXnY_mb(gestureData);
    X{class_i} = tmpX;
    Y{class_i} = tmpY;
end
end