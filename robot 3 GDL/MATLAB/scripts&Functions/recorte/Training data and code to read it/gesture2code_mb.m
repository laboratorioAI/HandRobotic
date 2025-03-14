function code = gesture2code_mb(gesture)
% GESTURESTOCODES - Changes a gesture into a code
%   CODES:
%       REST           = 1
%       FIST           = 2
%       WAVE_IN        = 3
%       WAVE_OUT       = 4
%       FINGERS_SPREAD = 5
%       DOUBLE_TAP     = 6

    switch gesture
        case 'relax'
            code = 1;
        case 'fist'
            code = 2;
        case 'wave_in'
            code = 3;
        case 'wave_out'
            code = 4;
        case 'fingers_spread'
            code = 5;
        case 'double_tap'
            code = 6;
    end
end
