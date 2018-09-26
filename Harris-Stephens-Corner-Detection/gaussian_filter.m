function Y = gaussian_filter(X, sigma)
    %% Setup 1D Gaussian filter and get its derivative
    f_size = ceil(5 * sigma);
    if mod(f_size,2) == 0
        f_size = f_size + 1;
    end
    x = -floor(f_size/2):floor(f_size/2);
    
    %% Get 1D Gaussian filter values
    G = (1 / (sqrt(2 * pi) * sigma)) * exp(-(x .^ 2) / (2 * sigma ^ 2));
    % Normalize filter so its values sum to 1
    G = G / sum(G);
    
    %% Get 2D Gaussian filter
    G = G' * G;
    
    %% Convolve with 2D Gaussian filter 
    Y = convolution(X, G);
end