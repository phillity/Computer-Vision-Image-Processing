% Tyler Phillips
% phillity@iu.edu
% April 22, 2018

%% Recursive Connected Components

% H. Samet and M. Tamminen, "Efficient component labeling of images of arbitrary dimension represented by linear bintrees," 
% in IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 10, no. 4, pp. 579-586, Jul 1988.

% https://ieeexplore.ieee.org/document/3918/

function connected_components(filepath)
    %% Get command line parameter and read in image
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
        disp('Usage: threshold(filepath)')
        return;
    end
    % Read in image
    X = imread(filepath);
    % Turn to image grayscale if not already
    if ndims(X) == 3
        X = rgb2gray(X);
    end
    
    %% Get binary image
    X_bin = binary(X);
    
    %% Connected components
    X_lb = double(X_bin) .* -1;
    X_lb =  padarray(X_lb, [1 1], 0, 'both');
    label = 0;
    X_lb = find_components(X_lb,label);
    X_lb(1,:) = [];
    X_lb(:,1) = [];
    X_lb(end,:) = [];
    X_lb(:,end) = [];
    
    %% Plot image, binary image and components image
    figure
    % Plot input image
    subplot(1,3,1)
    imshow(X)
    title('Input Image')
    % Plot binary image
    subplot(1,3,2)
    imshow(255 * mat2gray(X_bin))
    title('Binary Image')
    % Plot components image
    subplot(1,3,3)
    imshow(rescale(X_lb))
    title('Components Image')
end

function X_lb = find_components(X_lb,label)
    for r = 2:size(X_lb,1)-1
        for c = 2:size(X_lb,2)-1
            if X_lb(r,c) == -1
                label = label + 1;
                X_lb = search(X_lb,label,r,c);
            end
        end
    end
end

function X_lb = search(X_lb,label,r,c)
    if X_lb(r,c) == -1
        X_lb(r,c) = label;
        % Use 4-connected neighbor definition
        N = [r-1,c ; r+1,c ; r,c+1 ; r,c-1];  
        for i = 1:size(N,1)
           if X_lb(N(i,1),N(i,2)) == -1
               X_lb = search(X_lb,label,N(i,1),N(i,2));
           end
        end
    end
end