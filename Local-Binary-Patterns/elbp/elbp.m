% Tyler Phillips
% phillity@umail.iu.edu
% March 20, 2018

%% (Extended) Local Binary Patterns

% T. Ojala, M. Pietikainen and T. Maenpaa, 
% "Multiresolution gray-scale and rotation invariant texture classification with local binary patterns," 
% in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 24, no. 7, pp. 971-987, Jul 2002. 

% http://ieeexplore.ieee.org/document/1017623/

function Y = elbp(filepath, r, p)
    %% Get command line parameters and read in image
    % Clear command line, make number formatting long
    clc
    format long

    % Check command line arguments exists
    filepath_arg = exist('filepath','var');
    r_arg = exist('filepath','var');
    p_arg = exist('filepath','var');

    % If input arguments are missing, print error message
    % Request needed arguments and give example usage
    if ~filepath_arg || ~r_arg || ~p_arg
        disp('Missing needed arguments:')
        disp('filepath (string) - absolute path to image file')
        disp('r (int) - pixel radius of circular LBP neighborhood')
        disp('p (int) - number of neighbors in LBP neighborhood')
        disp('Usage: elbp(filepath, r, p)')
        return;
    end

    % Read in image
    X = imread(filepath);
    % Turn to image grayscale
    X = rgb2gray(X);
    % Change image datatype to double
    X = double(X);
    % Get image dimensions
    rows = size(X,1);
    cols = size(X,2);

    %% Perform (Extended) Local Binary Patterns
    % Initialize output image
    Y = zeros(rows-2*r,cols-2*r);
    
    for n = 0:p-1
        % Sample point location on circle
        x = -r * sin(2 * pi * n / p);
        y = r * cos(2 * pi * n / p);
        % Use bilinear interpolation to find sample point value
        c_x = ceil(x);
        f_x = floor(x);
        t_x = x - f_x;
        c_y = ceil(y);
        f_y = floor(y);
        t_y = y - f_y;
        % Interpolation weights
        w_1 = (1 - t_x) * (1 - t_y);
        w_2 = t_x * (1 - t_y);
        w_3 = (1 - t_x) * t_y;
        w_4 = t_x * t_y;
        % Iterate through image
        for i = r+1:rows-r
            for j = r+1:cols-r
                % Calculate interpolated point value
                t = w_1 * X(i+f_y,j+f_x) + w_2 * X(i+f_y,j+c_x) + w_3 * X(i+c_y,j+f_x) + w_4 * X(i+c_y,j+c_x);
                % Add LBP neighbor value to output
                Y(i-r,j-r) = Y(i-r,j-r) + (t > X(i,j)) * (2 ^ n);            
            end
        end      
    end
    
    %% Write out (Extended) Local Binary Patterns results
    % Convert double image back to uint8 and normalize to 0-255
    Y = uint8(255 * mat2gray(Y));
    % Get input image filepath without extension
    image_name = extractBefore(filepath, ".");
    % Write out output image
    imwrite(Y, strcat(image_name, '_elbp_', num2str(r), '_', num2str(p), '.jpg'));
end 
    
    