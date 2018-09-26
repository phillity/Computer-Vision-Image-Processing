% Tyler Phillips
% phillity@iu.edu
% April 22, 2018

function X_bin = binary(X)
    %% Get image histogram
    X_hist_b = zeros(256,2);
    X_hist_b(:,1) = cumsum(ones(256,1)) - 1;
    for r = 1:size(X,1)
        for c = 1:size(X,2)
            X_hist_b(X(r,c)-1,2) = X_hist_b(X(r,c)-1,2) + 1;
        end
    end
    
    %% Smooth image histogram
    F = [1/9 ; 2/9 ; 3/9 ; 2/9 ; 1/9];
    X_hist_a = X_hist_b;
    X_hist_a(:,2) = convolution(X_hist_b(:,2),F);
    
    %% Find threshold using Otsu's method
    thresh = otsu(X_hist_a(:,2));
    
    %% Plot histograms and threshold
    figure
    % Plot histogram before smoothing
    subplot(1,2,1)
    stem(X_hist_b(:,1),X_hist_b(:,2))
    title('Before Smoothing')
    % Plot histogram after smoothing and threshold
    subplot(1,2,2)
    hold on
    stem(X_hist_a(:,1),X_hist_a(:,2))
    stem(thresh,max(X_hist_a(:)),'Color','r')
    title('After Smoothing')
    hold off
    
    %% Get binary image
    X_bin = X;
    X_bin(X >= thresh) = 1;
    X_bin(X < thresh) = 0;
end

