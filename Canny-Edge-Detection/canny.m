% Tyler Phillips
% phillity@iu.edu
% March 26, 2018

%% Canny Edge Detection

% J. Canny, "A Computational Approach to Edge Detection," 
% in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. PAMI-8, no. 6, pp. 679-698, Nov. 1986.

% http://ieeexplore.ieee.org/document/4767851/

function canny(filepath, sigma, lower_threshold, upper_threshold)
    %% Get command line parameters and read in image
    % Clear command line, make number formatting long
    clc
    format long
    % Check command line argument exists
    filepath_arg = exist('filepath','var');
    % If input argument is missing, print error message
    % Request needed arguments and give example usage
    if ~filepath_arg
        disp('Missing needed argument:')
        disp('filepath (string) - absolute path to image file')
        disp('sigma (double) - standard deviation of Gaussian')
        disp('lower_threshold (double) - lower threshold value for hysteresis thresholding [0,1]')
        disp('upper_threshold (double) - upper threshold value for hysteresis thresholding [0,1]')
        disp('Usage: canny(filepath, sigma, lower_threshold, upper_threshold)')
        return;
    end
    % Set optional parameter sigma default value to sqrt(2)
    if ~exist('sigma','var')
        sigma = sqrt(2);
    end
    % Optional parameter lower_threshold will be set dynamically
    if ~exist('lower_threshold','var')
        lower_threshold = [];
    end
    % Optional parameter upper_threshold will be set dynamically
    if ~exist('upper_threshold','var')
        upper_threshold = [];
    end
    % Read in image
    X = imread(filepath);
    % Turn to image grayscale if not already
    if ndims(X) == 3
        X = rgb2gray(X);
    end
    % Change input datatype to double
    X = double(X);
    
    %% Apply Gaussian filter derivate and obtain the directional gradients
    [Gx, Gy] = gradients(X,sigma);
    
    %% Use directional gradients to find gradient magnitude and orientation
    % Get gradient magnitude
    G_mag = sqrt(abs(Gx) .^ 2 + abs(Gy) .^ 2);
    % Normalize magnitude values [0,1]
    G_mag = G_mag / max(G_mag(:));
    % Get gradient orientation
    G_ori = atan2(Gy, Gx);
     
    %% Non-maxima suppression
    G_supp = non_maxima_suppression(G_mag, Gx, Gy);
    % Remove any edges on the edges of the image
    G_supp(1,:) = 0;
    G_supp(:,1) = 0;
    G_supp(end,:) = 0;
    G_supp(:,end) = 0;
    
    %% Set low and high hysteresis thresholds dynamically (if not given)
    [lower_threshold, upper_threshold] = set_thresholds(G_mag, lower_threshold, upper_threshold);
    
    %% Hysteresis thresholding
    % Apply lower threshold
    G_supp(G_supp < lower_threshold) = 0;
    % Connected components starting from strong edge pixels
    E = edge_linking(G_supp, lower_threshold, upper_threshold);
    imshow(E);
end
