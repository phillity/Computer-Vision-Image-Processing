% Tyler Phillips
% phillity@umail.iu.edu
% February 19, 2018

%% OpenCV cv::filter2D to Matlab filter_2D Conversion
% https://github.com/opencv/opencv/blob/master/modules/imgproc/src/filter.cpp

% X - input image
% kernel - convolution kernel (or rather a correlation kernel), a single-channel floating point matrix
% borderType – pixel extrapolation method

function Y = filter_2D(X, kernel, border_type)
    [x_rows, x_cols] = size(X);
    [k_rows, k_cols] = size(kernel);

    % Force kernel dimensions to be odd values
    if mod(k_rows,2) == 0 || mod(k_cols,2) == 0
        disp('kernel dimensions must be odd');
    end

    % Initialize output matrix
    Y = zeros(x_rows, x_cols);

    % Get size of padding
    r_pad = floor(k_rows/2);
    c_pad = floor(k_cols/2);

    % Pad following OpenCV BORDER_REPLICATE aaaaaa|abcdefgh|hhhhhhh
    if strcmp(border_type,'replicate')
        X_pad = padarray(X, [r_pad c_pad], 'replicate', 'both');
    
    % Pad using rows and columns of zeros
    elseif strcmp(border_type,'zeros')
        X_pad = padarray(X, [r_pad c_pad], 0, 'both');
        
    % (By default) Pad following OpenCV BORDER_DEFAULT (same as BORDER_REFLECT101 and BORDER_REFLECT_101) gfedcb|abcdefgh|gfedcba
    elseif strcmp(border_type,'reflect') || border_type == []
        if r_pad >= x_rows || c_pad >= x_cols
            disp('For reflect padding, image dimensions must be greater than two times kernel dimensions plus one');
            return;
        end

        % Start out with 0 pad
        X_pad = padarray(X, [r_pad c_pad], 0, 'both');

        % Perform left and right side padding
        [x_pad_rows, x_pad_cols] = size(X_pad);
        for r = 1:x_rows
            for c = 1:c_pad
                X_pad(r+r_pad,c_pad-c+1) = X(r,c+1);
                X_pad(r+r_pad,x_cols+c_pad+c) = X(r,x_cols-c);
            end
        end

        % Perform top and bottom padding
        for r = 1:r_pad
            for c = 1:x_cols
                X_pad(r_pad-r+1,c+c_pad) = X(r+1,c);
                X_pad(x_rows+r_pad+r,c+c_pad) = X(x_rows-r,c);
            end
        end

        % Perform top left corner padding
        X_pad(1:r_pad, 1:c_pad) = rot90(X(2:r_pad+1, 2:c_pad+1),2);
        % Perform top right corner padding
        X_pad(1:r_pad, x_pad_cols-c_pad+1:x_pad_cols) = rot90(X(2:r_pad+1, x_cols-c_pad:x_cols-1),2);
        % Perform bottom left corner padding
        X_pad(x_pad_rows-r_pad+1:x_pad_rows, 1:c_pad) = rot90(X(x_rows-r_pad:x_rows-1, 2:c_pad+1),2);
        % Perform bottom right corner padding
        X_pad(x_pad_rows-r_pad+1:x_pad_rows, x_pad_cols-c_pad+1:x_pad_cols) = rot90(X(x_rows-r_pad:x_rows-1, x_cols-c_pad:x_cols-1),2);

    else
        disp('Unsupported border_type argument');
        disp('Supported types: replicate, reflection, zeros');
        return;
    end

    % Perform convolution (or rather actually correlation)
    for r = 1:x_rows
        for c = 1:x_cols
            Y(r,c) = sum(sum(kernel .* X_pad(r:r+k_rows-1, c:c+k_cols-1)));
        end
    end
end