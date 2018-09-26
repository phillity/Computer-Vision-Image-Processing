% Tyler Phillips
% phillity@umail.iu.edu
% February 12, 2018

%% Bio-Inspired Feature Extraction

% G. Guo, Guowang Mu, Y. Fu and T. S. Huang, 
% "Human age estimation using bio-inspired features," 
% 2009 IEEE Conference on Computer Vision and Pattern Recognition, Miami, FL, 2009, pp. 112-119.

% http://ieeexplore.ieee.org/document/5206681/

function Y = bif(filepath, bands, rotations)
    %% Get command line parameter and read in image
    % Clear command line, make number formatting long
    clc
    format long

    % Check command line arguments exist
    filepath_arg = exist('filepath','var');
    bands_arg = exist('bands','var');
    rotations_arg = exist('rotations','var');
    
    % If input argument is missing, print error message
    % Request needed arguments and give example usage
    if ~filepath_arg || ~bands_arg || ~rotations_arg
        disp('Missing needed argument:')
        disp('filepath (string) - absolute path to image file')
        disp('bands (int) - number of bands to apply in BIF feature extraction')
        disp('rotations (int) - number of rotations to apply in BIF feature extraction')
        disp('Usage: bif(filepath, bands, rotations)')
        return;
    end
    
    % Check that number of bands does not exceed limit
    if bands > 8 || bands <= 0
        disp('bands must be less than or equal to 8')
        return;
    end
    
    % Check that number of rotations is greater than 0
    if rotations <= 0
        disp('rotations must be greater than 0')
        return;
    end
    
    % Read in image
    X = imread(filepath);
    % Turn to image grayscale
    X = rgb2gray(X);

    % Change image datatype to double
    X = double(X);

    %% Default parameters for BIF
    % Cell sizes
    cell_sizes = [6, 8, 10, 12, 14, 16, 18, 20];

    % Gabor filter sizes
    gabor_sizes = [5,7 ; 9,11 ; 13,15 ; 17,19 ; 21,23 ; 25,27 ; 29,31 ; 33,35];

    % Gabor filter sigma values
    gabor_sigmas = [2.0,2.8 ; 3.6,4.5 ; 5.4,6.3 ; 7.3,8.2 ; 9.2,10.2 ; 11.3,12.3 ; 13.4,14.6 ; 15.8,17.0];

    % Gabor filter wavelength values
    gabor_wavelengths = [2.5,3.5 ; 4.6,5.6 ; 6.8,7.9 ; 9.1,10.3 ; 11.5,12.7 ; 14.1,15.4 ; 16.8,18.2 ; 19.7,21.2];

    % Gabor gamma value 
    gabor_gamma = 0.3;

    %% Initialize gabor filter bank
    Filter_Bank = [];
    for r = 1:rotations
        theta = pi / rotations * (r-1);

        for b = 1:bands
            kernel_1 = get_gabor_kernel(gabor_sizes(b,1), gabor_sizes(b,1), gabor_sigmas(b,1), theta, gabor_wavelengths(b,1), gabor_gamma, 0);
            kernel_2 = get_gabor_kernel(gabor_sizes(b,2), gabor_sizes(b,2), gabor_sigmas(b,2), theta, gabor_wavelengths(b,2), gabor_gamma, 0);

            kernel_1 = kernel_1 / (2 * gabor_sigmas(b,1) * gabor_sigmas(b,1) / gabor_gamma);
            kernel_2 = kernel_2 / (2 * gabor_sigmas(b,2) * gabor_sigmas(b,2) / gabor_gamma);

            Filter_Unit = {kernel_1, kernel_2, cell_sizes(b)};
            Filter_Bank = [Filter_Bank; Filter_Unit]; 
        end
    end

    %% Apply filter bank
    Features = {};
    features_dims = 0;
    for i = 1:size(Filter_Bank,1)
        R_1 = filter_2D(X, Filter_Bank{i,1}, 'reflect');
        R_2 = filter_2D(X, Filter_Bank{i,2}, 'reflect');
        
        R = max(R_1,R_2);
        Integral_Sum = integralImage(R);
        Integral_Sq = integralImage(R .^ 2);
        
        h_half = Filter_Bank{i,3} / 2;
        w_half = Filter_Bank{i,3} / 2;
        
        n_rows = floor((size(R,1) + h_half - 1) / h_half);
        n_cols = floor((size(R,2) + w_half - 1) / w_half);
        
        Feature = zeros(n_rows*n_cols, 1);
        pos = 1;
        for y_c = 0:h_half:size(R,1)-1
            y_0 = max(0,y_c-h_half);
            y_1 = min(size(R,1),y_c+h_half);
            
            for x_c = 0:w_half:size(R,2)-1
                x_0 = max(0,x_c-w_half);
                x_1 = min(size(R,2),x_c+w_half);
                
                area = (y_1 - y_0) * (x_1 - x_0);
                
                mean = Integral_Sum(y_1+1,x_1+1) - Integral_Sum(y_1+1,x_0+1) - Integral_Sum(y_0+1,x_1+1) + Integral_Sum(y_0+1,x_0+1);
                mean = mean / area;
                
                sd = Integral_Sq(y_1+1,x_1+1) - Integral_Sq(y_1+1,x_0+1) - Integral_Sq(y_0+1,x_1+1) + Integral_Sq(y_0+1,x_0+1);
                sd = sqrt(max(0.0, sd/area-mean*mean));
                
                Feature(pos) = sd;
                pos = pos + 1;
            end
        end
        Features = [Features; Feature];
        features_dims = features_dims + size(Feature,1);
    end
    
    %% Get output BIF feature vector
    Y = zeros(features_dims,1);
    offset = 1;
    for i = 1:size(Features,1)
        f_size = size(Features{i,1},1);
        Y(offset:offset+f_size-1,1) = Features{i,1};
        offset = offset + f_size;
    end
end

