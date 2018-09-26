% Tyler Phillips
% phillity@umail.iu.edu
% February 5, 2018

%% (Original) Local Binary Patterns

% T. Ojala, M. Pietikainen and D. Harwood, 
% "Performance evaluation of texture measures with classification based on Kullback discrimination of distributions," 
% Proceedings of 12th International Conference on Pattern Recognition, Jerusalem, 1994, pp. 582-585 vol.1.

% http://ieeexplore.ieee.org/document/576366/

function Y = olbp(filepath)
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
        disp('Usage: olbp(filepath)')
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

    %% Perform (Original) Local Binary Patterns with fixed 3x3 neighborhood
    % Initialize output image
    Y = zeros(rows-2, cols-2);
    for i = 2:rows - 1
        for j = 2:cols - 1
            if X(i, j) >= X(i-1, j-1)
                Y(i-1,j-1) = Y(i-1,j-1) + (2 ^ 7);
            end

            if X(i, j) >= X(i, j-1)
                Y(i-1,j-1) = Y(i-1,j-1) + (2 ^ 6);
            end

            if X(i, j) >= X(i+1, j-1)
                Y(i-1,j-1) = Y(i-1,j-1) + (2 ^ 5);
            end   

            if X(i, j) >= X(i+1, j)
                Y(i-1,j-1) = Y(i-1,j-1) + (2 ^ 4);
            end 

            if X(i, j) >= X(i+1, j+1)
                Y(i-1, j-1) = Y(i-1, j-1) + (2 ^ 3);
            end

            if X(i, j) >= X(i, j+1)
                Y(i-1,j-1) = Y(i-1,j-1) + (2 ^ 2);
            end

            if X(i, j) >= X(i-1 ,j+1)
                Y(i-1,j-1) = Y(i-1,j-1) + (2 ^ 1);
            end

            if X(i, j) >= X(i-1, j)
                Y(i-1,j-1) = Y(i-1,j-1) + (2 ^ 0); 
            end
        end
    end

    %% Write out (Original) Local Binary Patterns results
    % Convert double image back to uint8
    Y = uint8(Y);
    % Get input image filepath without extension
    image_name = extractBefore(filepath, ".");
    % Write out output image
    imwrite(Y, strcat(image_name, '_olbp.jpg'));
end

