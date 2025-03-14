function gestureData = LoadDataByGesture_mb(pathname, username, version, gesture)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here
    path = [pathname '\' username '\' version '\' username '_' gesture '.mat'];
    dataLoaded = load(path);
    gestureData = dataLoaded.dataGesture;
end