%% Otsu thresholding

% N. Otsu, "A Threshold Selection Method from Gray-Level Histograms," 
% in IEEE Transactions on Systems, Man, and Cybernetics, vol. 9, no. 1, pp. 62-66, Jan. 1979.

% https://ieeexplore.ieee.org/document/4310076/

function threshold = otsu(X_hist)
    total = sum(X_hist);
    sumB = 0;
    wB = 0;
    maximum = 0.0;
    sum1 = dot( (0:255), X_hist); 
    for i = 1:256
        wB = wB + X_hist(i);
        wF = total - wB;
        if wB == 0 || wF == 0
            continue;
        end
        sumB = sumB +  (i-1) * X_hist(i);
        mF = (sum1 - sumB) / wF;
        between = wB * wF * ((sumB / wB) - mF) * ((sumB / wB) - mF);
        if between >= maximum
            threshold = i;
            maximum = between;
        end
    end
end