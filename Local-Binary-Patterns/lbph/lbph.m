function Feature = lbph(X, r, p, cells_x, cells_y, img_dims)
    % Change image datatype to double
    X = double(X);
    % Resize X accodring to img_dims
    X = reshape(X,img_dims);
    % Get image dimensions
    rows = size(X,1);
    cols = size(X,2);

    %% Perform (Extended) Local Binary Patterns
    % Initialize elbp image
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
    
    %% Split ELBP image into spatial histograms and retreive feature vector
    % Initialize output LBPH feature
    Feature = [];
    % Get spatial histogram size (x - horizontal, y - vertical)
    hist_x = round(size(Y,2) / cells_x);
    hist_y = round(size(Y,1) / cells_y);
    % Get histogram bins with number of bins 2 ^ p
    hist_bins = zeros(2 ^ p, 1);
    % Iterate over histograms
    for i = 1:cells_x
        for j = 1:cells_y
            % Get spatial histogram contents, careful to stay within matrix dimensions
            if (i-1) * hist_x + hist_x <= size(Y,2) && (j-1) * hist_y + hist_y <= size(Y,1)
                Hist = Y((j-1) * hist_y + 1:(j-1) * hist_y + hist_y, (i-1) * hist_x + 1:(i-1) * hist_x + hist_x);
            elseif (i-1) * hist_x + hist_x > size(Y,2) && (j-1) * hist_y + hist_y <= size(Y,1)
                 Hist = Y((j-1) * hist_y + 1:(j-1) * hist_y + hist_y, (i-1) * hist_x + 1:size(Y,2));
            elseif (i-1) * hist_x + hist_x <= size(Y,2) && (j-1) * hist_y + hist_y > size(Y,1)
                Hist = Y((j-1) * hist_y + 1:size(Y,1), (i-1) * hist_x + 1:(i-1) * hist_x + hist_x);
            else
                Hist = Y((j-1) * hist_y + 1:size(Y,1), (i-1) * hist_x + 1:size(Y,2));
            end
            % Place values into bins
            for k = 0:(2^p)-1
                hist_bins(k+1) = sum(Hist(:) == k);
            end
            % Place bin values into output LBPH feature
            Feature = [Feature ; hist_bins];
        end
    end
end 
    
    