function [ X, Y ] = getXnY_mb( gestureData )
    code = gesture2code_mb(gestureData.gesture);
    all_emgs = gestureData.emg;
    numTrialsForEachGesture = length(all_emgs);
    X = cell(1, numTrialsForEachGesture);
    Y = cell(1, numTrialsForEachGesture);
    
    for i_emg = 1:numTrialsForEachGesture
        emgs = all_emgs{i_emg};
        [samples, ~] = size(emgs);
        % GET X
        X{i_emg} = emgs;

        % GET Y
        Y{i_emg} = repmat(code, samples, 1);
    end
end