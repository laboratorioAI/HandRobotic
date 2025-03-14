function d = dtw_m(s1, s2, w)
% This function computes the dtw distance between two time sequences. The
% time complexity of this algorithm is O(n*m), where n = length(s1) and 
% m = length(s2)

n = length(s1);
m = length(s2);
w = max(w, abs(n - m));
D = zeros(2, m + 1); % Accumulated cost matrix
D(1, 2:end) = Inf;
D(2, 1) = Inf;
for i = 2:(n + 1)
    for j = max(2, i - w):min(m + 1, i + w)
        D(2,j) = min([D(1,j), D(1,j-1), D(2,j-1)]) + abs(s1(i - 1) - s2(j - 1));
    end
    D(2,2:(max(2, i - w) - 1)) = Inf;
    D(2,(min(m + 1, i + w) + 1):end) = Inf;
    if i < (n + 1)
        D(1,:) = D(2,:);
        D(1,1) = Inf;
        D(2,:) = zeros(1,m + 1);
        D(2,1) = Inf;
    end
end
d = D(2,m + 1);
return