function [d, warpingPathRows, warpingPathCols] = myDTW(s1, s2, w, flagPlot)
% This function computes the DTW distance between two discrete signals s1
% and s2
if nargin == 2
    w = 1e3;
    flagPlot = false;
end
if nargin == 3
    flagPlot = false;
end

m = length(s1);
n = length(s2);
w = max(w, abs(m - n)); % This value is not used

% Initial settings
numElsWarpingPath = ceil( 5*sqrt(m^2 + n^2) );
warpingPathRows = zeros(1, numElsWarpingPath);
warpingPathCols = zeros(1, numElsWarpingPath);

% computing the cost matrix
costMtx = zeros(m, n);
if m < n
    for rowNum = 1:m
        costMtx(rowNum, :) = bsxfun(@minus,s1(rowNum), s2);
    end
else
    for colNum = 1:n
        costMtx(:, colNum) = bsxfun(@minus,s1, s2(colNum));
    end
end
costMtx = abs(costMtx);

% Finding the warping path and its cost(distance)
d = costMtx(1, 1);
warpingPathRows(1) = 1;
warpingPathCols(1) = 1;
count = 1;
val = zeros(1, 3);
while ~(warpingPathRows(count) == m && warpingPathCols(count) == n)
    % C(i + 1, j)
    if (warpingPathRows(count) + 1) <= m
        val(1) = costMtx(warpingPathRows(count) + 1, warpingPathCols(count));
    else
        val(1) = Inf;
    end
    % C(i, j + 1)
    if (warpingPathCols(count) + 1) <= n
        val(2) = costMtx(warpingPathRows(count), warpingPathCols(count) + 1);
    else
        val(2) = Inf;
    end
    % C(i + 1, j + 1)
    if ( (warpingPathRows(count) + 1) <= m ) && ( (warpingPathCols(count) + 1) <= n )
        val(3) = costMtx(warpingPathRows(count) + 1, warpingPathCols(count) + 1);
    else
        val(3) = Inf;
    end
    [min_d, idx] = min(val);
    d = d + min_d;
    switch idx
        case 1
            warpingPathRows(count + 1) = warpingPathRows(count) + 1;
            warpingPathCols(count + 1) = warpingPathCols(count);
        case 2
            warpingPathRows(count + 1) = warpingPathRows(count);
            warpingPathCols(count + 1) = warpingPathCols(count) + 1;
        case 3
            warpingPathRows(count + 1) = warpingPathRows(count) + 1;
            warpingPathCols(count + 1) = warpingPathCols(count) + 1;
    end
    count = count + 1;
    
end
warpingPathRows = warpingPathRows( 1:(count - 1) );
warpingPathCols = warpingPathCols( 1:(count - 1) );

if flagPlot
    figure;
    plot(s1(warpingPathRows));
    hold all;
    plot(s2(warpingPathCols));
    hold off;
    legend('s_1', 's_2');
    title('Aligned signals');
    drawnow;
    
    figure;
    imagesc(costMtx);
    colormap jet;
    colorbar;
    xlabel('s_2');
    ylabel('s_1');
    title('Cost matrix');
    drawnow;
    
    figure;
    img = zeros(m, n);
    linIdx = sub2ind([m n], warpingPathRows, warpingPathCols);
    img(linIdx) = 1;
    se_dim = ceil( max(m*n*1e-6, 2) );
    se = strel('square', se_dim);
    img = imdilate(img, se);
    imshow(img);
    xlabel('s_2');
    ylabel('s_1');
    title('Warping path');
    drawnow;
end
return