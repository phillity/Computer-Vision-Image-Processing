% Tyler Phillips
% phillity@umail.iu.edu
% February 5, 2018

%% Tan-Triggs Illumination Equalization

% Tan, X., and Triggs, B. 
% "Enhanced local texture feature sets for face recognition under difficult lighting conditions.". 
% IEEE Transactions on Image Processing 19 (2010), 1635–650.

% http://ieeexplore.ieee.org/document/5411802/

function Y = tan_triggs(filepath)
    %% Get command line parameter and read in image
    % Clear command line, make number formatting long
    clc
    format long

    % Check command line argument exists
    filepath_arg = exist('filepath','var');

    % If input argument is missing, print error message
    % Request needed argument and give example usage
    if ~filepath_arg
        disp('Missing needed argument:')
        disp('filepath (string) - absolute path to image file')
        disp('Usage: tan_triggs(filepath)')
        return;
    end

    % Read in image
    X = imread(filepath);
    % Turn to image grayscale
    X = rgb2gray(X);
    % Change image datatype to double
    X = double(X);
    % Get image dimensions
    rows = size(X, 1);
    cols = size(X, 2);

    %% Default parameters for Tan-Triggs
    % Gamma Correction 
    gamma = 0.2;
    % Difference of Gaussian (DoG) Filterings
    sigma_0 = 1;
    sigma_1 = 2;
    % Contrast Equalization
    alpha = 0.1;
    tao = 10;

    %% Gamma Correction
    Y = X .^ gamma;

    %% Difference of Gaussian (DoG) Filterings
    % Get kernel sizes
    size_0 = ceil(3 * sigma_0);
    size_1 = ceil(3 * sigma_1);
    % If kernel size is even, make odd
    if mod(size_0, 2) == 0
        size_0 = size_0 + 1;
    end
    if mod(size_1, 2) == 0
        size_1 = size_1 + 1;
    end
    % Create kernels for guassian filtering
    kernel_0 = fspecial('gaussian', [size_0, size_0], sigma_0);
    kernel_1 = fspecial('gaussian', [size_1, size_1], sigma_1);
    % Perform guassian filtering
    G_0 = imfilter(Y, kernel_0, 'replicate');
    G_1 = imfilter(Y, kernel_1, 'replicate');
    % Find difference of guassian filterings
    Y = G_0 - G_1;

    %% Contrast Equalization
    % Two stage normalization
    % First stage
    Y = Y / ((mean((abs(Y(:))) .^ alpha)) ^ (1 / alpha));
    % Second stage
    Y = Y / ((mean((min([tao * ones(1, rows * cols); abs(Y(:)')])) .^ alpha)) ^ (1 / alpha));
    % Nonlinear mapping
    Y = tao * tanh(Y / tao);

    %% Write out Tan-Triggs results
    % Get max and min values in image
    max_Y = max(max(Y));
    min_Y = min(min(Y));
    % Normalize image to 0-255
    Y = ceil(((Y - min_Y * ones(rows, cols)) ./ (max_Y *(ones(rows, cols)) - min_Y * (ones(rows, cols)))) * 255);
    % Convert double image back to uint8
    Y = uint8(Y);

    % Get input image filepath without extension
    image_name = extractBefore(filepath, ".");
    % Write out output image
    imwrite(Y, strcat(image_name, '_tan_triggs.jpg'));
end