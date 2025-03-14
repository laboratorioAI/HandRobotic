function gesture = code2gesture_mb( code )
% CODESGESTURES - Changes a code into a gesture
%   CODES:
%       REST           = 1
%       FIST           = 2
%       WAVE_IN        = 3
%       WAVE_OUT       = 4
%       FINGERS_SPREAD = 5
%       DOUBLE_TAP     = 6
%   INPUT:
%       code - An integer that represents a gesture
%   OUTPUT:
%       gesture - A string with the name of a gesture

    gesture = 'relax';
    switch code
        case 1
            gesture = 'relax';
        case 2
            gesture = 'fist';
        case 3
            gesture = 'wave_in';
        case 4
            gesture = 'wave_out';
        case 5
            gesture = 'fingers_spread';
        case 6
            gesture = 'double_tap';
    end
end