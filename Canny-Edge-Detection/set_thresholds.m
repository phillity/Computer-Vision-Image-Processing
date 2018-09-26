function [lower_threshold, upper_threshold] = set_thresholds(G_mag,lower_threshold, upper_threshold)
    %% Threshold selection constants
    % Percent of pixels which are  assumed to not be edge pixels (1 - non_edge_pixel_percent percent of pixels will be considered edge pixels)
    non_edge_pixel_percent = 0.7;
    % Set threshold ratio (lower threshold will be equal to threshold_ratio * upper_threshold)
    threshold_ratio = 0.4;
    
    %% Set thresholds
    % Set both thresholds
    if isempty(lower_threshold) && isempty(upper_threshold)
        % Split magnitude image histogram into 64 bins and find the number of pixels in each bin
        bin_cnts = imhist(G_mag,64);
        % Find upper threshold such that non_edge_pixel_percent percent of pixels are not edges
        upper_threshold = find(cumsum(bin_cnts) > non_edge_pixel_percent * size(G_mag,1) * size(G_mag,1));
        upper_threshold = upper_threshold(1) / 64;
        % Use threshold_ratio to set lower threshold
        lower_threshold = threshold_ratio * upper_threshold;
        
    % Use user defined upper threshold and set lower threshold
    elseif isempty(upper_threshold)
        % Use threshold_ratio to set upper threshold
        upper_threshold = lower_threshold / threshold_ratio;
       
    % Use user defined lower threshold and set upper threshold
    elseif isempty(lower_threshold)
        % Use threshold_ratio to set lower threshold
        lower_threshold = threshold_ratio * upper_threshold;
    
    % Use user defined thresholds
    else
        return;
    end
end