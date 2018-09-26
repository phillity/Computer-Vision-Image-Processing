% Tyler Phillips
% phillity@iu.edu
% March 31, 2018

%% Harris-Stephens Corner Detection

% C. Harris and M. Stephens, 
% "A combined corner and edge detector," 
% in Proceedings of the fourth Alvey Vision Conference, pp. 147–151, August 1988.

% http://www.bmva.org/bmvc/1988/avc-88-023.pdf

function harris_stephens(filepath, sigma, k)
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
        disp('sigma (double) - standard deviation of Gaussian used to sum derivatives')
        disp('k (double) - constant used in cornerness function')
        disp('Usage: harris_stephens(filepath, sigma, k)')
        return;
    end
    % Read in image
    X = imread(filepath);
    % Save copy of input for later display
    X_in = X;
    % Turn to image grayscale if not already
    if ndims(X) == 3
        X = rgb2gray(X);
    end
    % Set optional parameter sigma default value to 1
    if ~exist('sigma','var')
        sigma = 1;
    end 
    % Set optional parameter k to default value 0.04
    if ~exist('lower_threshold','var')
        k = 0.04;
    end
    % Change input datatype to double
    X = double(X);
    
    %% Get image derivatives 
    Ix = convolution(X,[-1 0 1]);
    Iy = convolution(X,[-1 0 1]');
    
    %% Get square of derivatives
    Ixx = Ix .^ 2;
    Ixy = Ix .* Iy;
    Iyy = Iy .^ 2;
    
	%% Gaussian filter square derivatives
	Ixx = gaussian_filter(Ixx,sigma);
	Ixy = gaussian_filter(Ixy,sigma);
	Iyy = gaussian_filter(Iyy,sigma);

    %% Compute cornerness function
    R = (Ixx .* Iyy - Ixy .^2) - k * (Ixx + Iyy) .^ 2;
    
    %% Non-Maxima Suppression
    % Suppress using 3-by-3 neighborhood
    R_sup = non_maxima_suppression(R);
    % Threshold out any local maxima that are not at least 1/100 the value of the maximum value in R
    threshold = 0.01 * max(R(:));
    R_sup(R < threshold) = 0;
    % Remove any corners on the edges of the image
    R_sup(1,:) = 0;
    R_sup(:,1) = 0;
    R_sup(end,:) = 0;
    R_sup(:,end) = 0;
    
    %% Get corner locations
    idx = find(R_sup);
    coords = zeros([length(idx) 2],'like',R);
    [coords(:,2),coords(:,1)] = ind2sub(size(R),idx);
    
    %% Plot corners
    imshow(X_in);
    hold on;
    plot(coords(:,1), coords(:,2),'r*');
end