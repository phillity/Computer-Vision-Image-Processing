function R_sup = non_maxima_suppression(R)
    %% Suppress non-maxima values using 3-by-3 neighborhood
    R_sup = zeros(size(R));
    
    % Normalize R values 0 to 1
    R = R - min(R(:));
    R = R ./ max(R(:));
    
    % Pad R with top/bottom row and left/right col of -1
    R_pad = padarray(R, [1 1], -1, 'both');
    
    % Perform non-maxima suppression
    for r = 1:size(R,1)
        for c = 1:size(R,2)
            N = R_pad(r:r+2,c:c+2);
            if R(r,c) == max(N(:))
                R_sup(r,c) = R(r,c);
            end
        end
    end
end
